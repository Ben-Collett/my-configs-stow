// Electric Cursor Blaze + Jump Sparks

float ease(float x) {
    return pow(1.0 - x, 6.0);
}

float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);

    float n = p.x + p.y * 57.0;

    return mix(
        mix(hash(n), hash(n + 1.0), f.x),
        mix(hash(n + 57.0), hash(n + 58.0), f.x),
        f.y
    );
}

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w,e)/dot(e,e),0.0,1.0);
    float segd = dot(p-proj,p-proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y-a.y);
    float c1 = 1.0-step(0.0, p.y-b.y);
    float c2 = 1.0-step(0.0, e.x*w.y-e.y*w.x);

    float allCond = c0*c1*c2;
    float noneCond = (1.0-c0)*(1.0-c1)*(1.0-c2);

    float flip = mix(1.0,-1.0,step(0.5,allCond+noneCond));
    s *= flip;

    return d;
}

float getSdfParallelogram(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float s = 1.0;
    float d = dot(p-v0,p-v0);

    d = seg(p,v0,v3,s,d);
    d = seg(p,v1,v0,s,d);
    d = seg(p,v2,v1,s,d);
    d = seg(p,v3,v2,s,d);

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value*2.0-(iResolution.xy*isPosition))/iResolution.y;
}

float blend(float t) {
    float sqr = t*t;
    return sqr/(2.0*(sqr-t)+1.0);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    float c1 = step(b.x,a.x)*step(a.y,b.y);
    float c2 = step(a.x,b.x)*step(b.y,a.y);
    return 1.0-max(c1,c2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x+(rectangle.z/2.), rectangle.y-(rectangle.w/2.));
}

const vec4 TRAIL_COLOR = vec4(0.2,0.7,1.0,1.0);
const vec4 TRAIL_COLOR_ACCENT = vec4(1.0,1.0,1.0,1.0);

const float DURATION = 0.5;
const float SPARK_DURATION = 0.25;
const float DRAW_THRESHOLD = 1.5;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
#if !defined(WEB)
fragColor = texture(iChannel0, fragCoord.xy/iResolution.xy);
#endif

vec2 vu = normalize(fragCoord,1.);
vec2 offsetFactor = vec2(-.5,0.5);

vec4 currentCursor = vec4(normalize(iCurrentCursor.xy,1.), normalize(iCurrentCursor.zw,0.));
vec4 previousCursor = vec4(normalize(iPreviousCursor.xy,1.), normalize(iPreviousCursor.zw,0.));

float vertexFactor = determineStartVertexFactor(currentCursor.xy,previousCursor.xy);
float invVertex = 1.0-vertexFactor;

vec2 v0 = vec2(currentCursor.x+currentCursor.z*vertexFactor,currentCursor.y-currentCursor.w);
vec2 v1 = vec2(currentCursor.x+currentCursor.z*invVertex,currentCursor.y);
vec2 v2 = vec2(previousCursor.x+currentCursor.z*invVertex,previousCursor.y);
vec2 v3 = vec2(previousCursor.x+currentCursor.z*vertexFactor,previousCursor.y-previousCursor.w);

vec4 newColor = fragColor;

float progress = blend(clamp((iTime-iTimeCursorChange)/DURATION,0.0,1.0));
float easedProgress = ease(progress);

vec2 centerCC = getRectangleCenter(currentCursor);
vec2 centerCP = getRectangleCenter(previousCursor);

float lineLength = distance(centerCC,centerCP);

if(lineLength > DRAW_THRESHOLD*max(currentCursor.z,currentCursor.w))
{
    float sdfTrail = getSdfParallelogram(vu,v0,v1,v2,v3);

    sdfTrail *= 1.33;

    float lightning = noise(vu*80.0+iTime*10.0);
    sdfTrail += (lightning-0.5)*0.01;

    float core = smoothstep(0.002,-0.002,sdfTrail);
    float glow = smoothstep(0.02,-0.01,sdfTrail);

    float flicker = 0.7+0.3*sin(iTime*40.0+noise(vu*50.0)*10.0);

    vec4 electric =
        TRAIL_COLOR_ACCENT*core*flicker +
        TRAIL_COLOR*glow;

    float alphaModifier = distance(vu.xy,centerCC)/(lineLength*(easedProgress));
    alphaModifier = clamp(alphaModifier,0.0,1.0);

    newColor = mix(newColor,electric,glow);
    newColor = mix(fragColor,newColor,1.0-alphaModifier);
}

float jumpDist = distance(centerCC, centerCP);
float sparkTime = (iTime - iTimeCursorChange) / 0.28;

if (jumpDist > 0.25 && sparkTime < 1.0)
{
    vec2 sparkCenter = centerCC;

    float sparks = 0.0;

    const int SPARK_COUNT = 18;

    for (int i = 0; i < SPARK_COUNT; i++)
    {
        float fi = float(i);

        float seed = hash(fi + iTimeCursorChange * 17.0);

        float angle = seed * 6.28318;
        vec2 dir = vec2(cos(angle), sin(angle));

        // upward sparks get more force
        float upwardBias = mix(0.6, 1.6, step(0.0, dir.y));

        float speed = (0.10 + hash(fi * 3.1) * 0.18) * upwardBias;

        float gravity = -0.35;

        vec2 pos = sparkCenter + dir * sparkTime * speed;
        pos.y += gravity * sparkTime * sparkTime;

        float d = length(vu - pos);

        float sparkHead = smoothstep(0.006, 0.0, d);

        // ---- SHARP TRAIL ----

        vec2 prev = sparkCenter + dir * (sparkTime - 0.04) * speed;
        prev.y += gravity * (sparkTime - 0.04) * (sparkTime - 0.04);

        vec2 pa = vu - prev;
        vec2 ba = pos - prev;

        float h = clamp(dot(pa,ba)/dot(ba,ba),0.0,1.0);
        float lineDist = length(pa - ba*h);

        float sparkTrail = smoothstep(0.0035, 0.0, lineDist) * 0.9;

        sparks += sparkHead + sparkTrail;
    }

    sparks *= (1.0 - sparkTime);

    vec3 sparkColor = vec3(1.6, 0.7, 0.2);

    newColor.rgb += sparkColor * sparks;
}
fragColor = newColor;
}
