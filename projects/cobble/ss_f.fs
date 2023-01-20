#version 150 core

in vec2 _texcoord;
out vec4 outColor;
uniform sampler2D tex;

void main()
{ 
    outColor = texture(tex, _texcoord);
}