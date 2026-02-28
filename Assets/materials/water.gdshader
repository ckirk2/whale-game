shader_type spatial;
render_mode world_vertex_coords;
// Water color
uniform vec4 primary_color: source_color = vec4(0.0, 0.2, 1.0, 1.0);
uniform vec4 secondary_color: source_color = vec4(0.0, 0.2, 1.0, 1.0);
// Amount of height for each triangle
uniform float amount: hint_range(0.2, 5.0, 0.1) = 0.8;
// The speed of the trangles height change
uniform float speed: hint_range(0.1, 5.0, 0.1) = 1;
// Water visuals
uniform float distance_from_shore_factor = 50;
uniform float metallic = 0.6;
uniform float specular = 0.5;
uniform float roughness = 0.2;
uniform float height_scale = 1.0;
uniform float noise_height_scale = 1.0;
uniform float sample_distance = 0.1;
uniform float wave_frequency = 1.0;

// Depth
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;
uniform float depth_distance : hint_range(0.0,20.0,0.01)=4.0;
uniform float beers_law : hint_range(0.0, 20.0, 0.1)=12.0;
uniform float water_transparency : hint_range(0.0,1.0,0.001) = 0.05;

varying float vertex_height;

float generateOffset(float x, float z, float val1, float val2, float time) {
	float radiansX = ((mod(x + z * x * val1, amount) / amount) + (time * speed) * mod(x * 0.8 + z, 1.5)) * 2.0 * 3.14;
	float radiansZ = ((mod(val2 * (z * x + x * z), amount) / amount) + (time * speed) * 2.0 * mod(x, 2.0)) * 2.0 * 3.14;

	return amount * 0.5 * (sin(radiansZ) * cos(radiansX));
}

vec3 applyDistortion(vec3 vertex, float time) {
	float xd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time);
	float yd = generateOffset(vertex.x, vertex.z, 0.1, 0.3, time);
	float zd = generateOffset(vertex.x, vertex.z, 0.15, 0.2, time);

	return vertex + vec3(xd, yd*noise_height_scale, zd);
}

float fresnel(float fersnel_amount, vec3 normal, vec3 view)
{
	return pow((1.0-clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), fersnel_amount);
}


void vertex() {
	VERTEX = applyDistortion(VERTEX, TIME * 0.1);
	VERTEX.y += cos(VERTEX.z +TIME * wave_frequency) * height_scale * VERTEX.z/distance_from_shore_factor;
}

void fragment() {
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));

	float basic_fresnel = fresnel(3.0, NORMAL, VIEW);
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roughness * (1.0-basic_fresnel);
	// Get depth in world position y
	float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	vec3 screen = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc,1.0);
	float depth_texture_y = world.y / world.w;
	float vertex_y = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y;
	// Set Depth blend and adjust with beer's
	float depth_blend = clamp((vertex_y - depth_texture_y) / depth_distance, 0.0, 1.0);
	depth_blend = exp(-depth_blend*beers_law);

	// Set depth color mix
	vec3 depth_color = mix(secondary_color, primary_color, depth_blend).rbg;
	vec3 final_color = mix(depth_color.rgb, screen, water_transparency);

	ALBEDO = mix(final_color, screen, depth_blend*(1.0-basic_fresnel));

}