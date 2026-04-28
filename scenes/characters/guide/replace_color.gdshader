shader_type canvas_item;

// Khai báo 2 màu GỐC riêng biệt
uniform vec4 original_0 : source_color;
uniform vec4 original_1 : source_color;

// Khai báo 2 màu THAY THẾ riêng biệt
uniform vec4 replace_0 : source_color;
uniform vec4 replace_1 : source_color;

// Độ dung sai (Ông thầy gọi là precision)
const float precision = 0.1;

// Hàm xử lý đổi màu y hệt video
vec4 replace_color_func(vec4 color) {
    // Gom 2 màu gốc vào một mảng
    vec4 original_colors[2] = vec4[2](original_0, original_1);
    
    // Gom 2 màu thay thế vào một mảng
    vec4 replace_colors[2] = vec4[2](replace_0, replace_1);
    
    // Vòng lặp kiểm tra
    for(int i = 0; i < 2; i++) {
        if(distance(color, original_colors[i]) <= precision) {
            color = replace_colors[i];
        }
    }
    
    return color;
}

// Chạy hàm cho từng pixel
void fragment() {
    COLOR = replace_color_func(texture(TEXTURE, UV));
}