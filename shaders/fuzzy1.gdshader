shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.15;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = texture(SCREEN_TEXTURE, uv);

    float noise = random(uv + TIME*0.3) * 2.0 - 1.0;

    color.rgb += noise * noise_intensity;

    COLOR = color;
}
//from https://godotshaders.com/shader/noise-grain/