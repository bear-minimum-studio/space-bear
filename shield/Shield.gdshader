shader_type canvas_item;


uniform float opacity: hint_range(0.0,1.0) = 1.0;
uniform float health_amount: hint_range(0.0,1.0) = 1.0;
uniform float hit_intensity: hint_range(0.0,1.0) = 0.0;
uniform float honeycomb: hint_range(0.0,10.0) = 3.0;
uniform float osc_amount: hint_range(0.0,0.3) = 0.0;
uniform float osc_speed: hint_range(0.0,15.0) = 1.0;

uniform vec4 color: source_color = vec4(0.45, 0.53, 1.0, 1.0);

uniform float outer_size = 0.269;
uniform float feather_size = 0.262;



float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void fragment(){
	float actual_opacity = 0.14 * opacity;
	float actual_feather_size = feather_size + 0.25 * (1.0 - health_amount);
	float actual_outer_size = outer_size + 0.0 * (1.0 - health_amount);
	
	float outer = circle(vec2(UV.x, UV.y), 0.35, 0.01);
	float fade_oscillation = sin(TIME) * 0.01;
	float inner = 1.0 - circle(vec2(UV.x, UV.y), actual_outer_size, actual_feather_size - fade_oscillation - actual_opacity);
	
	float honeycomb_oscillation = (sin(TIME * osc_speed * (hit_intensity+0.5)) - 0.5) * osc_amount;
	
	float hexagon_transparency = COLOR.a ; 

	if (outer < 0.01)
	{
		COLOR = color;
		COLOR.a -= outer + inner; 
		COLOR.a += hit_intensity * honeycomb * mix(1.0 - hexagon_transparency + honeycomb_oscillation, 0.0, 1.0 - health_amount) * actual_opacity * mix(1.0, 0.0, distance(vec2(0.5),UV) / 0.35);
	}
	else
	{
		COLOR.a = 0.0;
	}

}