#version 420 core

#include "rounded-rect.glsl"

layout(location = 0) in vec2 inPos;
layout(location = 1) in vec4 inColor;
layout(location = 2) in vec4 inRect;
layout(location = 3) in vec4 inCornerWidths;
layout(location = 4) in vec4 inCornerHeights;
layout(location = 5) in vec4 inBorderWidths;
layout(location = 6) in flat vec4 inClipBounds;
layout(location = 7) in flat vec4 inClipWidths;
layout(location = 8) in flat vec4 inClipHeights;

layout(location = 0) out vec4 color;

vec4
clip (vec4 color)
{
  RoundedRect r = RoundedRect (vec4(inClipBounds.xy, inClipBounds.xy + inClipBounds.zw), inClipWidths, inClipHeights);

  return color * rounded_rect_coverage (r, inPos);
}

void main()
{
  RoundedRect routside = RoundedRect (vec4(inRect.xy, inRect.xy + inRect.zw), inCornerWidths, inCornerHeights);
  RoundedRect rinside = rounded_rect_shrink (routside, inBorderWidths);
  
  float alpha = clamp (rounded_rect_coverage (routside, inPos) -
                       rounded_rect_coverage (rinside, inPos),
                       0.0, 1.0);
  color = clip (inColor);
}