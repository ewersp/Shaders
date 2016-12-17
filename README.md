# Shaders
A collection of shaders written in CG/ShaderLab for Unity.

BetterTransparentDiffuse.shader
------
The default Unity shader for transparent objects suffers from some overlapping issues on complex objects. This shader fixes the problem by rendering the object in two passes. (Left: Unity default, Center: Opaque, Right: Better transparent<br /> <br />
![Alt text](http://i.imgur.com/hdVh1cd.png "Transparent (improved)")

DiffuseTwoSided.shader
------
Sometimes you want to render both sides of an object (for example, if it's not totally convex or perhaps it's an animated plane used for a flag). <br /> <br />
![Alt text](http://i.imgur.com/aZl21ag.png "Diffuse two-sided")

ScreenDistortion.shader
------
This image effect takes a normal map as input and applies it to the screen as a post-process. The normal map will always be centered and scaled appropriately independent of aspect ratio and window resolution. We used this effect for the telescope item in Poi, but it would also work great for sniper scopes, etc.<br /> <br />
![Alt text](http://i.imgur.com/69SYsON.png "Screen Distortion")
