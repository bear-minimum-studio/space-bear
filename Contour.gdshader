shader_type canvas_item;

// source: https://godotshaders.com/shader/2d-outline-inline/

uniform vec4 color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform int pattern : hint_range(0, 2) = 0; // diamond, circle, square
uniform bool inside = false;
uniform bool add_margins = true; // only useful when inside is false

void vertex() {
	if (add_margins) {
		VERTEX += (UV * 2.0 - 1.0) * width;
	}
}

void fragment() {
	vec2 uv = UV;
	
	if (add_margins) {
		vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(width * 2.0));
		
		uv = (uv - texture_pixel_size * width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;
		
		if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
			COLOR.a = 0.0;
		} else {
			COLOR = texture(TEXTURE, uv);
		}
	} else {
		COLOR = texture(TEXTURE, uv);
	}
	
	// Neighbour search is inlined here (instead of a helper function taking the
	// TEXTURE builtin as a sampler2D argument), which Godot 4.7's shader compiler rejects.
	bool has_contrary_neighbour = false;
	if ((COLOR.a > 0.0) == inside) {
		for (float i = -ceil(width); i <= ceil(width) && !has_contrary_neighbour; i++) {
			float x = abs(i) > width ? width * sign(i) : i;
			float offset;

			if (pattern == 0) {
				offset = width - abs(x);
			} else if (pattern == 1) {
				offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
			} else if (pattern == 2) {
				offset = width;
			}

			for (float j = -ceil(offset); j <= ceil(offset); j++) {
				float y = abs(j) > offset ? offset * sign(j) : j;
				vec2 xy = uv + TEXTURE_PIXEL_SIZE * vec2(x, y);

				if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(TEXTURE, xy).a == 0.0) == inside) {
					has_contrary_neighbour = true;
					break;
				}
			}
		}
	}

	if (has_contrary_neighbour) {
		COLOR.rgb = inside ? mix(COLOR.rgb, color.rgb, color.a) : color.rgb;
		COLOR.a += (1.0 - COLOR.a) * color.a;
	}
}