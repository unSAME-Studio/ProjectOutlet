shader_type canvas_item;

uniform float blur_amount : hint_range(-2.0, 10.0);
uniform float mix_amount : hint_range(0.0, 1.0);
uniform vec4 color_main : hint_color;
uniform vec4 color_over : hint_color;


vec4 blur9sampleFunc(sampler2D _samp_b1ur, vec2 _uv_b1ur, float _lod_b1ur, float _rad_b1ur){
	vec4 _c01r_b1ur = vec4(0.0);
	if (_lod_b1ur < 0.0){
		_c01r_b1ur = texture(_samp_b1ur, _uv_b1ur);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(0, - _rad_b1ur) * 0.01);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(0, _rad_b1ur) * 0.01);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(- _rad_b1ur, 0) * 0.01);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(_rad_b1ur, 0) * 0.01);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(- _rad_b1ur, - _rad_b1ur) * 0.01);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(- _rad_b1ur, _rad_b1ur) * 0.01);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(_rad_b1ur, _rad_b1ur) * 0.01);
		_c01r_b1ur += texture(_samp_b1ur, _uv_b1ur + vec2(_rad_b1ur, -_rad_b1ur) * 0.01);
	}else{
		_c01r_b1ur = textureLod(_samp_b1ur, _uv_b1ur, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(0, - _rad_b1ur) * 0.01, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(0, _rad_b1ur) * 0.01, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(- _rad_b1ur, 0) * 0.01, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(_rad_b1ur, 0) * 0.01, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(- _rad_b1ur, - _rad_b1ur) * 0.01, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(- _rad_b1ur, _rad_b1ur) * 0.01, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(_rad_b1ur, _rad_b1ur) * 0.01, _lod_b1ur);
		_c01r_b1ur += textureLod(_samp_b1ur, _uv_b1ur + vec2(_rad_b1ur, -_rad_b1ur) * 0.01, _lod_b1ur);
	}
	_c01r_b1ur /= 9.0;
	return _c01r_b1ur;
}


// Blurs the screen in the X-direction.
void fragment() {
    vec4 blurred = blur9sampleFunc(SCREEN_TEXTURE, SCREEN_UV, blur_amount, blur_amount);
	vec4 fin = mix(blurred, color_main, 0.8);
	fin = mix(fin, color_over, mix_amount);
	COLOR = fin;
}