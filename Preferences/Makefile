BUNDLE_NAME = StellaPreferences

$(BUNDLE_NAME)_FRAMEWORKS = Comet
$(BUNDLE_NAME)_FILES = $(shell find Sources/StellaPreferences -name '*.swift') $(shell find Sources/StellaPreferencesC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
$(BUNDLE_NAME)_SWIFTFLAGS = -ISources/StellaPreferencesC/include
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)