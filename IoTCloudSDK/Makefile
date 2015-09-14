# all:clean build archive doc
#
# clean:
# 	rm -rf Documentation/docs
# 	rm -rf Documentation/IoTCloudSDK-Documentation*.zip
# 	rm -rf build
# 	rm -rf dist
# 	rm -rf test-reports
#
# build:
# 	sh SDK-build.sh
#
# archive: build
# 	sh SDK-archive.sh
#
# doc:
# 	(cd Documentation; \
# 	python generateDocs.py)
DIST_DIR = dist
GIT_BRANCH_NAME := $(shell git branch | grep -e '^\*' | sed -e 's/^\* //g')
GIT_COMMIT_ID := $(shell git rev-list -n 1 --abbrev-commit HEAD)

.PHONY: clean build
clean:
		rm -rf Documentation/docs
		rm -rf Documentation/IoTCloudSDK-Documentation*.zip
		rm -rf build
		rm -rf dist
		rm -rf test-reports
		rm -rf Carthage

carthage-build:
		carthage build --no-skip-current
		rm -fr ${DIST_DIR}; mkdir ${DIST_DIR}; cp -fr Carthage/Build/iOS/IoTCloudSDK.framework*  ${DIST_DIR}/

archive: carthage-build
		cd ${DIST_DIR}; zip -r "IoTCloudSDK.framework.${GIT_BRANCH_NAME}-${GIT_COMMIT_ID}.zip" . -i "IoTCloudSDK.framework*"
