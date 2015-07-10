void main(void) {
    lowp vec4 baseCol = texture2D(u_texture, v_tex_coord);
    lowp vec4 glowCol = vec4(
        baseCol.r * 1.,
        baseCol.r * 0.5,
        baseCol.r * 0.5,
        baseCol.a * 1.
    );
    baseCol.a *= 1.;
    gl_FragColor = baseCol + abs(sin(.35 * u_time)) * glowCol;
}
