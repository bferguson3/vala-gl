# For MacOS / M1 silicon (arm64)
# YOU PROBABLY HAVE TO MAKE YOUR OWN MAKEFILE FOR WINDOWS/LINUX!
APPNAME:=app
VC     :=valac
OPTS   :=-v --vapidir=./vapi/

ANDROIDCLANG:=/Users/$(USER)/Library/Android/sdk/ndk/25.1.8937393/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang

PROJECT:=.
SRC :=$(wildcard $(PROJECT)/*.vala)
GSRC:=$(wildcard $(PROJECT)/*.gs)

PKGS:=\
	--pkg glfw3 \
	--pkg gl \
	--pkg gio-2.0 
INCLUDES:=\
	-X -I/opt/homebrew/include/ \
	-X -I./glfw/include/ 
LIBS:=\
	-X -L/opt/homebrew/lib/ -X -lepoxy \
	-X -L./glfw/lib-arm64/ -X -lglfw3
FRAMEWORKS:=\
	-X -framework -X Cocoa \
	-X -framework -X IOKit 


default: 
	$(VC) $(OPTS) \
		$(SRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		$(FRAMEWORKS) \
		-o $(PROJECT)/$(APPNAME)

c:
	$(VC) -C $(OPTS) \
		$(SRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		$(FRAMEWORKS) \
		-o $(PROJECT)/$(APPNAME)

genie:
	$(VC) $(OPTS) \
		$(GSRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		$(FRAMEWORKS) \
		-o $(PROJECT)/$(APPNAME)
