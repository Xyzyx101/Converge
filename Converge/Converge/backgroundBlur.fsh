void main(void) {
    
    vec4 sum = vec4(0.0);
    int x ;
    int y ;
    lowp vec4 color = texture2D(u_texture,v_tex_coord);
    
    for (x = -1; x<= 1; ++x) {
        for (y = -1; y<= 1; ++y) {
            vec2 offset = vec2(x,y) * 0.05 ;
            sum += texture2D(u_texture,v_tex_coord + offset);
        }
    }
    gl_FragColor = sin(u_time) * ( sum * 0.01 ) + color ;
}