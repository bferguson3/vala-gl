# For UNIX 

APPNAME:=app
VC     :=valac
OPTS   :=-v --vapidir=./vapi/

ANDROIDCLANG:=/Users/$(USER)/Library/Android/sdk/ndk/25.1.8937393/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang

PROJECT:=.
SRC :=$(wildcard $(PROJECT)/*.vala)
GSRC:=$(wildcard $(PROJECT)/*.gs)

PKGS:=\
	--pkg freeimage \
	--pkg glfw3 \
	--pkg gl \
	--pkg gio-2.0 
INCLUDES:=\
	-X -I./glfw/include/ \
#	-X -I../glib-emscripten/target/include \
#	-X -I../glib-emscripten/target/include/glib-2.0 
	
LIBS:=\
    -X -lepoxy \
	-X -lglib-2.0 \
	-X -L./glfw/lib-arm64/ -X -lglfw3 \
	-X -lfreeimage -X -lgobject-2.0 \
	-X -lm # for nix 
#-lgio2.0 

default: 
	$(VC) $(OPTS) \
		$(SRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		-o $(PROJECT)/$(APPNAME)

c:
	$(VC) -C $(OPTS) \
		$(SRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		-o $(PROJECT)/$(APPNAME)

clean: 
	rm $(PROJECT)/*.c
	rm $(PROJECT)/$(APPNAME)
	