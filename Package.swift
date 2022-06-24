// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "Onboarding",
	platforms: [
		.iOS("15.0"),
		.macOS("12.0"),
	],
	products: [
		.library(
			name: "Onboarding",
			targets: ["Onboarding"]),
	],
	dependencies: [
		.package(url: "https://github.com/NoPassword-Swift/ConstraintKit.git", "0.0.1"..<"0.1.0"),
		.package(url: "https://github.com/NoPassword-Swift/NPKit.git", "0.0.1"..<"0.1.0"),
	],
	targets: [
		.target(
			name: "Onboarding",
			dependencies: [
				"ConstraintKit",
				"NPKit",
			]),
	]
)
