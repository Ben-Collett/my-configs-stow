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

    float clampedLen = min(len, 0.15);

    for (int i = 1; i <= N; i++) {
        float t = float(i) / float(N);
        float taper = pow(sin(3.14159265 * t), 1.3);

        float j = boltNoise(t, time);
        float amp = clampedLen * 0.12 * taper;

        vec2 cur = mix(start, end, t) + perp * j * amp;

        minD = min(minD, sdSegment(p, prev, cur));
        prev = cur;
    }

    float core = 1.0 - smoothstep(clampedLen * 0.002, clampedLen * 0.006, minD);
    float glow = 1.0 - smoothstep(clampedLen * 0.012, clampedLen * 0.045, minD);

    float along = clamp(dot(p - start, dir) / max(len, 1e-4), 0.0, 1.0);
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

// ===== Sparks =====

float sparks(vec2 p, vec2 origin, float time, float sparkTime) {
    float sparksVal = 0.0;

    const int SPARK_COUNT = 18;

    for (int i = 0; i < SPARK_COUNT; i++) {
        float fi = float(i);

        float seed = hash11(fi + time * 17.0);

        float angle = seed * 6.28318;
        vec2 dir = vec2(cos(angle), sin(angle));

        float upwardBias = mix(0.6, 1.6, step(0.0, dir.y));

        float speed = (0.10 + hash11(fi * 3.1) * 0.18) * upwardBias;

        float gravity = -0.35;

        vec2 pos = origin + dir * sparkTime * speed;
        pos.y += gravity * sparkTime * sparkTime;

        float d = length(p - pos);

        float sparkHead = smoothstep(0.006, 0.0, d);

        vec2 prev = origin + dir * (sparkTime - 0.04) * speed;
        prev.y += gravity * (sparkTime - 0.04) * (sparkTime - 0.04);

        vec2 pa = p - prev;
        vec2 ba = pos - prev;

        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        float lineDist = length(pa - ba * h);

        float sparkTrail = smoothstep(0.0035, 0.0, lineDist) * 0.9;

        sparksVal += sparkHead + sparkTrail;
    }

    sparksVal *= (1.0 - sparkTime);

    return sparksVal;
}

// ===== Constants =====

const float DURATION = 0.5;
const float SPARK_DURATION = 0.28;
const float DRAW_THRESHOLD = 1.5;

// ===== Main =====

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    vec2 uv = normalizeCoords(fragCoord, 1.0);

    vec4 currentCursor = vec4(normalizeCoords(iCurrentCursor.xy, 1.0), normalizeCoords(iCurrentCursor.zw, 0.0));
    vec4 previousCursor = vec4(normalizeCoords(iPreviousCursor.xy, 1.0), normalizeCoords(iPreviousCursor.zw, 0.0));

    vec2 currentCenter = vec2(currentCursor.x + currentCursor.z * 0.5, currentCursor.y - currentCursor.w * 0.5);
    vec2 previousCenter = vec2(previousCursor.x + previousCursor.z * 0.5, previousCursor.y - previousCursor.w * 0.5);

    float cursorWidth = currentCursor.z;
    float cursorHeight = currentCursor.w;

    float lineLength = distance(currentCenter, previousCenter);
    float drawThreshold = DRAW_THRESHOLD * max(cursorWidth, cursorHeight);

    vec3 col = fragColor.rgb;

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float sparkProgress = (iTime - iTimeCursorChange) / SPARK_DURATION;

    if (lineLength > drawThreshold && progress < 1.0) {
        vec2 start = previousCenter;
        vec2 end = currentCenter;

        float bolt = lightningBolt(uv, start, end, iTime);
        float forks = lightningBranches(uv, start, end, iTime);

        vec3 coreColor = vec3(1.0);
        vec3 glowColor = vec3(0.45, 0.65, 1.0);

        float fadeOut = 1.0 - progress;
        fadeOut = fadeOut * fadeOut;

        col += glowColor * bolt * 0.9 * fadeOut;
        col += coreColor * (bolt * 1.2 + forks * 0.8) * fadeOut;

        if (sparkProgress < 1.0 && sparkProgress > 0.0) {
            float sparkVal = sparks(uv, end, iTimeCursorChange, sparkProgress);
            col += vec3(1.6, 0.7, 0.2) * sparkVal * 1.5;
        }
    }

    fragColor = vec4(col, 1.0);
}