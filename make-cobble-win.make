APPNAME:=app
VC     :=valac 
INCLUDES:=\
	-X -I./glfw/include/ \
	-X -I../FreeImage/Dist/x64/ \
	-X -I../libepoxy-1.5.10/include/ \
	-X -I../libepoxy-1.5.10/build/include/ 
LIBS:=\
	-X -L../libepoxy-1.5.10/build/src -X -lepoxy \
	-X -L./glfw/lib-static-ucrt -X -lglfw3 \
	-X -L../FreeImage/Dist/x64 -X -lFreeImage
OPTS   :=-v --vapidir=./vapi/

SRC :=$(wildcard ./projects/cobble/*.vala)
GSRC:=$(wildcard ./projects/cobble/*.gs)

PKGS:=\
	--pkg freeimage \
	--pkg glfw3 \
	--pkg gl \
	--pkg gio-2.0 

default: 
	$(VC) $(OPTS) \
		$(SRC) \
		$(PKGS) \
		$(INCLUDES) \
		$(LIBS) \
		$(FRAMEWORKS) \
		-o ./projects/cobble/$(APPNAME)

dist:
	mkdir -p ./projects/cobble/dist
	mv ./projects/cobble/$(APPNAME).exe ./projects/cobble/dist/
	cp ./projects/cobble/*.fs ./projects/cobble/dist/
	cp ./projects/cobble/*.vs ./projects/cobble/dist/
	cp ./projects/cobble/*.png ./projects/cobble/dist/
	cp ../FreeImage/Dist/x64/FreeImage.dll ./projects/cobble/dist/
	cp ./glfw/lib-static-ucrt/glfw3.dll ./projects/cobble/dist/

clean:
	rm -rf ./projects/cobble/dist 