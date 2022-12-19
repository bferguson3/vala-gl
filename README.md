# OpenGL on MacOS with Vala / Genie
Using GLFW3 libraries and Epoxy GL implementation.<br>
## IMPORTANT:
No longer needs a reference to the system gl.h.
## Requires GLFW3 in the project root /glfw!
```
https://github.com/glfw/glfw/releases
```
## Requires Epoxy GL implementation!
```
git clone https://github.com/anholt/libepoxy && cd libepoxy
mkdir _build && cd _build
meson
ninja
sudo ninja install
```
The project will not compile until you comment out these lies in epoxy/gl.h`:
```
//#if defined(__gl_h_) || defined(__glext_h_)
//#error epoxy/gl.h must be included before (or in place of) GL/gl.h
//#else
#define __gl_h_
#define __glext_h_
//#endif
```
For this project:
```
make
```
to create the VALA build.
```
make genie
```
to create the GENIE build. 
