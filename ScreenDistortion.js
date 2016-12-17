@script ExecuteInEditMode
@script RequireComponent(Camera)
@script AddComponentMenu("Game/Image Effects/Screen Distortion")

/// <summary>
/// Screen distortion image effect based on Unity's standard assets image effects. As of this writing,
/// all of Unity's image effect classes (ie: PostEffectsBase) were only written in javascript.
/// </summary>
class ScreenDistortion extends PostEffectsBase {
	public var DistortionTexture:Texture2D = null;
	public var DistortionShader:Shader = null;
	public var IntensityX:float = 0.05;
	public var IntensityY:float = 0.05;

	private var m_distortionMaterial:Material = null;	
	
	/// <summary>
	/// Return true if this image effect is supported, false otherwise.
	/// </summary>
	function CheckResources():boolean {	
		CheckSupport(false);

		m_distortionMaterial = CheckShaderAndCreateMaterial(DistortionShader, m_distortionMaterial);
		
		if (!isSupported) {
		    ReportAutoDisable();
		}
		return isSupported;			
	}
	
	/// <summary>
	/// Perform calculations for when it's time to render the image effect.
	/// </summary>
	function OnRenderImage(source:RenderTexture, destination:RenderTexture) {	
        
		// If not supported, do nothing
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		
		// Compute shader params
		var aspectRatio = source.width / source.height;
		var widthOffsetPixels = (source.width - source.height) / 2.0;
		var widthOffsetPercent = widthOffsetPixels / source.width;

		// Set shader params
		m_distortionMaterial.SetFloat("aspectRatio", aspectRatio);
		m_distortionMaterial.SetFloat("widthOffsetPercent", widthOffsetPercent);
		m_distortionMaterial.SetVector("intensity", Vector2(IntensityX * aspectRatio, IntensityY));
		m_distortionMaterial.SetTexture("_NormalMap", DistortionTexture);
		
		// Draw
		Graphics.Blit(source, destination, m_distortionMaterial); 	
	}
}
