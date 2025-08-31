shader_type spatial;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 0.2) = 0.013;

render_mode cull_front, unshaded;

void vertex() {
    // 将顶点沿法线方向移动，形成轮廓
    VERTEX += NORMAL * outline_width;
}

void fragment() {
    ALBEDO = outline_color.rgb;
    ALPHA = outline_color.a;
}
