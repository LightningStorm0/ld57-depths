shader_type canvas_item;

uniform vec4 shadow_color = vec4(0.1, 0.1, 0.3, 0.5);
uniform ivec2 offset_pixels = ivec2(1, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 shadow_uv = UV + (vec2(offset_pixels) / vec2(textureSize(TEXTURE, 0)) );
	
	COLOR = shadow_color;
	COLOR.a = texture(TEXTURE, shadow_uv).a * shadow_color.a;
	
	float solidAlpha = texture(TEXTURE, UV).a;
	
	COLOR.rgb -= COLOR.rgb * solidAlpha;
	COLOR.rgb += texture(TEXTURE, UV).rgb * solidAlpha;
	COLOR.a += solidAlpha;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
