#!/bin/bash

checkError()
{
    if [ "${1}" -ne "0" ]; then
        echo "*** Error: ${2}"
        exit ${1}
    fi
}

if [ ! -f $MIRAI_SDK_PREFIX/lib/libOpenGLES.so ]; then
	echo "build OpenGLES..."
	
	pushd $MIRAI_PROJECT_ROOT_PATH/Mirai-OpenGLES
	xcodebuild -target OpenGLES-Android -xcconfig xcconfig/Android-$ABI.xcconfig clean
	
	xcodebuild -target OpenGLES-Android -xcconfig xcconfig/Android-$ABI.xcconfig
	checkError $? "build OpenGLES failed"
	
	#clean up
	rm -r build
	popd
fi