#!/usr/bin/env python
import logging
import time
import argparse
import os
import shutil
import subprocess
import sys
import json

parser = argparse.ArgumentParser(description="Generate Doc from swift project")
parser.add_argument('-jazzy', '--jazzy-path', dest='jazzy_path', help='path to executable jazzy file',
        required=True)
parser.add_argument('-options', '--options-file', dest='options_file', default='jazzy-options.js', help='file with options settings')

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

    def generateDoc(self):
        self.logger.debug('generating doc with jazzy:{0}'.format(self.jazzy_path))

        settings = json.load(open(self.options_file))
        # prameters for xcodebuild
        self.project = settings["project"]
        self.scheme = settings["scheme"]

        # parameters for jazzy
        self.author = settings["author"]
        self.author_url = settings["author_url"]
        self.github_url = settings["github_url"]
        self.output = settings["output"]
        self.swift_version = settings["swift-version"]

        if "ignore" in settings:
            self.ignores = settings["ignore"]
        # Generate ignore list
        ignoreList = []
        if self.ignores:
            for ignore in self.ignores:
                ignoreList.append(ignore)

        processArg = [self.jazzy_path, '-c','--output', self.output, '--xcodebuild-arguments', '-project,{0},-scheme,{1}'.format(self.project, self.scheme), '--author', self.author, '--author_url', self.author_url, '--github_url', self.github_url, '--swift-version', self.swift_version, '--exclude', ','.join(ignoreList)]

        processArg = filter(bool, processArg)
        print("Command: " + " ".join(processArg))
        subprocess.call(processArg)

if __name__ == '__main__':
    args = parser.parse_args()
    docGenerator = SwiftDocGenerator()
    docGenerator.jazzy_path = args.jazzy_path
    docGenerator.options_file = args.options_file
    docGenerator.generateDoc()
