# Shaders
A collection of shaders written in CG/ShaderLab for Unity used in the development of Poi.

Poi was shipped on Unity 5.5.3p1, but the shaders below have also been tested (somewhat) on Unity 2018.

---

### [BetterTransparentDiffuse.shader](BetterTransparentDiffuse.shader)
The default Unity shader for transparent objects suffers from some overlapping issues on complex objects (as seen on the left in the following image). This shader fixes the problem by rendering the object in two passes (as seen on the right). The center opaque image is for reference.<br /> <br />
![Alt text](Assets/Transparency.png "Transparent (improved)")

---

### [Silhouette.shader](Silhouette.shader)
This simple two-pass shader renders a silhouette on top of all other geometry when occluded. We used this effect in Poi for objects that weren't marked as camera occluders so players would always be able to see the character.<br /> <br />
![Alt text](Assets/Silhouette.png "Silhouette")

---

### [Stipple.shader](Stipple.shader)
This inexpensive screen-door transparency technique is useful for distance culling when traditional transparency is either too expensive or produces artifacts due to depth sorting. We used this in Poi to cull enemies when optimizing for lower-end hardware, specifically the Nintendo Switch.<br /> <br />
<p align="center">
  <img src="Assets/Stipple.gif" alt="Stipple">
</p>

---

### [HeatHaze.shader](HeatHaze.shader)
We achieved this depth-aware heat haze effect in Poi by attaching this shader to a geosphere with inverted normals as a child of the camera. This allowed us to easily animate the effect based on distance and didn't interfere with other post-processing effects.<br /> <br />
<p align="center">
  <img src="Assets/Heat.gif" alt="Heat Haze">
</p>

---

### [Checkerboard.shader](Checkerboard.shader)
This basic shader renders a checkerboard pattern (with support for two colors) using the existing vertex UV coords. We mainly used this for prototyping in Poi.<br /> <br />
![Alt text](Assets/Checker.png "Checkerboard")

---

### [DiffuseTwoSided.shader](DiffuseTwoSided.shader)
This is another basic shader that renders both sides of an object while accounting for correct normals. We used this technique in Poi for animated flags/cloth.<br /> <br />
![Alt text](Assets/TwoSided.png "Diffuse two-sided")

---

### [ScreenDistortion.shader](ScreenDistortion.shader)
This image effect takes a normal map as input and applies it to the screen as a post-process. The normal map will always be centered and scaled appropriately independent of aspect ratio and window resolution. We used this effect for the telescope item in Poi, but it would also work for weapons, binoculars, etc.<br /> <br />
![Alt text](Assets/Distort.png "Screen Distortion")
![Alt text](Assets/Distort2.png "Screen Distortion (in-game)")

---

### [ScrollingSprite.shader](ScrollingSprite.shader)
This shader extends Unity's default Sprite shader to allow for scrolling texture offsets. For non-Sprite shaders (eg: `Renderer` components), this can already be accomplished by modifying `material.mainTextureOffset`, but unfortunately this does not work for `SpriteRenderer` components, hence the need for this new shader.<br /> <br />
<p align="center">
  <img src="Assets/ScrollingSprite.gif" alt="Scrolling Sprite">
  <br /><br />
  <kbd><img src="Assets/ScrollingSprite.png" /></kbd>
</p>


