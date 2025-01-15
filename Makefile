export TARGET := iphone:clang:latest:14.0
export ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = Preferences SpringBoard

SUBPROJECTS = Tweak Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

generate_version:
	@swift generate_version.swift

before-all:: generate_version