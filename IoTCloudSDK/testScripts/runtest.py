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

parser = argparse.ArgumentParser()
parser.add_argument('--file', nargs='?', default='unit-tests.js', help='Test case definition file')
parser.add_argument('--xctoolpath', nargs='?', default='xctool', help='xctool to be used.')
parser.add_argument('--option', nargs='?', help='Test option')
parser.add_argument('--clean', nargs='?', const='clean', help='Clean build before test execution')
parser.add_argument('--testsdk', nargs='?', default='iphonesimulator9.0', help='iOS SDK version to test')
parser.add_argument('--restartSimulator', nargs='?', const=True, help='Option for restarting simulator process before test is executed')
parser.add_argument('--freshSimulator', nargs='?', const='-freshSimulator', help='Option for using fresh simulator with test')
parser.add_argument('--freshInstall', nargs='?', const='-freshInstall', help='Option for application clean install with test')
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
    if "name" in t:
        name = t["name"]
        onlyArg = "-only"
    if "testsdk" in t:
        testsdk = t["testsdk"]
    else:
        testsdk = args.testsdk
    count = t["count"]
    print("scheme: " + scheme)
    print("name: " + name)
    for i in range(count):
        if args.restartSimulator:
            subprocess.call("ps -ef | grep iPhone\ Simulator.app | grep -v /bin/sh | grep -v 'grep iPhone' | awk '{print $2}' | xargs kill -9", shell=True)
        report_file = "junit:test-reports/junit-report-" + str(int(round(time_.time() * 1000))) + ".xml"
        print("report file: " + report_file)
        xctool = args.xctoolpath
        if args.destination:
            processArg = [xctool,"-project", "./IoTCloudSDK.xcodeproj", "-scheme", scheme,"-destination",args.destination, "-configuration", "Debug", "-sdk", "iphonesimulator", "-reporter", "pretty", "-reporter", report_file, args.option, args.clean, "test", "-test-sdk", testsdk, args.freshSimulator, args.freshInstall, onlyArg, name,"-parallelize","-logicTestBucketSize","20"]
        else :
            processArg = [xctool,"-project", "./IoTCloudSDK.xcodeproj", "-scheme", scheme, "-configuration", "Debug", "-sdk", "iphonesimulator", "-reporter", "pretty", "-reporter", report_file, args.option, args.clean, "test", "-test-sdk", testsdk, args.freshSimulator, args.freshInstall, onlyArg, name,"-parallelize","-logicTestBucketSize","20"]
        processArg = filter(bool, processArg)
        print("Command: " + " ".join(processArg))
        subprocess.call(processArg)
