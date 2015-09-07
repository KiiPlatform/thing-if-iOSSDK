#!/usr/bin/env python
import logging
import time
import argparse
import os
import shutil
import subprocess
import sys
import json
import re

def getLogger():
    logger = logging.getLogger('debug')
    ch = logging.StreamHandler();
    ch.setLevel(logging.DEBUG)
    logger.addHandler(ch)
    logger.setLevel(logging.DEBUG)
    return logger

class SwiftDocGenerator(object):
    def __init__(self):
        self.logger = getLogger()

        parser = argparse.ArgumentParser(description="Generate Doc from swift project")
        parser.add_argument('-options', '--options-file', dest='options_file', default='jazzy-options.js', help='file with options settings')
        args = parser.parse_args()

        settings = json.load(open(args.options_file))
        # prameters for xcodebuild
        self.project = settings["project"]
        self.scheme = settings["scheme"]

        # parameters for jazzy
        self.author = settings["author"]
        self.author_url = settings["author_url"]
        self.github_url = settings["github_url"]
        self.output = settings["output"]
        self.swift_version = settings["swift-version"]

        # for archive
        self.docArchivePrefix = settings["doc-archive-prefix"]
        self.docDir = "docs"

        if "ignore" in settings:
            self.ignores = settings["ignore"]

    def generateDoc(self):

        # Generate ignore list
        ignoreList = []
        if self.ignores:
            for ignore in self.ignores:
                ignoreList.append(ignore)

        processArg = ["jazzy", '-c','--output', self.output, '--xcodebuild-arguments', '-project,../{0},-scheme,{1}'.format(self.project, self.scheme), '--author', self.author, '--author_url', self.author_url, '--github_url', self.github_url, '--swift-version', self.swift_version, '--exclude', ','.join(ignoreList)]

        processArg = filter(bool, processArg)
        print("Command: " + " ".join(processArg))
        subprocess.call(processArg)

    def getGitInformation(self):
        # Check git branch name value from OS environment
        # (because branch name can not be retrieved in jenkins environment by git command)
        branchStr = os.environ.get("GIT_BRANCH_NAME")
        if not branchStr:
            branchStr = subprocess.Popen("git branch | grep -e '^\*' | sed -e 's/^\* //g'", stdout=subprocess.PIPE, shell=True).communicate()[0].split()[0]
        p = re.compile('[\/ ]')
        branchStr = p.sub('_', branchStr)
        print ('branchStr: ' + branchStr)
        self.gitBranch = branchStr

        self.gitCommitID = subprocess.Popen("git rev-list -n 1 --abbrev-commit HEAD", stdout=subprocess.PIPE, shell=True).communicate()[0].split()[0]

        print("Git information : " + self.gitBranch + " / " + self.gitCommitID)

    def archiveGeneratedDoc(self):
        # Create appledoc archive
        archiveName = "{0}-{1}-{2}.zip".format(self.docArchivePrefix, self.gitBranch, self.gitCommitID)
        archiveArg = ["zip", "-r", archiveName, self.docDir]
        archiveArg = filter(bool, archiveArg)
        print("Command: " + " ".join(archiveArg))
        subprocess.call(archiveArg)

    def cleanUp(self):
        # Delete html directories
        if os.path.isdir("docs"):
            shutil.rmtree("docs")
        if os.path.isdir(self.docDir):
            shutil.rmtree(self.docDir)

        # Delete previous build appledoc archive
        listCommand = "ls | grep {0}*.zip".format(self.docArchivePrefix)
        appledocArchiveList = subprocess.Popen(listCommand, stdout=subprocess.PIPE, shell=True).communicate()[0].split()
        for appledocArchiveFile in appledocArchiveList:
            print(appledocArchiveFile)
            os.remove(appledocArchiveFile)


if __name__ == '__main__':
    docGenerator = SwiftDocGenerator()
    docGenerator.cleanUp()
    docGenerator.getGitInformation()
    docGenerator.generateDoc()
    docGenerator.archiveGeneratedDoc()
