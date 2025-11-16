// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "CompiletSDK",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "CompiletSDK",
      targets: ["CompiletSDK"]
    )
  ],
  targets: [
    .binaryTarget(
      name: "CompiletSDK",
      url: "https://github.com/compilet-dev/ios-compilet-sdk/releases/download/v1.0.0/CompiletSDK.xcframework.zip",
      checksum: "354d123d522763faceb1002d01b77d199699088945a997191d32b49a610a9423"
    )
  ]
)
