#!/usr/bin/env python2
import shutil
import sys
import math
import datetime
import argparse
import tempfile
import os
import stat
from git import Repo

if sys.version_info[0] == 2:
    reload(sys)
    sys.setdefaultencoding('utf8')

BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
HEX_CHARS = "1234567890abcdefABCDEF"


def del_rw(action, name, exc):
    os.chmod(name, stat.S_IWRITE)
    os.remove(name)


def shannon_entropy(data, iterator):
    """
    Borrowed from http://blog.dkbza.org/2007/05/scanning-data-for-entropy-anomalies.html
    """
    if not data:
        return 0
    entropy = 0
    for x in (ord(c) for c in iterator):
        p_x = float(data.count(chr(x))) / len(data)
        if p_x > 0:
            entropy += - p_x * math.log(p_x, 2)
    return entropy


def get_strings_of_set(word, char_set, threshold=20):
    count = 0
    letters = ""
    strings = []
    for char in word:
        if char in char_set:
            letters += char
            count += 1
        else:
            if count > threshold:
                strings.append(letters)
            letters = ""
            count = 0
    if count > threshold:
        strings.append(letters)
    return strings


class bcolors:
    EOL = '<br/>'
    OKBLUE = '<font color="blue">'
    OKGREEN = '<font color="green">'
    WARNING = '<font color="orange">'
    FAIL = '<font color="red">'
    ENDC = '</font>'


def find_strings(git_url):
    project_path = tempfile.mkdtemp()

    Repo.clone_from(git_url, project_path)

    repo = Repo(project_path)

    already_searched = set()
    for remote_branch in repo.remotes.origin.fetch():
        branch_name = str(remote_branch).split('/')[1]
        try:
            repo.git.checkout(remote_branch, b=branch_name)
        except:
            pass

        prev_commit = None
        for curr_commit in repo.iter_commits():
            if not prev_commit:
                pass
            else:
                # avoid searching the same diffs
                hashes = str(prev_commit) + str(curr_commit)
                if hashes in already_searched:
                    prev_commit = curr_commit
                    continue
                already_searched.add(hashes)

                diff = prev_commit.diff(curr_commit, create_patch=True)

                for blob in diff:
                    # print i.a_blob.data_stream.read()
                    printable_diff = blob.diff.decode()
                    if printable_diff.startswith("Binary files"):
                        continue
                    found_something = False
                    lines = blob.diff.decode().split("\n")
                    for line in lines:

                        for word in line.split():
                            base64_strings = get_strings_of_set(word, BASE64_CHARS)
                            hex_strings = get_strings_of_set(word, HEX_CHARS)
                            for string in base64_strings:
                                b64_entropy = shannon_entropy(string, BASE64_CHARS)
                                if b64_entropy > 4.5:
                                    found_something = True
                                    printable_diff = printable_diff.replace(string,
                                                                            bcolors.WARNING + string + bcolors.ENDC)
                            for string in hex_strings:
                                hex_entropy = shannon_entropy(string, HEX_CHARS)
                                if hex_entropy > 3:
                                    found_something = True
                                    printable_diff = printable_diff.replace(string,
                                                                            bcolors.WARNING + string + bcolors.ENDC)
                    if found_something:
                        commit_time = datetime.datetime.fromtimestamp(prev_commit.committed_date).strftime(
                            '%Y-%m-%d %H:%M:%S')
                        print(bcolors.EOL)
                        print(bcolors.OKGREEN + "Date: " + commit_time + bcolors.ENDC)
                        print(bcolors.OKGREEN + "Branch: " + branch_name + bcolors.ENDC)
                        print(bcolors.OKGREEN + "Commit: " + prev_commit.message + bcolors.ENDC + bcolors.EOL)
                        print(printable_diff)

            prev_commit = curr_commit
    return project_path


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Find secrets hidden in the depths of git.')
    parser.add_argument('git_url', type=str, help='URL for secret searching')

    args = parser.parse_args()
    project_path = find_strings(args.git_url)
    shutil.rmtree(project_path, onerror=del_rw)
