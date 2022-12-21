#version 150 core

in vec2 position;
in vec3 color;

out vec3 _color;

void main() 
{ 
    _color = color;
    gl_Position = vec4(position, 0.0, 1.0); 
}