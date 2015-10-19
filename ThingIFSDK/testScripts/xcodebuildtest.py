# parse input from json file (default:unit-tests.js) and run the tests.
# To run all the tests input json is: {"scheme":"your scheme name", count=1}
# To run a single tests json is: {"scheme":"your scheme name","name":"target:test_name", count=1}
# it will called from parent folder
import subprocess
import json
import sys
import time as time_
import argparse
import plistlib
import re
import glob, os

def rename(dir, pattern, titlePattern, count):
    for pathAndFilename in glob.iglob(os.path.join(dir, pattern)):
        title, ext = os.path.splitext(os.path.basename(pathAndFilename))
        os.rename(pathAndFilename,
                  os.path.join(dir, titlePattern % title+'_'+ count + ext))

parser = argparse.ArgumentParser()
parser.add_argument('--file', nargs='?', default='unit-tests.js', help='Test case definition file')
parser.add_argument('--option', nargs='?', help='Test option')
parser.add_argument('--sdk', nargs='?',default='iphonesimulator', help='SDK to build')
parser.add_argument('--destination', nargs='?', help='Option for selecting destination')
args = parser.parse_args()
args = parser.parse_args()

tests = json.load(open('testScripts/{0}'.format(args.file)))

for t in tests:
    scheme = t["scheme"]
    name = ""
    onlyArg = ""
    option = ""
    testsdk = ""

    count = t["count"]
    print("scheme: " + scheme)

    for i in range(count):
        command = "xcodebuild -project ThingIFSDK.xcodeproj -scheme {scheme} -sdk {sdk} -configuration Debug clean build test -destination '{destination}' | tee console.log".\
        format(scheme=scheme, sdk=args.sdk, destination=args.destination)
        subprocess.call(command, shell=True)
        subprocess.call("ocunit2junit console.log > /dev/null", shell=True)
        rename(r'test-reports', r'*.xml', r'%s',str(i))
        if(i < (count -1)): subprocess.call("cp -r test-reports/* test-reports-temp/", shell=True)

subprocess.call("rm console.log", shell=True)
if count > 1:
    subprocess.call("cp -r test-reports-temp/* test-reports/", shell=True)
    subprocess.call("rm -rf test-reports-temp", shell=True)
