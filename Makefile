TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
THEOS_PACKAGE_SCHEME = roothide
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TurboAnim
TurboAnim_FILES = Tweak.x
TurboAnim_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
