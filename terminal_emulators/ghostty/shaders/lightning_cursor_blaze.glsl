// Based on cursor_blaze.glsl with lightning trail and sparks
float ease(float x) {
    return pow(1.0 - x, 10.0);
}

float sdBox(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float blend(float t)
{
    float sqr = t * t;
    return sqr / (2.0 * (sqr - t) + 1.0);
}

float antialising(float distance) {
    return 1.0 - smoothstep(0.0, normalize(vec2(2.0, 2.0), 0.0).x, distance);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    float condition2 = step(a.x, b.x) * step(b.y, a.y);
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.0), rectangle.y - (rectangle.w / 2.0));
}

float hash11(float n) {
    return fract(sin(n) * 43758.5453123);
}

float hash12(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec2 hash22(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453);
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
    f += 0.5000 * noise(p); p *= 2.02;
    f += 0.2500 * noise(p); p *= 2.03;
    f += 0.1250 * noise(p); p *= 2.01;
    f += 0.0625 * noise(p);
    return f / 0.9375;
}

float lightning(vec2 p, vec2 start, vec2 end, float time) {
    vec2 dir = end - start;
    float len = length(dir);
    dir = normalize(dir);
    
    vec2 perp = vec2(-dir.y, dir.x);
    
    float t = clamp(dot(p - start, dir) / len, 0.0, 1.0);
    vec2 basePos = start + dir * t * len;
    
    float noiseScale = 8.0;
    float displacement = fbm(vec2(t * 20.0 + time * 10.0, time * 5.0)) - 0.5;
    displacement += fbm(vec2(t * 35.0 - time * 8.0, time * 3.0)) * 0.5;
    displacement *= 0.15 * len;
    
    float thickness = 0.008 + 0.004 * sin(t * 30.0 + time * 20.0);
    thickness *= smoothstep(0.0, 0.1, t) * smoothstep(1.0, 0.9, t);
    
    float dist = abs(dot(p - basePos, perp) - displacement);
    
    return smoothstep(thickness, thickness * 0.3, dist);
}

float sparks(vec2 p, vec2 origin, float time, float maxAge) {
    float sparkIntensity = 0.0;
    
    for (int i = 0; i < 12; i++) {
        float fi = float(i);
        float seed = fi * 127.1;
        
        float age = fract(time * 2.0 + seed * 0.01) * maxAge;
        if (age > maxAge * 0.9) continue;
        
        float angle = hash11(seed) * 6.28318 + time;
        float speed = 0.3 + hash11(seed + 1.0) * 0.4;
        float gravity = 0.5;
        
        vec2 vel = vec2(cos(angle), sin(angle)) * speed;
        vel.y -= gravity * age;
        
        vec2 sparkPos = origin + vel * age;
        
        float sparkSize = 0.003 * (1.0 - age / maxAge);
        float d = length(p - sparkPos);
        
        float brightness = (1.0 - age / maxAge) * (0.5 + 0.5 * sin(time * 30.0 + fi));
        sparkIntensity += smoothstep(sparkSize, sparkSize * 0.2, d) * brightness;
    }
    
    return sparkIntensity;
}

const vec4 TRAIL_COLOR = vec4(0.4, 0.6, 1.0, 1.0);
const vec4 TRAIL_COLOR_BRIGHT = vec4(0.7, 0.85, 1.0, 1.0);
const vec4 SPARK_COLOR = vec4(1.0, 0.5, 0.1, 1.0);
const vec4 CURRENT_CURSOR_COLOR = vec4(0.6, 0.8, 1.0, 1.0);
const float DURATION = 0.5;
const float SPARK_DURATION = 0.8;
const float DRAW_THRESHOLD = 1.5;
const float LINE_JUMP_THRESHOLD = 2.5;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif
    
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    vec4 newColor = vec4(fragColor);

    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1));
    float easedProgress = ease(progress);

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float cursorSize = max(currentCursor.z, currentCursor.w);
    float trailThreshold = DRAW_THRESHOLD * cursorSize;
    float lineLength = distance(centerCC, centerCP);
    float lineJump = abs(currentCursor.y - previousCursor.y) / cursorSize;
    
    bool isFarEnough = lineLength > trailThreshold;
    bool isBigJump = lineJump > LINE_JUMP_THRESHOLD;
    
    if (isFarEnough) {
        float sdfCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
        
        float lightningIntensity = 0.0;
        
        vec2 trailStart = previousCursor.xy;
        vec2 trailEnd = currentCursor.xy;
        
        for (int i = 0; i < 5; i++) {
            float fi = float(i);
            float t = fi / 5.0;
            vec2 samplePos = mix(trailStart, trailEnd, t);
            samplePos.y -= currentCursor.w * 0.5;
            
            float bolt = lightning(vu, trailStart, trailEnd, iTime + fi * 0.5);
            lightningIntensity += bolt * (0.8 - fi * 0.1);
        }
        
        lightningIntensity = clamp(lightningIntensity, 0.0, 1.0);
        
        if (lightningIntensity > 0.0) {
            float alphaModifier = clamp(lineLength / (distance(vu.xy, centerCC) + 0.01), 0.0, 1.0);
            alphaModifier = pow(alphaModifier, 0.5);
            
            vec4 boltColor = mix(TRAIL_COLOR, TRAIL_COLOR_BRIGHT, lightningIntensity * 0.5);
            newColor = mix(newColor, boltColor, lightningIntensity * 0.9 * easedProgress);
            
            float glow = lightningIntensity * 0.3;
            newColor.rgb += vec3(0.2, 0.3, 0.5) * glow * easedProgress;
        }
        
        newColor = mix(fragColor, newColor, smoothstep(sdfCursor, sdfCursor - 0.01, 0.0) * 0.0 + 1.0);
        fragColor = mix(newColor, fragColor, step(sdfCursor, 0.0));
    }
    
    if (isBigJump && isFarEnough) {
        float sparkProgress = clamp((iTime - iTimeCursorChange) / SPARK_DURATION, 0.0, 1.0);
        float sparkAge = sparkProgress * SPARK_DURATION;
        
        vec2 landingPos = currentCursor.xy;
        landingPos.y -= currentCursor.w * 0.5;
        
        float sparkIntensity = sparks(vu, landingPos, sparkAge, SPARK_DURATION);
        
        if (sparkIntensity > 0.0) {
            vec4 sparkCol = SPARK_COLOR * sparkIntensity * (1.0 - sparkProgress);
            sparkCol.rgb *= 1.0 + sparkIntensity;
            
            float sdfCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
            float cursorMask = smoothstep(sdfCursor, sdfCursor - 0.01, 0.0);
            
            fragColor.rgb = mix(fragColor.rgb, sparkCol.rgb, sparkCol.a * (1.0 - cursorMask * 0.5));
        }
    }
}
