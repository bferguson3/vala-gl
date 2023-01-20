#version 150 core

in vec3 _color;
in vec2 _texcoord;

out vec4 outColor;

uniform sampler2D tex;
uniform float alpha;

void main()
{ 
    //outColor = texture(tex, _texcoord);
    outColor = texture(tex, _texcoord) * vec4((_color * alpha), 1.0);
}