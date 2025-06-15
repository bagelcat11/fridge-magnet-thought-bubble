// chromatic aberration
//---------------------------------

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec2 r_displacement = vec2(10.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-10.0, 0.0);



void fragment()
{
	float time = TIME + 1000.0;
	//float rand = fract(sin(dot(SCREEN_UV.xy, vec2(12.9898,78.233))) * 43758.5453123);
	//int rand_int = 1;
	//if (rand > 0.3 && rand < 0.6) {
		//rand_int = 2;
	//} else if (rand >= 0.6) {
		//rand_int = 3;
	//}
	
	float r = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*r_displacement * (mod(time, 2.0)+1.0)), 0.0).r;
	float g = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*g_displacement), 0.0).g;
	float b = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*b_displacement * (mod(time, 2.0)+1.0)), 0.0).b;

	COLOR = vec4(r, g, b, 1.0);
}