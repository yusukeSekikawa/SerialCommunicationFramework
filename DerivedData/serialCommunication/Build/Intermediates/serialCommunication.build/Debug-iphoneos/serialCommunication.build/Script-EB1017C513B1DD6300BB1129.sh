#!/bin/sh
#--------------------------------------------------------------------
echo "[0] Framework: Preparing ..."
#--------------------------------------------------------------------
FRAMEWORK_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleName" Info.plist)
BUILD_TARGET_NAME=$FRAMEWORK_NAME
FRAMEWORK_VERSION_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" Info.plist)
FRAMEWORK_VERSION=A
FRAMEWORK_BUILD_PATH="DerivedData/${BUILD_TARGET_NAME}/Build/Products/${BUILD_STYLE}-framework"
FRAMEWORK_DIR="${FRAMEWORK_BUILD_PATH}/${FRAMEWORK_NAME}.framework"
PACKAGENAME="${FRAMEWORK_NAME}.${FRAMEWORK_VERSION_NUMBER}.zip"


echo "Framework: Cleaning framework..."
[ -d "${FRAMEWORK_BUILD_PATH}" ] && rm -rf "${FRAMEWORK_BUILD_PATH}"

#--------------------------------------------------------------------
echo "[1] Framework: Setting up directories..."
#--------------------------------------------------------------------
mkdir -p ${FRAMEWORK_DIR}
mkdir -p ${FRAMEWORK_DIR}/Versions
mkdir -p ${FRAMEWORK_DIR}/Versions/${FRAMEWORK_VERSION}
mkdir -p ${FRAMEWORK_DIR}/Versions/${FRAMEWORK_VERSION}/Resources
mkdir -p ${FRAMEWORK_DIR}/Versions/${FRAMEWORK_VERSION}/Headers

#--------------------------------------------------------------------
echo "[2] Framework: Creating symlinks..."
#--------------------------------------------------------------------
ln -s ${FRAMEWORK_VERSION} ${FRAMEWORK_DIR}/Versions/Current
ln -s Versions/Current/Headers ${FRAMEWORK_DIR}/Headers
ln -s Versions/Current/Resources ${FRAMEWORK_DIR}/Resources
ln -s Versions/Current/${FRAMEWORK_NAME} ${FRAMEWORK_DIR}/${FRAMEWORK_NAME}

#--------------------------------------------------------------------
echo "[3] Framework: Creating library..."
#--------------------------------------------------------------------
lipo -create \
DerivedData/${BUILD_TARGET_NAME}/Build/Products/${BUILD_STYLE}-iphoneos/lib${FRAMEWORK_NAME}.a \
-o "${FRAMEWORK_DIR}/Versions/Current/${FRAMEWORK_NAME}"
#build/${BUILD_STYLE}-iphonesimulator/lib${FRAMEWORK_NAME}.a \

#--------------------------------------------------------------------
echo "[4] Framework: Copying assets into current version..."
#--------------------------------------------------------------------
cp Classes/*.h ${FRAMEWORK_DIR}/Headers/
cp Info.plist ${FRAMEWORK_DIR}/Resources/           
#--------------------------------------------------------------------
echo "[6] Framework: Packaging framework..."
#--------------------------------------------------------------------
#cd ${FRAMEWORK_BUILD_PATH}
#zip -ry ${PACKAGENAME} $(basename $FRAMEWORK_DIR)

