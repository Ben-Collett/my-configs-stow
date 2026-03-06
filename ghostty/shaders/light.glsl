#version 320 es
precision highp float;

uniform float u_time;
uniform vec2 u_resolution;

out vec4 fragColor;

void main() {
    vec2 uv = (gl_FragCoord.xy - u_resolution*0.5) / u_resolution.y;

    float angle = atan(uv.y, uv.x);
    float dist = length(uv);

    float rays = sin(angle * 20.0 + u_time * 0.7) * 0.5 + 0.5;
    float glow = 0.1 / dist;

    float intensity = rays * glow;

    fragColor = vec4(1.0, 0.85, 0.3, intensity);
}
