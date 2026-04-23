import Charts
import SwiftUI
import OCPDesktopCore

enum MissionTheme {
    static let ink = Color(red: 0.035, green: 0.055, blue: 0.080)
    static let deepSea = Color(red: 0.055, green: 0.125, blue: 0.145)
    static let copper = Color(red: 0.96, green: 0.58, blue: 0.24)
    static let signal = Color(red: 0.36, green: 0.86, blue: 0.96)
    static let mint = Color(red: 0.40, green: 0.92, blue: 0.58)
    static let ember = Color(red: 1.00, green: 0.36, blue: 0.30)
}

struct MissionScroll<Content: View>: View {
    var allowMotion: Bool = true
    @ViewBuilder var content: () -> Content
    @State private var drift = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                content()
            }
            .padding(26)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(MissionBackground(allowMotion: allowMotion))
        .onAppear {
            guard allowMotion else { return }
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                drift = true
            }
        }
    }
}

struct MissionCard<Content: View>: View {
    var tint: Color = MissionTheme.signal
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(.regularMaterial)
                    LinearGradient(
                        colors: [tint.opacity(0.20), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [tint.opacity(0.32), .white.opacity(0.10), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: tint.opacity(0.10), radius: 22, x: 0, y: 12)
    }
}

struct MissionBackground: View {
    var allowMotion: Bool = true
    @State private var phase = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [MissionTheme.ink, MissionTheme.deepSea, Color(nsColor: .windowBackgroundColor)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [MissionTheme.signal.opacity(0.30), .clear],
                center: .topTrailing,
                startRadius: 80,
                endRadius: phase && allowMotion ? 640 : 560
            )
            .scaleEffect(phase && allowMotion ? 1.08 : 1.0, anchor: .topTrailing)
            RadialGradient(
                colors: [MissionTheme.copper.opacity(0.18), .clear],
                center: .bottomLeading,
                startRadius: 80,
                endRadius: phase && allowMotion ? 590 : 520
            )
            .scaleEffect(phase && allowMotion ? 1.05 : 1.0, anchor: .bottomLeading)
            MeshPattern()
                .opacity(0.16)
        }
        .ignoresSafeArea()
        .onAppear {
            guard allowMotion else { return }
            withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                phase = true
            }
        }
    }
}

struct MeshPattern: View {
    var body: some View {
        Canvas { context, size in
            var path = Path()
            let spacing: CGFloat = 42
            var x: CGFloat = 0
            while x <= size.width {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x - size.height * 0.45, y: size.height))
                x += spacing
            }
            var y: CGFloat = 0
            while y <= size.height {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y + size.width * 0.16))
                y += spacing
            }
            context.stroke(path, with: .color(.white.opacity(0.20)), lineWidth: 0.6)
        }
    }
}

struct PageHeader: View {
    var eyebrow: String
    var title: String
    var summary: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eyebrow.uppercased())
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(MissionTheme.signal)
                .tracking(2.2)
            Text(title)
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.primary, MissionTheme.signal.opacity(0.82)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Text(summary)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 820, alignment: .leading)
        }
    }
}

struct MetricCard: View {
    var title: String
    var value: String
    var detail: String
    var tint: Color = .accentColor

    var body: some View {
        MissionCard(tint: tint) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title).sectionLabel()
                Text(value)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                Text(detail)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
                GeometryReader { proxy in
                    Capsule()
                        .fill(tint.opacity(0.16))
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(tint.gradient)
                                .frame(width: max(18, proxy.size.width * 0.62))
                        }
                }
                .frame(height: 5)
            }
        }
    }
}

struct MeshGauge: View {
    var score: Int
    var allowMotion: Bool = true
    @State private var animatedScore: Double = 0
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(scoreColor.opacity(pulse && allowMotion ? 0.13 : 0.07))
                .blur(radius: pulse && allowMotion ? 20 : 12)
            Circle()
                .stroke(.secondary.opacity(0.15), lineWidth: 18)
            Circle()
                .trim(from: 0, to: CGFloat(min(100, max(0, animatedScore))) / 100)
                .stroke(scoreColor.gradient, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .shadow(color: scoreColor.opacity(0.50), radius: 16)
            ForEach(0..<28, id: \.self) { index in
                Capsule()
                    .fill(index % 4 == 0 ? scoreColor.opacity(0.75) : .secondary.opacity(0.20))
                    .frame(width: 2, height: index % 4 == 0 ? 10 : 6)
                    .offset(y: -112)
                    .rotationEffect(.degrees(Double(index) * (360 / 28)))
            }
            VStack(spacing: 4) {
                Text("\(Int(round(animatedScore)))")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                Text("mesh score")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 220, height: 220)
        .accessibilityLabel("Mesh score \(score)")
        .onAppear {
            animatedScore = allowMotion ? 0 : Double(score)
            updateAnimation()
        }
        .onChange(of: score) { _ in
            updateAnimation()
        }
    }

    private func updateAnimation() {
        if allowMotion {
            withAnimation(.spring(response: 0.9, dampingFraction: 0.82)) {
                animatedScore = Double(score)
            }
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                pulse = true
            }
        } else {
            animatedScore = Double(score)
            pulse = false
        }
    }

    private var scoreColor: Color {
        if score >= 80 { return MissionTheme.mint }
        if score >= 50 { return MissionTheme.copper }
        return MissionTheme.ember
    }
}

struct StatusPill: View {
    var text: String
    var status: String

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.16), in: Capsule())
            .foregroundStyle(color)
            .overlay(Capsule().stroke(color.opacity(0.25), lineWidth: 1))
    }

    private var color: Color {
        switch status.lowercased() {
        case "ok", "ready", "strong", "completed", "reachable", "fresh", "verified", "active":
            return MissionTheme.mint
        case "running", "proving", "queued", "planned", "aging":
            return MissionTheme.signal
        case "warning", "needs_attention", "stale", "attention":
            return MissionTheme.copper
        case "failed", "unreachable", "cancelled":
            return MissionTheme.ember
        default:
            return .secondary
        }
    }
}

struct TimelineList: View {
    var events: [AppStatusSnapshot.TimelineEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if events.isEmpty {
                EmptyState(text: "No setup events yet. Press Activate Mesh to start the proof timeline.")
            } else {
                ForEach(events) { event in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: icon(for: event.kind))
                            .font(.title3)
                            .foregroundStyle(color(for: event.status ?? "info"))
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(event.kind.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.headline)
                            Text(event.summary ?? "OCP recorded a setup event.")
                                .foregroundStyle(.secondary)
                            if let peer = event.peerID, !peer.isEmpty {
                                Text(peer)
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }
            }
        }
    }

    private func icon(for kind: String) -> String {
        if kind.contains("route") { return "point.3.connected.trianglepath.dotted" }
        if kind.contains("worker") || kind.contains("helper") { return "cpu" }
        if kind.contains("artifact") { return "shippingbox" }
        if kind.contains("proof") { return "checkmark.seal" }
        if kind.contains("fix") { return "wrench.and.screwdriver" }
        return "circle.hexagongrid"
    }

    private func color(for status: String) -> Color {
        switch status.lowercased() {
        case "ok", "ready", "completed": MissionTheme.mint
        case "failed": MissionTheme.ember
        case "warning", "needs_attention": MissionTheme.copper
        default: MissionTheme.signal
        }
    }
}

struct EmptyState: View {
    var text: String

    var body: some View {
        Text(text)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
    }
}

struct SetupGuideCard: View {
    var steps: [SetupGuideStep]
    var allowMotion: Bool
    var startMesh: () -> Void
    var copyPhoneLink: () -> Void
    var activateMesh: () -> Void
    var openSetup: () -> Void
    @State private var reveal = false

    var body: some View {
        MissionCard(tint: MissionTheme.signal) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Guided Path").sectionLabel()
                        Text("From this Mac to a proven personal mesh.")
                            .font(.title3.weight(.bold))
                    }
                    Spacer()
                    StatusPill(text: "\(steps.filter { $0.status == "complete" }.count)/\(steps.count)", status: steps.allSatisfy { $0.status == "complete" } ? "strong" : "running")
                }

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            StatusRing(status: step.status, index: index + 1, allowMotion: allowMotion)
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(step.title)
                                        .font(.headline)
                                    Spacer()
                                    Button(step.action) {
                                        perform(step)
                                    }
                                    .buttonStyle(.bordered)
                                    .disabled(step.status == "blocked" || step.status == "complete")
                                }
                                Text(step.summary)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .opacity(reveal || !allowMotion ? 1 : 0)
                        .offset(y: reveal || !allowMotion ? 0 : 10)
                        .animation(.easeOut(duration: 0.35).delay(Double(index) * 0.06), value: reveal)
                    }
                }
            }
        }
        .onAppear { reveal = true }
    }

    private func perform(_ step: SetupGuideStep) {
        switch step.id {
        case "start_mesh":
            startMesh()
        case "copy_phone_link":
            copyPhoneLink()
        case "activate_mesh":
            activateMesh()
        default:
            openSetup()
        }
    }
}

struct StatusRing: View {
    var status: String
    var index: Int
    var allowMotion: Bool
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.18), lineWidth: 3)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color.gradient, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(status == "complete" ? "✓" : "\(index)")
                .font(.caption.bold())
                .foregroundStyle(color)
        }
        .frame(width: 30, height: 30)
        .scaleEffect(pulse && allowMotion && status == "active" ? 1.08 : 1.0)
        .onAppear {
            guard allowMotion, status == "active" else { return }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private var progress: CGFloat {
        switch status {
        case "complete": return 1
        case "active": return 0.66
        case "attention": return 0.50
        default: return 0.18
        }
    }

    private var color: Color {
        switch status {
        case "complete": return MissionTheme.mint
        case "active": return MissionTheme.signal
        case "attention": return MissionTheme.copper
        default: return .secondary
        }
    }
}

struct TopologyGraphView: View {
    var graph: TopologyGraph
    var compact: Bool = false
    var allowMotion: Bool = true
    @State private var phase: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Route Topology").sectionLabel()
                Spacer()
                RouteEdgeLegend()
            }
            if graph.nodes.count <= 1 {
                EmptyState(text: "Topology appears after OCP sees this Mac and at least one peer route or worker.")
            } else {
                Canvas { context, size in
                    let layout = layout(in: size)
                    drawEdges(context: &context, layout: layout)
                    drawNodes(context: &context, layout: layout)
                }
                .frame(height: compact ? 220 : 360)
                .background(.black.opacity(0.10), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .onAppear {
                    guard allowMotion else { return }
                    withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
            }
        }
    }

    private func layout(in size: CGSize) -> [String: CGPoint] {
        guard let local = graph.nodes.first else { return [:] }
        let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        var result = [local.id: center]
        let peers = graph.nodes.dropFirst()
        let radius = min(size.width, size.height) * (compact ? 0.32 : 0.36)
        for (index, node) in peers.enumerated() {
            let angle = (Double(index) / Double(max(1, peers.count))) * Double.pi * 2 - Double.pi / 2
            result[node.id] = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
        }
        return result
    }

    private func drawEdges(context: inout GraphicsContext, layout: [String: CGPoint]) {
        for edge in graph.edges {
            guard let start = layout[edge.source], let end = layout[edge.target] else { continue }
            var path = Path()
            path.move(to: start)
            path.addLine(to: end)
            let color = edgeColor(edge.status, edge.freshness)
            context.stroke(path, with: .color(color.opacity(0.58)), style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: edge.freshness == "stale" ? [5, 6] : []))

            if allowMotion && ["reachable", "ready", "verified", "active"].contains(edge.status.lowercased()) {
                let progress = (phase + CGFloat(abs(edge.id.hashValue % 25)) / 25).truncatingRemainder(dividingBy: 1)
                let pulsePoint = CGPoint(x: start.x + (end.x - start.x) * progress, y: start.y + (end.y - start.y) * progress)
                context.fill(Path(ellipseIn: CGRect(x: pulsePoint.x - 4, y: pulsePoint.y - 4, width: 8, height: 8)), with: .color(color.opacity(0.85)))
            }
        }
    }

    private func drawNodes(context: inout GraphicsContext, layout: [String: CGPoint]) {
        for node in graph.nodes {
            guard let point = layout[node.id] else { continue }
            let isLocal = node.role == "local"
            let radius: CGFloat = isLocal ? 30 : 23
            let color = nodeColor(node.status, node.role)
            context.fill(Path(ellipseIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)), with: .color(color.opacity(isLocal ? 0.34 : 0.24)))
            context.stroke(Path(ellipseIn: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)), with: .color(color.opacity(0.88)), lineWidth: isLocal ? 3 : 2)
            context.draw(Text(node.label).font(.caption.bold()).foregroundColor(.primary), at: CGPoint(x: point.x, y: point.y + radius + 14), anchor: .top)
            if !compact {
                context.draw(Text(node.subtitle).font(.caption2).foregroundColor(.secondary), at: CGPoint(x: point.x, y: point.y + radius + 30), anchor: .top)
            }
        }
    }

    private func edgeColor(_ status: String, _ freshness: String) -> Color {
        if freshness == "stale" { return MissionTheme.copper }
        switch status.lowercased() {
        case "reachable", "ready", "verified", "active": return MissionTheme.mint
        case "failed", "unreachable", "cancelled": return MissionTheme.ember
        case "needs_attention", "stale", "attention": return MissionTheme.copper
        default: return MissionTheme.signal
        }
    }

    private func nodeColor(_ status: String, _ role: String) -> Color {
        if role == "local" { return MissionTheme.signal }
        switch status.lowercased() {
        case "reachable", "ready", "verified", "strong", "active": return MissionTheme.mint
        case "failed", "unreachable", "cancelled": return MissionTheme.ember
        case "needs_attention", "stale", "attention": return MissionTheme.copper
        default: return MissionTheme.signal
        }
    }
}

struct RouteEdgeLegend: View {
    var body: some View {
        HStack(spacing: 8) {
            legend("fresh", MissionTheme.mint)
            legend("stale", MissionTheme.copper)
            legend("down", MissionTheme.ember)
        }
        .font(.caption2.bold())
        .foregroundStyle(.secondary)
    }

    private func legend(_ label: String, _ color: Color) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(label)
        }
    }
}

struct MeshScoreChart: View {
    var points: [MissionControlChartPoint]

    var body: some View {
        if points.isEmpty {
            EmptyState(text: "History will appear after the app records a few status samples.")
        } else {
            Chart(points) { point in
                AreaMark(
                    x: .value("Sample", point.sampledAt),
                    y: .value("Mesh score", point.meshScore)
                )
                .foregroundStyle(MissionTheme.signal.opacity(0.18))
                LineMark(
                    x: .value("Sample", point.sampledAt),
                    y: .value("Mesh score", point.meshScore)
                )
                .foregroundStyle(MissionTheme.signal)
                .lineStyle(.init(lineWidth: 3))
                PointMark(
                    x: .value("Sample", point.sampledAt),
                    y: .value("Mesh score", point.meshScore)
                )
                .foregroundStyle(MissionTheme.signal.opacity(0.72))
            }
            .chartYScale(domain: 0...100)
            .chartXAxis(.hidden)
            .chartPlotStyle { plot in
                plot
                    .background(.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .frame(height: 180)
        }
    }
}

struct RouteHealthChart: View {
    var healthy: Int
    var total: Int

    var body: some View {
        Chart {
            BarMark(x: .value("State", "Healthy"), y: .value("Routes", healthy))
                .foregroundStyle(MissionTheme.mint)
            BarMark(x: .value("State", "Needs work"), y: .value("Routes", max(0, total - healthy)))
                .foregroundStyle(MissionTheme.copper)
        }
        .chartPlotStyle { plot in
            plot
                .background(.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .frame(height: 150)
    }
}

extension Text {
    func sectionLabel() -> some View {
        self
            .font(.system(size: 11, weight: .bold, design: .monospaced))
            .foregroundStyle(MissionTheme.signal.opacity(0.85))
            .tracking(1.6)
            .textCase(.uppercase)
    }
}
