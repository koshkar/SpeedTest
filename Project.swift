import ProjectDescription

let project = Project(
    name: "SpeedTestIos",
    targets: [
        .target(
            name: "SpeedTestIos",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SpeedTestIos",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["SpeedTestIos/Sources/**"],
            resources: ["SpeedTestIos/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "SpeedTestIosTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.SpeedTestIosTests",
            infoPlist: .default,
            sources: ["SpeedTestIos/Tests/**"],
            resources: [],
            dependencies: [.target(name: "SpeedTestIos")]
        ),
    ]
)
