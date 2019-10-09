// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "FlowingMenu",
  products: [
    .library(name: "FlowingMenu", targets: ["FlowingMenu"]),
  ],
  targets: [
    .target(
      name: "FlowingMenu",
      dependencies: [],
      path: "Sources"),
  ]
)

