all:clean build archive doc

DIST_DIR = dist
GIT_BRANCH_NAME := $(shell git branch | grep -e '^\*' | sed -e 's/^\* //g' | sed -e 's/\//-/g')
GIT_COMMIT_ID := $(shell git rev-list -n 1 --abbrev-commit HEAD)

.PHONY: clean carthage-build archive doc
clean:
		rm -rf Documentation/docs
		rm -rf Documentation/ThingIFSDK-Documentation*.zip
		rm -rf build
		rm -rf dist
		rm -rf test-reports

build:
		xcodebuild -project ThingIFSDK.xcodeproj -target ThingIFSDKAggregate clean build

archive: build
		(cd ${DIST_DIR}; \
			zip -r "ThingIFSDK.framework.${GIT_BRANCH_NAME}-${GIT_COMMIT_ID}.zip" . -i "ThingIFSDK.framework*")

doc: build
		(cd Documentation; \
			python generateDocs.py)
