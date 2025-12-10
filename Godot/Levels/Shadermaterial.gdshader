shader_type spatial;

// Heightmap comes from GDScript.
// When unassigned, Godot provides black (0.0), so we must protect against that.
uniform sampler2D heightmap : hint_default_black;

// Strength of displacement from heightmap
uniform float displacement_strength = 20;

void vertex() {

    // --- Prevent deformation in the editor ---
    // ENGINE_EDITOR is true when NOT running the game.
#ifdef ENGINE_EDITOR
    return; // Keep the plane perfectly flat in the editor
#endif

    // --- Sample heightmap ---
    float h = texture(heightmap, UV).r;

    // If no heightmap is set yet (Godot gives 0.0), force flat height.
    if (h == 0.0) {
        h = 0.5;
    }

    // Convert grayscale value (0.0–1.0) into displacement above/below mid-level (0.5)
    float offset = h - 0.5;

    // Apply displacement
    // Because your mesh is rotated 180° on X, positive offset goes downward in world space.
    VERTEX.y += offset * displacement_strength;

    // Ensure normals respond correctly to lighting
    NORMAL = normalize(NORMAL);
}


void fragment() {
    // Soil color
    ALBEDO = vec3(0.25, 0.18, 0.10);

    // Rough, non-shiny dirt
    ROUGHNESS = 1.0;
}
