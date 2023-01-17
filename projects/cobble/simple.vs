#version 150 core

in vec2 position;
uniform mat4 pvm;
uniform mat4 model;

// pass through
in vec3 color;
out vec3 _color;

in vec2 texcoord;
out vec2 _texcoord;


void main() 
{ 
    _color = color;
    _texcoord = texcoord;

    gl_Position = pvm * vec4(position, 1.0, 1.0);
}