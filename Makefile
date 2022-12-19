# For MacOS / M1 silicon (arm64)
VC:=valac
OPTS:=-v --vapidir=./vapi/
SRC:=$(wildcard ./*.vala)
GSRC:=$(wildcard ./*.gs)

PKGS:=--pkg glfw3 \
	--pkg gl \
	--pkg gio-2.0 
INCLUDES:=	-X -I/opt/homebrew/include/ \
	-X -I./glfw/include/ 
#	-X -I/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/System/Library/Frameworks/OpenGL.framework/Versions/A/Headers/ 
LIBS:=-X -L/opt/homebrew/lib/ -X -lepoxy -X -L./glfw/lib-arm64/ -X -lglfw3
FRAMEWORKS:=-X -framework -X Cocoa \
	-X -framework -X IOKit 
#	-X -framework -X OpenGL 

APPNAME:=app

default: 
	$(VC) $(OPTS) \
		$(SRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		$(FRAMEWORKS) \
		-o $(APPNAME)

genie:
	$(VC) $(OPTS) \
		$(GSRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		$(FRAMEWORKS) \
		-o $(APPNAME)

clean:
	rm ./$(APPNAME)
