# App icons

Source: user-provided purple `favicon.png` (800 × 800 RGBA), updated 2026-11-19.
`source.png` is the original artwork, stored here rather than bundled as a Flutter asset.

Regenerate on macOS from `fundex/`:

```sh
rtk proxy swift tool/app_icon/generate.swift
```

- iOS: regenerate every filename in the existing AppIcon Contents.json. White RGB background without alpha; includes the 1024 px marketing icon. The 800 px raster source is resampled for this size.
- Android: replace mdpi–xxxhdpi launcher PNGs (48–192 px). API 26+ resolves the same `@mipmap/ic_launcher` name to an adaptive icon with a white background and transparent foregrounds (108–432 px).
- Preserve the logo proportions. Legacy/iOS artwork uses 74% of the canvas, matching the previous white-background spacing approximately. Adaptive artwork uses 50% of the full layer canvas to allow launcher masking and motion.
- Do not pre-round iOS corners; the operating system applies the mask.

Validation: checked every catalog entry's pixel dimensions, RGB/no-alpha iOS output, and all Android PNG dimensions/alpha channels. Device launcher appearance requires rebuilding/reinstalling the app; hot reload does not replace launcher icons.
