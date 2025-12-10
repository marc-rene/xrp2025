shader_type spatial;

uniform sampler2D heightmap : hint_default_black;
uniform float displacement_strength = 5.0;

// How much darker the soil gets in dips
uniform float darkening_strength = 1.5;


void vertex() {
#ifdef ENGINE_EDITOR
    return;
#endif

    float h = texture(heightmap, UV).r;
    if (h == 0.0) {
        h = 0.5;
    }

    float offset = h - 0.5;
    VERTEX.y += offset * displacement_strength;

    NORMAL = normalize(NORMAL);
}


void fragment() {
    // Base soil color
    vec3 base_color = vec3(0.25, 0.18, 0.10);

    // Sample heightmap again to darken low spots
    float h = texture(heightmap, UV).r;

    // Depth darkening: lower values = darker
    float dark_factor = 1.0 - (0.5 - h) * darkening_strength;

    // Clamp so it never goes too dark
    dark_factor = clamp(dark_factor, 0.3, 1.0);

    ALBEDO = base_color * dark_factor;

    ROUGHNESS = 1.0;
}
