#version 150 core 

uniform float alpha;
in vec3 _color;

out vec4 outColor; 

void main()
{
    outColor = vec4(_color * alpha, 1.0f);
}