#version 150 core

in vec2 position;
// pass through
in vec3 color;
out vec3 _color;
in vec2 texcoord;
out vec2 _texcoord;


void main() 
{ 
    _color = color;
    _texcoord = texcoord;

    gl_Position = vec4(position, 0.0, 1.0); 
}