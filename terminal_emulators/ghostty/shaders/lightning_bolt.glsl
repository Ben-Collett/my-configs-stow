// vibed based on https://www.youtube.com/watch?v=WthCMZ1nm2Q
#ifdef GL_ES
precision mediump float;
#endif

#define EFFECT_COLOR vec3(0.2,0.3,0.8)

#define OCTAVES 6
#define AMP_START .5
#define AMP_COEFF .5
#define FREQ_COEFF 2.0

uniform vec2 u_resolution;
uniform float u_time;

// ------------------------------------------------------------
// Noise
// ------------------------------------------------------------

vec2 hash(vec2 p) {
    p = vec2(
        dot(p, vec2(127.1, 311.7)),
        dot(p, vec2(269.5, 183.3))
    );

    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

vec2 fade(vec2 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float perlin_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 g00 = hash(i + vec2(0.0, 0.0));
    vec2 g10 = hash(i + vec2(1.0, 0.0));
    vec2 g01 = hash(i + vec2(0.0, 1.0));
    vec2 g11 = hash(i + vec2(1.0, 1.0));

    vec2 d00 = f - vec2(0.0, 0.0);
    vec2 d10 = f - vec2(1.0, 0.0);
    vec2 d01 = f - vec2(0.0, 1.0);
    vec2 d11 = f - vec2(1.0, 1.0);

    float n00 = dot(g00, d00);
    float n10 = dot(g10, d10);
    float n01 = dot(g01, d01);
    float n11 = dot(g11, d11);

    vec2 u = fade(f);

    return mix(
        mix(n00, n10, u.x),
        mix(n01, n11, u.x),
        u.y
    );
}

float fbm(vec2 uv){
    float value = 0.0;
    float amplitude = AMP_START;

    for(int i = 0; i < OCTAVES; i++){
        value += amplitude * perlin_noise(uv);

        uv *= FREQ_COEFF;
        amplitude *= AMP_COEFF;
    }

    return value;
}

// ------------------------------------------------------------
// Distance to lightning bolt
// ------------------------------------------------------------

float lightning(vec2 uv, vec2 p0, vec2 p1)
{
    vec2 dir = p1 - p0;
    float len = length(dir);

    vec2 forward = normalize(dir);

    // perpendicular direction
    vec2 side = vec2(-forward.y, forward.x);

    // project uv onto segment
    float t = dot(uv - p0, forward) / len;

    // clamp to segment so ends touch endpoints
    t = clamp(t, 0.0, 1.0);

    // base point on line
    vec2 point = mix(p0, p1, t);

    // stronger noise in middle, zero at ends
    float envelope = sin(t * 3.14159265);

    // noise offset perpendicular to line
    float n = fbm(vec2(t * 8.0, u_time * 1.5));

    point += side * n * 0.25 * envelope;

    // distance from pixel to distorted bolt
    float d = length(uv - point);

    // glow
    return 0.02 / d;
}

void main()
{
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;

    // keep aspect ratio correct
    uv.x *= u_resolution.x / u_resolution.y;

    // endpoints
    vec2 p0 = vec2(0.6, 0.8);
    vec2 p1 = vec2(.3, 0.1);

    float bolt = lightning(uv, p0, p1);

    vec3 color = EFFECT_COLOR * bolt;

    gl_FragColor = vec4(color, 1.0);
}
