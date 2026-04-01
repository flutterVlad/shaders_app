#version 460 core
#include <flutter/runtime_effect.glsl>

precision highp float;

uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse; // ожидает значения 0..1

out vec4 fragColor;

float hash(float n) { return fract(sin(n) * 43758.5453); }

vec3 hueToRgb(float h) {
  h = fract(h) * 6.0;
  return clamp(abs(h - vec3(3,2,4)) - vec3(1,0,0), 0.0, 1.0);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / iResolution.xy; // просто 0..1, без инверсии
  vec2 p = uv * 2.0 - 1.0;
  p.x *= iResolution.x / iResolution.y;

  // mouse уже в 0..1 от Flutter, переводим в то же пространство что и p
  vec2 mouse = iMouse * 2.0 - 1.0;
  mouse.x *= iResolution.x / iResolution.y;

  vec3 col = vec3(0.0);
  float N = 100.0;

  for (float i = 0.0; i < N; i++) {
    float radius = 0.05 + hash(i) * 0.85;
    float speed  = 0.2 + hash(i + 1.0) * 0.5;
    float arm    = floor(hash(i + 4.0) * 3.0);
    float angle  = hash(i + 2.0) * 6.2831
                 + arm * 2.094
                 + radius * 3.5
                 + iTime * speed * 0.15;

    vec2 starPos = vec2(cos(angle), sin(angle)) * radius;

    vec2 diff    = starPos - mouse;
    float dist   = length(diff);
    float repel  = 0.15 / (dist * dist + 0.01);
    starPos += normalize(diff + 0.001) * repel * 0.04;
    float attract = smoothstep(0.5, 0.0, dist);
    starPos = mix(starPos, mouse, attract * 0.12);

    vec2 d = p - starPos;
    float r = length(d);
    float size = 0.004 + attract * 0.008 + repel * 0.002;
    float brightness = smoothstep(size, 0.0, r);

    vec3 starCol = hueToRgb(hash(i + 5.0));
    starCol = mix(starCol, vec3(1.0), 0.3 + attract * 0.5);
    col += starCol * brightness * (0.5 + attract * 0.5);
  }

  float glow = exp(-length(p) * 2.5) * 0.15;
  col += vec3(0.2, 0.3, 0.6) * glow;

  float mGlow = exp(-length(p - mouse) * 8.0) * 0.3;
  col += vec3(0.5, 0.7, 1.0) * mGlow;

  fragColor = vec4(col, 1.0);
}