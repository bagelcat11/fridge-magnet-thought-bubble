shader_type canvas_item;

uniform vec4 base_color: source_color;
//uniform float fog_density: hint_range(0.0, 1.0) = 0.25;


void fragment() {
	vec3 fog_color_1 = texture(TEXTURE, vec2(UV.x/2.0 + TIME/100.0, UV.y/4.0 - TIME/100.0)).rgb;
	vec3 fog_color_2 = texture(TEXTURE, vec2(UV.x/2.0 + 0.5 + TIME/50.0, UV.y/4.0 + 0.5 - TIME/160.0)).rgb;
	vec3 fog_color_3 = texture(TEXTURE, vec2(UV.x/2.0 + 0.25 + TIME/100.0, UV.y/4.0 - 0.25 - TIME/160.0)).rgb;
	
	vec3 fog_color = mix(fog_color_3, mix(fog_color_1, fog_color_2, 0.5), 0.7);
	//vec3 fog_color = mix(fog_color_1, fog_color_3, 0.5);
	//vec3 fog_color = fog_color_1;
	float fog_r = clamp(fog_color.r * 2.0 - 1.0, 0.0, 1.0);

	COLOR.a *= base_color.a * fog_color.r;
	COLOR.rgb = fog_color * base_color.rgb * 1.7;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
