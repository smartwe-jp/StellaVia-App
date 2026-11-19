// Run from fundex: swift tool/app_icon/generate.swift
// Uses macOS AppKit; no third-party image dependencies.
import AppKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .deletingLastPathComponent().deletingLastPathComponent()
let fm = FileManager.default
let sourceURL = root.appendingPathComponent("tool/app_icon/source.png")
guard let source = NSImage(contentsOf: sourceURL) else { fatalError("Missing source.png") }

func render(_ size: Int, fraction: CGFloat, transparent: Bool, to url: URL) throws {
    let context = CGContext(data: nil, width: size, height: size,
        bitsPerComponent: 8, bytesPerRow: size * 4,
        space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: (transparent ? CGImageAlphaInfo.premultipliedLast : CGImageAlphaInfo.noneSkipLast).rawValue)!
    context.interpolationQuality = .high
    if !transparent {
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: size, height: size))
    }
    let side = CGFloat(size) * fraction
    let inset = (CGFloat(size) - side) / 2
    let image = source.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    context.draw(image, in: CGRect(x: inset, y: inset, width: side, height: side))
    try fm.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(destination, context.makeImage()!, nil)
    guard CGImageDestinationFinalize(destination) else { fatalError("Failed writing \(url.path)") }

}

let catalog = root.appendingPathComponent("ios/Runner/Assets.xcassets/AppIcon.appiconset")
let json = try JSONSerialization.jsonObject(with: Data(contentsOf: catalog.appendingPathComponent("Contents.json"))) as! [String: Any]
let entries = json["images"] as! [[String: Any]]
var generated = Set<String>()
for item in entries {
    guard let filename = item["filename"] as? String, generated.insert(filename).inserted else { continue }
    let points = Double((item["size"] as! String).components(separatedBy: "x")[0])!
    let scale = Double((item["scale"] as! String).replacingOccurrences(of: "x", with: ""))!
    try render(Int((points * scale).rounded()), fraction: 0.74, transparent: false,
        to: catalog.appendingPathComponent(filename))
}
let res = root.appendingPathComponent("android/app/src/main/res")
let densities: [(String, Int, Int)] = [
    ("mdpi", 48, 108), ("hdpi", 72, 162), ("xhdpi", 96, 216),
    ("xxhdpi", 144, 324), ("xxxhdpi", 192, 432)
]
for (density, legacy, adaptive) in densities {
    let folder = res.appendingPathComponent("mipmap-\(density)")
    try render(legacy, fraction: 0.74, transparent: false, to: folder.appendingPathComponent("ic_launcher.png"))
    // 54/108 canvas leaves room for launcher masks and motion.
    try render(adaptive, fraction: 0.5, transparent: true, to: folder.appendingPathComponent("ic_launcher_foreground.png"))
}
let adaptiveFolder = res.appendingPathComponent("mipmap-anydpi-v26")
try fm.createDirectory(at: adaptiveFolder, withIntermediateDirectories: true)
try """
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@android:color/white" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
</adaptive-icon>

""".write(to: adaptiveFolder.appendingPathComponent("ic_launcher.xml"), atomically: true, encoding: .utf8)
print("Generated \(generated.count) iOS icons, 5 Android legacy icons and 5 adaptive foregrounds.")
