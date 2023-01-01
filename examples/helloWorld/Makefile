# Makefile for examples 

APPNAME:=`basename $(CURDIR)`
VC     :=valac
OPTS   :=-v --vapidir=../../vapi/

PROJECT:=.
SRC :=$(wildcard $(PROJECT)/*.vala)

PKGS:=\
	--pkg glfw3 \
	--pkg gl \
	--pkg gio-2.0
#	--pkg freeimage  
INCLUDES:=\
	-X -I/opt/homebrew/Cellar/libepoxy/1.5.10/include \
	-X -I/opt/homebrew/include/ \
	-X -I../../glfw/include/ \
	-X -I/Library/Developer/CommandLineTools/usr/include/c++/v1/ 
#	-X -I../glib-emscripten/target/include \
#	-X -I../glib-emscripten/target/include/glib-2.0 
	
LIBS:=\
	-X -L/opt/homebrew/lib/ -X -lepoxy \
	-X -lglib-2.0 \
	-X -L../../glfw/lib-arm64/ -X -lglfw3 \
	-X -lgobject-2.0 -X -lgio-2.0 # -X -lfreeimage 
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
