#!/bin/sh

# Check git path
GIT_PATH=$(which git)
GIT_BASE="../.git"
DIST_DIR="dist"
OLD_ARCHIVE_FILE="./*.zip"

CHANGELOG_FILE="ChangeLog.mkd"
USED_LIBRARIES_FILE="USED_LIBRARIES.mkd"

# Check git
if [ ! -d ${GIT_BASE} ] || [ -z ${GIT_PATH} ]; then
    echo "Git repository is not exist!"
    exit 1;
fi

# Check target directory
if [ ! -d ${DIST_DIR} ]; then
    echo "Dist directory was not found. Please compile SDK first."
    exit 2;
fi

# Get branch name / CommitID
if [ -z $GIT_BRANCH_NAME ]; then
    GIT_BRANCH_NAME=$(git branch | grep -e '^\*' | sed -e 's/^\* //g')
fi
GIT_BRANCH_NAME=`echo $GIT_BRANCH_NAME | sed -e 's/[\/ ]/_/g'`
GIT_COMMIT_ID=$(git rev-list -n 1 --abbrev-commit HEAD)
FRAMEWORK_ARCHIVE_NAME="IoTCloudSDK.framework-${GIT_BRANCH_NAME}-${GIT_COMMIT_ID}.zip"

# Create SDK archive
if [ -d ${DIST_DIR} ]; then
    if [ -e ${OLD_ARCHIVE_FILE} ]; then
        rm -r ${OLD_ARCHIVE_FILE}
    fi
    cd ${DIST_DIR}
    zip -ry "${FRAMEWORK_ARCHIVE_NAME}" "IoTCloudSDK.framework"
    echo SDK_BODY_FILE:${DIST_DIR}/${FRAMEWORK_ARCHIVE_NAME} > ci-publish.prop
    cd ../
else
    echo "${DIST_DIR} not exist!"
    exit 2;
fi
