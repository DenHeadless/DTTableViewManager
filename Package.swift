// swift-tools-version:5.0
//
//  Package.swift
//  DTTableViewManager
//
//  Created by Denys Telezhkin on 17.07.2019.
//  Copyright © 2019 Denys Telezhkin. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import PackageDescription

let package = Package(
    name: "DTTableViewManager",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9)
    ],
    products: [
        .library(name: "DTTableViewManager", targets: ["DTTableViewManager"])
    ],
    dependencies: [
        .package(url: "https://github.com/DenTelezhkin/DTModelStorage", Package.Dependency.Requirement.exact("8.0.0-beta.2"))
    ],
    targets: [
        .target(name: "DTTableViewManager", dependencies: ["DTModelStorage"]),
        // .testTarget(name: "Tests-iOS", dependencies: ["DTTableViewManager", "DTModelStorage"], path: "Sources/Tests")
    ],
    swiftLanguageVersions: [.v5, .v4_2]
)