import Foundation

public struct TopologyNode: Equatable, Identifiable, Sendable {
    public var id: String
    public var label: String
    public var role: String
    public var status: String
    public var subtitle: String

    public init(id: String, label: String, role: String, status: String, subtitle: String = "") {
        self.id = id
        self.label = label
        self.role = role
        self.status = status
        self.subtitle = subtitle
    }
}

public struct TopologyEdge: Equatable, Identifiable, Sendable {
    public var source: String
    public var target: String
    public var status: String
    public var freshness: String
    public var label: String

    public var id: String { "\(source)->\(target):\(label)" }

    public init(source: String, target: String, status: String, freshness: String = "", label: String = "") {
        self.source = source
        self.target = target
        self.status = status
        self.freshness = freshness
        self.label = label
    }
}

public struct TopologyGraph: Equatable, Sendable {
    public var nodes: [TopologyNode]
    public var edges: [TopologyEdge]

    public static let empty = TopologyGraph(nodes: [], edges: [])
}

public struct SetupGuideStep: Equatable, Identifiable, Sendable {
    public var id: String
    public var title: String
    public var summary: String
    public var status: String
    public var action: String

    public init(id: String, title: String, summary: String, status: String, action: String) {
        self.id = id
        self.title = title
        self.summary = summary
        self.status = status
        self.action = action
    }
}

public enum MissionControlDeriver {
    public static func topology(from snapshot: AppStatusSnapshot?) -> TopologyGraph {
        guard let snapshot else {
            return TopologyGraph(
                nodes: [TopologyNode(id: "local", label: "This Mac", role: "local", status: "local_only", subtitle: "Start OCP to map the mesh.")],
                edges: []
            )
        }
        let localID = clean(snapshot.node?.nodeID) ?? "local"
        var nodes: [String: TopologyNode] = [
            localID: TopologyNode(
                id: localID,
                label: clean(snapshot.node?.displayName) ?? clean(snapshot.node?.nodeID) ?? "This Mac",
                role: "local",
                status: snapshot.setup?.status ?? "ready",
                subtitle: snapshot.node?.formFactor ?? "OCP node"
            )
        ]
        var edges: [TopologyEdge] = []

        for route in snapshot.routeHealth?.routes ?? [] {
            guard let peerID = clean(route.peerID ?? route.displayName) else { continue }
            nodes[peerID] = TopologyNode(
                id: peerID,
                label: clean(route.displayName) ?? peerID,
                role: "peer",
                status: route.status ?? "unknown",
                subtitle: route.freshness ?? "route"
            )
            edges.append(
                TopologyEdge(
                    source: localID,
                    target: peerID,
                    status: route.status ?? "unknown",
                    freshness: route.freshness ?? "",
                    label: route.bestRoute ?? "route"
                )
            )
        }

        for target in snapshot.executionReadiness?.targets ?? [] {
            guard let peerID = clean(target.peerID ?? target.displayName) else { continue }
            let existing = nodes[peerID]
            nodes[peerID] = TopologyNode(
                id: peerID,
                label: clean(target.displayName) ?? existing?.label ?? peerID,
                role: target.role == "local" ? "local" : "worker",
                status: target.status ?? existing?.status ?? "unknown",
                subtitle: "\(target.workerCount ?? 0) worker(s)"
            )
            if peerID != localID && !edges.contains(where: { $0.source == localID && $0.target == peerID }) {
                edges.append(TopologyEdge(source: localID, target: peerID, status: target.status ?? "unknown", label: "execution"))
            }
        }

        for item in snapshot.artifactSync?.items ?? [] {
            guard let sourcePeer = clean(item.sourcePeerID), sourcePeer != localID else { continue }
            let existing = nodes[sourcePeer]
            nodes[sourcePeer] = TopologyNode(
                id: sourcePeer,
                label: existing?.label ?? sourcePeer,
                role: existing?.role == "worker" ? "worker" : "artifact",
                status: item.verificationStatus ?? existing?.status ?? "unknown",
                subtitle: "artifact source"
            )
            edges.append(
                TopologyEdge(
                    source: sourcePeer,
                    target: localID,
                    status: item.verificationStatus ?? "unknown",
                    label: "artifact"
                )
            )
        }

        return TopologyGraph(
            nodes: nodes.values.sorted { lhs, rhs in
                if lhs.id == localID { return true }
                if rhs.id == localID { return false }
                return lhs.label.localizedCaseInsensitiveCompare(rhs.label) == .orderedAscending
            },
            edges: edges
        )
    }

    public static func setupGuideSteps(snapshot: AppStatusSnapshot?, mode: LaunchMode, phoneURL: String) -> [SetupGuideStep] {
        let setupStatus = (snapshot?.setup?.status ?? "").lowercased()
        let routeCount = snapshot?.setup?.routeCount ?? snapshot?.meshQuality?.routeCount ?? 0
        let healthyRoutes = snapshot?.setup?.healthyRouteCount ?? snapshot?.meshQuality?.healthyRoutes ?? 0
        let proofStatus = (snapshot?.setup?.latestProofStatus ?? snapshot?.latestProof?.status ?? "").lowercased()
        let phoneReady = mode == .mesh && phoneURL.hasPrefix("http")
        let strong = setupStatus == "strong"

        return [
            SetupGuideStep(
                id: "start_mesh",
                title: "Start Mesh Mode",
                summary: mode == .mesh ? "This Mac is listening for trusted devices on your LAN." : "Bind OCP to the LAN so your phone and spare laptop can reach it.",
                status: mode == .mesh ? "complete" : "active",
                action: "Start Mesh Mode"
            ),
            SetupGuideStep(
                id: "copy_phone_link",
                title: "Copy Phone Link",
                summary: phoneReady ? "A tokened phone link is ready for the same Wi-Fi." : "Mesh Mode creates the LAN phone link.",
                status: phoneReady ? "complete" : (mode == .mesh ? "active" : "blocked"),
                action: "Copy Phone Link"
            ),
            SetupGuideStep(
                id: "connect_device",
                title: "Connect Device",
                summary: routeCount > 0 ? "\(healthyRoutes)/\(routeCount) peer route(s) are fresh." : "Open the phone or laptop link and connect a nearby OCP node.",
                status: routeCount > 0 ? (healthyRoutes == routeCount ? "complete" : "attention") : (phoneReady ? "active" : "blocked"),
                action: "Open Setup Doctor"
            ),
            SetupGuideStep(
                id: "activate_mesh",
                title: "Activate Mesh",
                summary: proofStatus.isEmpty || proofStatus == "none" ? "Run discovery, repair, helper planning, and proof." : "Latest proof: \(proofStatus.replacingOccurrences(of: "_", with: " ")).",
                status: ["completed"].contains(proofStatus) ? "complete" : (["planned", "queued", "running", "accepted"].contains(proofStatus) ? "active" : (routeCount > 0 ? "active" : "blocked")),
                action: "Activate Mesh"
            ),
            SetupGuideStep(
                id: "verify_strong",
                title: "Verify Strong",
                summary: strong ? "The mesh has proven routes and a completed proof." : "OCP will mark the mesh strong after route proof and whole-mesh proof complete.",
                status: strong ? "complete" : (["failed", "needs_attention", "cancelled"].contains(proofStatus) || setupStatus == "needs_attention" ? "attention" : "blocked"),
                action: "Review Next Fix"
            ),
        ]
    }

    private static func clean(_ value: String?) -> String? {
        let trimmed = (value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
