target = appletv
THEOS_DEVICE_IP = bedroom.local
DEBUG=1
INSTALL_TARGET_PROCESSES = TVSettings

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UnpairRemoteSettings

UnpairRemoteSettings_FILES = Tweak.x
UnpairRemoteSettings_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
