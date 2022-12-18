# OpenGL on MacOS with Vala / Genie
Using GLFW3 libraries, OpenGL from XCode frameworks etc.<br>
## IMPORTANT:
Check the Makefile and adjust your location of gl.h accordingly: ```Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk/System/Library/Frameworks/OpenGL.framework/Versions/A/Headers/```
is just where one happens to be on my system. <br>
Additionally, make sure the latest glfw release is extracted to the project path+`/glfw`.
```
make
```
to create the VALA build.
```
make genie
```
to create the GENIE build. 
