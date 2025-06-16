shader_type canvas_item;

// get the texture of the screen
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float rotation = 3.0;

uniform vec4 color_gap = vec4(0.25, 0, 0, 0);
uniform vec4 color_stripe = vec4(1.0, 0.0, 1.0, 0.2);
uniform float divisions = 16.0; // increase for more stripe density
uniform float stripe_bias = 1.5; // 1.0 means no stripes; 2.0 means stripes and gaps are equal size
uniform float speed = 0.05;
uniform float angle = 0.3; // in radians

//uniform float brightness = 1;
//uniform float contrast = 1;
//uniform float saturation = 1;

void vertex() {
	// Called for every vertex the material is visible on.
	//COLOR = vec4(UV, UV);
}

void fragment() {
	// Called for every pixel the material is visible on.

	// WHIRL
	vec2 uv = SCREEN_UV;
	vec2 rel = uv - vec2(0.5, 0.5);
	float whirl_angle = length(rel) * rotation;
	mat2 rot = mat2(vec2(cos(whirl_angle), -sin(whirl_angle)), vec2(sin(whirl_angle), cos(whirl_angle)));
	rel = rot * rel;
	uv = clamp(rel + vec2(0.5,0.5), vec2(0.0, 0.0), vec2(1.0, 1.0));
	COLOR.rgb = textureLod(screen_texture, uv, 0.0).rgb;

	// MOVING STRIPES
	//float w = cos(angle) * UV.x + sin(angle) * UV.y - speed * TIME;
	//if (floor(mod(w * divisions, stripe_bias)) < 0.0001) {
		//COLOR = color_gap;
	//} else {
		//COLOR = color_stripe;
	//}

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

//from https://github.com/godotengine/godot-demo-projects/blob/3.5-9e68af3/2d/screen_space_shaders/shaders/whirl.shader