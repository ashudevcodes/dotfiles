#version 320 es

precision highp float;

in vec2 v_texcoord;
out vec4 fragColor;

uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);

    color.rgb *= 0.65;

    color.rgb *= vec3(1.0, 0.94, 0.78);

    fragColor = color;
}
