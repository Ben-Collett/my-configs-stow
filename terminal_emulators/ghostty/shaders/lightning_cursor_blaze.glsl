// ===== Utility / Noise =====

float hash11(float n) {
    return fract(sin(n) * 43758.5453123);
}

float hash12(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    float a = hash12(i);
    float b = hash12(i + vec2(1.0, 0.0));
    float c = hash12(i + vec2(0.0, 1.0));
    float d = hash12(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float f = 0.0;
    f += 0.5 * noise(p); p *= 2.02;
    f += 0.25 * noise(p); p *= 2.03;
    f += 0.125 * noise(p); p *= 2.01;
    f += 0.0625 * noise(p);
    return f;
}

// ===== Geometry =====

float sdSegment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

vec2 normalizeCoords(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

// ===== Lightning Core =====

float boltNoise(float t, float time) {
    float n = fbm(vec2(t * 8.0 + time * 6.0, time * 1.7)) - 0.5;
    n += 0.5 * (fbm(vec2(t * 24.0 - time * 10.0, time * 4.0)) - 0.5);
    n += 0.25 * sin(t * 90.0 + time * 30.0);
    return n;
}

float lightningBolt(vec2 p, vec2 start, vec2 end, float time) {
    vec2 d = end - start;
    float len = length(d);
    if (len < 1e-4) return 0.0;

    vec2 dir = d / len;
    vec2 perp = vec2(-dir.y, dir.x);

    const int N = 18;
    vec2 prev = start;
    float minD = 1e9;

    for (int i = 1; i <= N; i++) {
        float t = float(i) / float(N);
        float taper = pow(sin(3.14159265 * t), 1.3);

        float j = boltNoise(t, time);
        float amp = len * 0.12 * taper;

        vec2 cur = mix(start, end, t) + perp * j * amp;

        minD = min(minD, sdSegment(p, prev, cur));
        prev = cur;
    }

    float core = 1.0 - smoothstep(len * 0.002, len * 0.006, minD);
    float glow = 1.0 - smoothstep(len * 0.012, len * 0.045, minD);

    float along = clamp(dot(p - start, dir) / len, 0.0, 1.0);
    float endFade = smoothstep(0.0, 0.06, along) * smoothstep(1.0, 0.92, along);

    float flicker = 0.8 + 0.2 * sin(time * 40.0);

    return (core * 1.8 + glow) * endFade * flicker;
}

// ===== Lightning Branches =====

float lightningBranches(vec2 p, vec2 start, vec2 end, float time) {
    vec2 d = end - start;
    float len = length(d);
    if (len < 1e-4) return 0.0;

    vec2 dir = d / len;
    vec2 perp = vec2(-dir.y, dir.x);

    float outVal = 0.0;

    for (int i = 0; i < 6; i++) {
        float fi = float(i);
        float seed = fi * 17.0;

        float t = fract(hash11(seed) + time * 0.3);

        vec2 base = mix(start, end, t);

        float side = mix(-1.0, 1.0, step(0.5, hash11(seed + 1.0)));
        float branchLen = len * (0.08 + 0.12 * hash11(seed + 2.0));

        vec2 bdir = normalize(dir + perp * side * 0.7);
        vec2 bend = base + bdir * branchLen;

        float dSeg = sdSegment(p, base, bend);

        float core = 1.0 - smoothstep(len * 0.002, len * 0.004, dSeg);
        float glow = 1.0 - smoothstep(len * 0.008, len * 0.025, dSeg);

        outVal += core * 1.2 + glow * 0.5;
    }

    return clamp(outVal, 0.0, 1.0);
}

// ===== Sparks (preserved, slightly tuned) =====

float sparks(vec2 p, vec2 origin, float time, float maxAge) {
    float sparkIntensity = 0.0;

    for (int i = 0; i < 14; i++) {
        float fi = float(i);
        float seed = fi * 127.1;

        float age = fract(time * 2.0 + seed * 0.01) * maxAge;
        if (age > maxAge) continue;

        float angle = hash11(seed) * 6.28318 + time;
        float speed = 0.3 + hash11(seed + 1.0) * 0.4;

        vec2 vel = vec2(cos(angle), sin(angle)) * speed;
        vel.y -= 0.6 * age;

        vec2 sparkPos = origin + vel * age;

        float size = 0.004 * (1.0 - age / maxAge);
        float d = length(p - sparkPos);

        float brightness = (1.0 - age / maxAge);
        sparkIntensity += smoothstep(size, size * 0.2, d) * brightness;
    }

    return sparkIntensity;
}

// ===== Main =====

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    vec2 uv = normalizeCoords(fragCoord, 1.0);

    vec2 start = normalizeCoords(iPreviousCursor.xy, 1.0);
    vec2 end   = normalizeCoords(iCurrentCursor.xy, 1.0);

    float dist = distance(start, end);

    vec3 col = fragColor.rgb;

    if (dist > 0.002) {

        float bolt = lightningBolt(uv, start, end, iTime);
        float forks = lightningBranches(uv, start, end, iTime);

        vec3 coreColor = vec3(1.0);
        vec3 glowColor = vec3(0.45, 0.65, 1.0);

        col += glowColor * bolt * 0.9;
        col += coreColor * (bolt * 1.2 + forks * 0.8);

        // sparks at endpoint
        float sparkVal = sparks(uv, end, iTime, 0.8);
        col += vec3(1.0, 0.5, 0.1) * sparkVal * 1.5;
    }

    fragColor = vec4(col, 1.0);
}
