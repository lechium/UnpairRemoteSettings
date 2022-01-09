target = appletv
DEBUG=0
THEOS_DEVICE_IP = game-room.local
INSTALL_TARGET_PROCESSES = TVSettings

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UnpairRemoteSettings

UnpairRemoteSettings_FILES = Tweak.x
UnpairRemoteSettings_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
