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

For this project:
```
make PROJECT=<path/to/proj>
```
to create the VALA build.
```
make genie PROJECT=<path/to/proj>
```
to create the GENIE build. 
