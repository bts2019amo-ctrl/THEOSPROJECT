THEOS ?= $(HOME)/theos
THEOS_MAKE_PATH = $(THEOS)/makefiles
# export CC = ccache gcc
# export CXX = ccache g++
ARCHS = arm64


DEBUG = 1
FINALPACKAGE = 1
FOR_RELEASE = 1
THEOS_PACKAGE_SCHEME = rootless
THEOS_LEAN_AND_MEAN = 1
THEOS_NO_DEFAULTS = 1
TARGET = iphone:clang:latest:14.0


include $(THEOS)/makefiles/common.mk


TWEAK_NAME = EASYCHEATS

EASYCHEATS_FILES = PatchBypass.mm savage.mm AppLanguage.cpp \
$(wildcard Esp/*.mm) \
$(wildcard IMGUI/*.cpp) \
$(wildcard IMGUI/*.mm) \
$(wildcard hook/*.c)

EASYCHEATS_CCFLAGS = -std=c++17 -fno-rtti -DNDEBUG -Wall -fvisibility=hidden -ftemplate-depth=1024
EASYCHEATS_CFLAGS = -fobjc-arc -Wno-module-import-in-extern-c

ifeq ($(IGNORE_WARNINGS),1)
  EASYCHEATS_CFLAGS += -w
  EASYCHEATS_CCFLAGS += -w
endif

EASYCHEATS_CFLAGS += -Wno-error
EASYCHEATS_CCFLAGS += -Wno-error


EASYCHEATS_FRAMEWORKS = UIKit Foundation AVFoundation AudioToolbox Accelerate GLKit SystemConfiguration GameController Security Metal MetalKit
EASYCHEATS_LDFLAGS += libdobby.a
EASYCHEATS_LDFLAGS += JRMemory.framework/JRMemory

include $(THEOS_MAKE_PATH)/tweak.mk