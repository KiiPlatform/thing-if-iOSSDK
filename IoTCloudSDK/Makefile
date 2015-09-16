all:clean build archive doc

DIST_DIR = dist
GIT_BRANCH_NAME := $(shell git branch | grep -e '^\*' | sed -e 's/^\* //g')
GIT_COMMIT_ID := $(shell git rev-list -n 1 --abbrev-commit HEAD)

.PHONY: clean carthage-build archive doc
clean:
		rm -rf Documentation/docs
		rm -rf Documentation/IoTCloudSDK-Documentation*.zip
		rm -rf build
		rm -rf dist
		rm -rf test-reports

build:
		xcodebuild -project IoTCloudSDK.xcodeproj -target IoTCloudSDKAggregate clean build

archive: build
		(cd ${DIST_DIR}; \
			zip -r "IoTCloudSDK.framework.${GIT_BRANCH_NAME}-${GIT_COMMIT_ID}.zip" . -i "IoTCloudSDK.framework*")

doc: build
		(cd Documentation; \
			python generateDocs.py)
