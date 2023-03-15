shader_type canvas_item;

uniform float grayer: hint_range(0.0,1.0,0.01) = 0.5;
uniform float darker: hint_range(0.0,1.0,0.01) = 0.5;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	float gray = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	float new_gray = mix(gray, 0.0, darker);
	COLOR.rgb = mix(COLOR.rgb, vec3(new_gray), grayer);
}
