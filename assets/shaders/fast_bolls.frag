// Версия API
#version 460 core

// Вспомогательный инстурментарий для Flutter
#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

#define PI 3.14159

void main(){
    vec2 p = (FlutterFragCoord().xy - 0.5 * resolution) / min(resolution.x, resolution.y);
    vec2 t = vec2(FlutterFragCoord().xy / resolution);

    vec3 c = vec3(0);

    for (int i = 0; i < 20; i++) {
        float t = 0.4 * PI * float(i) / 3.0 * time * 0.5;
        float x = cos(3.0*t);
        float y = sin(4.0*t);
        vec2 o = 0.40 * vec2(x, y);
        float r = fract(x);
        float g = 1.0 - r;
        c += 0.01 / (length(p-o)) * vec3(r, g, 0.9);
    }

    fragColor = vec4(c, 1);
}