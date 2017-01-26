#!/usr/bin/env python2

"""git pull-request

Automatically check out github pull requests into their own branch.

Usage:

    git pull-request <OPTIONS> [<pull request number>]

Options:

    -h, --help
        Display this message and exit

    -r <repo>, --repo <repo>
        Use this github repo instead of the 'remote origin' or 'github.repo'
        git config settings. Needs to be in "user/repository" form
    -t <token>, --token <token>
        Use this github Oauth token. Needs to be in "sdklttgjqklmergj47454qs4ef6rg7" form
    -b <base>,  --base <base>
        Use this github base repo of the pull request for verify the validity of one pull request.

Copyright (C) 2011 by Andreas Gohr <andi@splitbrain.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""
import sys
import getopt
import json
import urllib2
import os
import re
import pipes


def main():
    repo, remote = '', None
    base, token = '', None
    # parse command line options
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h:r:t:b:", ["help", "repo=", "token=", "base="])
    except getopt.error, msg:
        print msg
        print "for help use --help"
        sys.exit(418)
    # process options
    for opt, arg in opts:
        #print "o :" + opt + " a :" + arg
        if opt in ("-h", "--help"):
            print __doc__
            sys.exit(0)
        elif opt in ("-r", "--repo"):
            if re.search('/', arg):
                repo = arg
            else:
                remote = arg
        elif opt in ("-t", "--token"):
            token = arg
        elif opt in ("-b", "--base"):
            base = arg
        else:
            print __doc__
            sys.exit(0)


    if remote is None and repo=='':
        remote = 'origin'

    # attempt to get token from git config
    if(token == ''):
        token = os.popen("git config --get github.token").read().rstrip()
        #print "TOKEN local :"+token
    # get repo name from git config:
    if(repo == ''):
        repo = os.popen('git config github.repo').read().strip()

    # get repo name from origin
    if(repo == '' or remote is not None):
        escaped = pipes.quote(remote)
        origin = os.popen("git config remote.%s.url" % escaped).read()
        origin = re.sub("(\.git)?\s*$", "", origin)
        m = re.search(r"\bgithub\.com[:/]([^/]+/[^/]+)$", origin)
        if(m is not None):
            repo = m.group(1)

    if(repo == ''):
        print color_text("Failed to determine github repository name", 'red', True)
        print "The repository is usually automatically detected from your remote origin."
        print "If your origin doesn't point to github, you can specify the repository on"
        print "the command line using the -r parameter, by specifying either a remote or"
        print "the full repository name (user/repo), or configure it using"
        print "git config github.repo <user>/<repository>"
        sys.exit(418)

    # process arguments
    if len(args):
        ret = fetch(repo, token, args[0])
    else:
        ret = show(repo, token, base)

    sys.exit(ret)


def display(pr,base):
    """Nicely display info about a given pull request
    """
    result = 0
    print "%s - %s" % (color_text('REQUEST %s' % pr.get('number'), 'green'), pr.get('title'))
    print "    pull request of %s" % (color_text(pr['head']['label'], 'yellow'))
    print "    by %s %s" % (pr['user'].get('login'), color_text(pr.get('created_at')[:10], 'red'))
    print "    on base %s " % (color_text(pr['base']['label'], 'yellow'))
    print "    %s" % (color_text(pr.get('html_url'), 'blue'))
    print "base validity : %s " % (pr['base']['ref'] == base or base is None)
    print "state validity : %s " % (pr['state'] == "open")
    if(base is not None and pr['base']['ref'] != base):
        result += 5
    if (pr['state'] != "open"):
        result += 5
    print "validity : %s " % (result)
    return result

def show(repo, token, base):
    """List open pull requests

    Queries the github API for open pull requests in the current repo
    """
    print "loading open pull requests for %s..." % (repo)
    print
    url = "https://api.github.com/repos/%s/pulls" % (repo)

    if len(token):
        headers = {'User-Agent': 'git-pull-request', 'Authorization': 'token %s' % token}
    else:
        headers = {'User-Agent': 'git-pull-request'}

    req = urllib2.Request(
        url, headers=headers)
    try:
        response = urllib2.urlopen(req)
    except urllib2.HTTPError, msg:
        print "error loading pull requests for repo %s: %s" % (repo, msg)
        if msg.code == 404:
            # GH replies with 404 when a repo is not found or private and we request without OAUTH
            print "if this is a private repo, please set github.token to a valid GH oauth token"
        exit(1)

    data = response.read()
    if (data == ''):
        print "failed to speak with github."
        return 3

    data = json.loads(data)
    # print json.dumps(data,sort_keys=True, indent=4)
    founded = False
    for pr in data:
        founded |= display(pr,base)==0

    if founded:
        print "a good Pull Request existing."
        return 0
    else:
        print "No open pull request on the repository %s is existing." % repo
        return 418


def fetch(repo, token, pullreq):
    print "loading pull request info for request %s..." % (pullreq)
    print
    url = "https://api.github.com/repos/%s/pulls/%s" % (repo, pullreq)

    if len(token):
        headers = {'User-Agent': 'git-pull-request', 'Authorization': 'token %s' % token}
    else:
        headers = {'User-Agent': 'git-pull-request'}

    req = urllib2.Request(
        url, headers=headers)
    try:
        response = urllib2.urlopen(req)
    except urllib2.HTTPError, msg:
        print "error loading pull requests for repo %s: %s" % (repo, msg)
        if msg.code == 404:
            # GH replies with 404 when a repo is not found or private and we request without OAUTH
            print "if this is a private repo, please set github.token to a valid GH oauth token"
        exit(1)

    data = response.read()
    if (data == ''):
        print "failed to speak with github."
        return 3

    data = json.loads(data)
    pr = data
    print json.dumps(pr, sort_keys=True, indent=4, separators=(',', ': '))
    if pr['head']['repo'] is None:
        print("remote repository for this pull request "
              "does not exist anymore.")
        return 6
    display(pr)

    local = pipes.quote('pull-request-%s' % (pullreq))
    branch = os.popen("git branch|grep '^*'|awk '{print $2}'").read().strip()
    if(branch != pr['base']['ref'] and branch != local):
        print color_text("The pull request is based on branch '%s' but you're on '%s' currently" % (pr['base']['ref'], branch), 'red', True)
        return 4

    ret = os.system('git branch %s' % (local))
    ret = os.system('git checkout %s' % (local))
    if(ret != 0):
        print "Failed to create/switch branch"
        return 5

    print "pulling from %s (%s)" % (pr['head']['repo']['git_url'], pr['head']['ref'])

    git_url = pipes.quote(pr['head']['repo']['git_url'])
    ref = pipes.quote(pr['head']['ref'])
    print 'git pull %s %s' % (git_url, ref)
    ret = os.system('git pull %s %s' % (git_url, ref))
    if(ret != 0):
        print color_text("branch %s no longer exists." % ref, 'red')
        os.system('git checkout %s' % branch)
        os.system('git branch -D %s' % local)
        exit(1)

    print
    print color_text("done. examine changes and merge into master if good", 'green')

    return 0


def color_text(text, color_name, bold=False):
    """Return the given text in ANSI colors

    From http://travelingfrontiers.wordpress.com/2010/08/22/how-to-add-colors-to-linux-command-line-output/
    """
    colors = (
        'black', 'red', 'green', 'yellow',
        'blue', 'magenta', 'cyan', 'white'
    )

    if not sys.stdout.isatty():
        return text

    if color_name in colors:
        return '\033[{0};{1}m{2}\033[0m'.format(
            int(bold),
            colors.index(color_name) + 30,
            text)
    else:
        return text

if __name__ == "__main__":
    main()
