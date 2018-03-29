package openfl.display;


import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class GraphicsShader extends Shader {
	
	
	@:glVertexHeader(
		
		"attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TexCoord;
		
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TexCoordv;
		
		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;"
		
	)
	
	
	@:glVertexBody(
		
		"openfl_Alphav = openfl_Alpha;
		openfl_TexCoordv = openfl_TexCoord;
		
		if (openfl_HasColorTransform) {
			
			openfl_ColorMultiplierv = openfl_ColorMultiplier;
			openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
			
		}
		
		gl_Position = openfl_Matrix * openfl_Position;"
		
	)
	
	
	@:glVertexSource(
		
		"#pragma header
		
		void main(void) {
			
			#pragma body
			
		}"
		
	)
	
	
	@:glFragmentHeader(
		
		"varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TexCoordv;
		
		uniform bool openfl_HasColorTransform;
		uniform sampler2D bitmap;"
		
	)
	
	
	@:glFragmentBody(
		
		"vec4 color = texture2D (bitmap, openfl_TexCoordv);
		
		if (color.a == 0.0) {
			
			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
			
		} else if (openfl_HasColorTransform) {
			
			color = vec4 (color.rgb / color.a, color.a);
			
			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
			
			color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
			
			if (color.a > 0.0) {
				
				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
				
			} else {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			}
			
		} else {
			
			gl_FragColor = color * openfl_Alphav;
			
		}"
		
	)
	
	
	@:glFragmentSource(
		
		#if emscripten
		"#pragma header
		
		void main(void) {
			
			#pragma body
			
			gl_FragColor = gl_FragColor.bgra;
			
		}"
		#else
		"#pragma header
		
		void main(void) {
			
			#pragma body
			
		}"
		#end
		
	)
	
	
	public function new (code:ByteArray = null) {
		
		#if !flash
		__isGraphicsShader = true;
		#end
		
		super (code);
		
	}
	
	
}