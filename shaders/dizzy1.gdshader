shader_type canvas_item;
render_mode blend_add;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap; // Agora correto para Godot 4

uniform float time_speed : hint_range(0.0, 5.0) = 1.0;
uniform float distortion_strength : hint_range(0.0, 2.0) = 0.5;
uniform float max_distortion_strength : hint_range(0.0, 5.0) = 2.0;
uniform float separation_strength : hint_range(0.0, 1.0) = 0.5;
uniform float distortion_size : hint_range(1.0, 20.0) = 10.0;
uniform float background_blur_strength : hint_range(0.0, 5.0) = 0.0; // Controle do desfoque do fundo

uniform vec4 color1 : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Vermelho
uniform vec4 color2 : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Verde
uniform vec4 color3 : source_color = vec4(0.0, 0.0, 1.0, 1.0); // Azul
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Fundo preto

uniform float rotation_time : hint_range(0.0, 20.0) = 10.0; // Tempo de rotação (em segundos)
uniform bool enable_rotation = true; // Ativar/desativar rotação
uniform bool show_text = true; // Ativar/desativar exibição de texto

vec2 rotate_uv(vec2 uv, float angle) {
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);
    float new_x = cos_angle * (uv.x - 0.5) - sin_angle * (uv.y - 0.5) + 0.5;
    float new_y = sin_angle * (uv.x - 0.5) + cos_angle * (uv.y - 0.5) + 0.5;
    return vec2(new_x, new_y);
}

// Função para simular desfoque pegando várias amostras ao redor do pixel
vec4 blur_background(vec2 uv, float strength) {
    vec4 sum = vec4(0.0);
    int samples = 9; // Número de amostras para o desfoque
    float spread = strength * 0.01; // Ajusta o tamanho do desfoque

    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * spread;
            sum += texture(SCREEN_TEXTURE, uv + offset);
        }
    }

    return sum / float(samples); // Média das amostras para criar o efeito de desfoque
}

void fragment() {
    vec2 uv = UV;

    // Rotação suave
    if (enable_rotation) {
        float cycle_time = mod(TIME, rotation_time * 2.0);
        float rotation_factor = smoothstep(0.0, rotation_time, cycle_time);
        float angle = rotation_factor * 3.14159;
        uv = rotate_uv(uv, angle);
    }

    // Controle dinâmico da força da distorção
    float dynamic_distortion = distortion_strength + (sin(TIME * 0.8) * 0.5 + 0.5) * max_distortion_strength;

    // Distorção com offsets mais agressivos
    float offset_x = sin(uv.y * distortion_size + TIME * time_speed) * dynamic_distortion;
    float offset_y = cos(uv.x * distortion_size + TIME * time_speed) * dynamic_distortion;

    uv.x += offset_x;
    uv.y += offset_y;

    // Mistura dinâmica das cores
    float mix_factor1 = sin(uv.x * distortion_size + TIME) * 0.5 + 0.5;
    float mix_factor2 = cos(uv.y * distortion_size + TIME * 0.5) * 0.5 + 0.5;

    // Separação das cores, variando a intensidade
    float separation = sin(TIME) * 0.5 + 0.5;
    separation = smoothstep(0.4, 0.6, separation) * separation_strength;

    // Mistura de cores
    vec4 mix_color = mix(color1, color2, mix_factor1);
    mix_color = mix(mix_color, color3, mix_factor2);

    // Máscara para separar as cores ao longo do tempo
    float mask = sin(uv.x * distortion_size * 0.5 + uv.y * distortion_size * 0.5 + TIME * 2.0);
    mask = smoothstep(-separation, separation, mask);

    // Obtém a cor do fundo desfocada
    vec4 blurred_background = blur_background(uv, background_blur_strength);

    // Interpola entre o fundo desfocado e o fundo normal
    vec4 final_background = mix(background_color, blurred_background, background_blur_strength);

    // Cor final do fragmento
    COLOR = mix(final_background, mix_color, mask);
}

//from https://godotshaders.com/shader/fluid-distortion-or-marble-shader/