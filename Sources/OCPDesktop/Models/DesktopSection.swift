import Foundation

enum DesktopSection: String, CaseIterable, Identifiable {
    case overview
    case setup
    case routes
    case execution
    case artifacts
    case protocolStatus
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview: "Overview"
        case .setup: "Setup Doctor"
        case .routes: "Routes"
        case .execution: "Execution"
        case .artifacts: "Artifacts"
        case .protocolStatus: "Protocol"
        case .settings: "Settings"
        }
    }

    var detail: String {
        switch self {
        case .overview: "Mesh command"
        case .setup: "One concrete fix"
        case .routes: "Route health"
        case .execution: "Worker capacity"
        case .artifacts: "Proof sync"
        case .protocolStatus: "Contract health"
        case .settings: "Node profile"
        }
    }

    var systemImage: String {
        switch self {
        case .overview: "gauge.with.dots.needle.67percent"
        case .setup: "stethoscope"
        case .routes: "point.3.connected.trianglepath.dotted"
        case .execution: "cpu"
        case .artifacts: "shippingbox"
        case .protocolStatus: "doc.text.magnifyingglass"
        case .settings: "slider.horizontal.3"
        }
    }
}
