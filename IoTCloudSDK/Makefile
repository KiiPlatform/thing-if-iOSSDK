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

.PHONY: clean build
clean:
		rm -rf Documentation/docs
		rm -rf Documentation/IoTCloudSDK-Documentation*.zip
		rm -rf build
		rm -rf dist
		rm -rf test-reports

build:
		xcodebuild -project IoTCloudSDK.xcodeproj -target IoTCloudSDKAggregate build

git_branchname_commitid.txt:
	GIT_BRANCH_NAME = $(git branch | grep -e '^\*' | sed -e 's/^\* //g')
	GIT_COMMIT_ID = $(git rev-list -n 1 --abbrev-commit HEAD)
	echo ${GIT_BRANCH_NAME}-${GIT_COMMIT_ID} > $@

IoTCloud-iOSSDK.framework.zip: git_branchname_commitid.txt
		git_branchname_commitid = $(cat git_branchname_commitid.txt)
		zip -ry "IoTCloudSDK.framework-${git_branchname_commitid}.zip" "${DIST_DIR}/IoTCloudSDK.framework"
