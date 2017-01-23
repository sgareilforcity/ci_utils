# ci_utils

A _ git pull-request
================

Automatically check out github pull requests into their own branch.

Installation
------------

Copy the script to somewhere in your ``PATH`` and make it executable.

Set github.token to your github OAUTH token
    i.e. git config --global github.token OAUTH-TOKEN

If you need Python 3 support be sure to use the ``python3`` branch.

Usage
-----

    python git-pull-request <OPTIONS> [<pull request number>]

Options
-------

    -h, --help
        Display this message and exit

    -r <repo>, --repo <repo>
        Use this github repo instead of the 'remote origin' or 'github.repo'
        git config settings. Needs to be in "user/repository" form
 
    -b, --base
        Use this for testing the base repository win the pull request to validate.
        
    -t, --token
        Use this token if you use an acces token for github.
        
        
License
=======

Copyright (C) 2011-2013 by Andreas Gohr <andi@splitbrain.org>

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


B _ Truffle Hog
================

Searches through git repositories for high entropy strings, digging deep into commit history and branches. This is effective at finding secrets accidentally committed that contain high entropy.

Example
-----
    python truffleHog.py https://github.com/dxa4481/truffleHog.git

Setup
-----

The only requirement is GitPython, which can be installed with the following

    pip install -r requirements.txt

How it works
------------

This module will go through the entire commit history of each branch, and check each diff from each commit, and evaluate the shannon entropy for both the base64 char set and hexidecimal char set for every blob of text greater than 20 characters comprised of those character sets in each diff. If at any point a high entropy string >20 characters is detected, it will print to the screen. 