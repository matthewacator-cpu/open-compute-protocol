import Charts
import SwiftUI
import OCPDesktopCore

struct OverviewView: View {
    @ObservedObject var model: OCPDesktopModel
    @Binding var showGuide: Bool
    var allowMotion: Bool
    var openSetup: () -> Void

    var body: some View {
        MissionScroll(allowMotion: allowMotion) {
            PageHeader(
                eyebrow: "OCP Mission Control",
                title: "Personal compute fabric",
                summary: model.setupSummary
            )

            if showGuide {
                SetupGuideCard(
                    steps: model.setupGuideSteps,
                    allowMotion: allowMotion,
                    startMesh: { model.startMesh() },
                    copyPhoneLink: { model.copyPhoneLink() },
                    activateMesh: { model.activateMesh() },
                    openSetup: openSetup
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            HStack(alignment: .top, spacing: 18) {
                MissionCard(tint: MissionTheme.signal) {
                    HStack(alignment: .center, spacing: 24) {
                        MeshGauge(score: model.meshScore, allowMotion: allowMotion)
                        VStack(alignment: .leading, spacing: 12) {
                            StatusPill(text: model.setupLabel, status: model.snapshot?.setup?.status ?? "ready")
                            Text(model.nextFix)
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .lineLimit(3)
                            Text(model.statusText)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button("Activate Mesh") { model.activateMesh() }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(model.isActivating)
                                Button("Copy Phone Link") { model.copyPhoneLink() }
                                    .buttonStyle(.bordered)
                                Button("Open App") { model.openApp() }
                                    .buttonStyle(.bordered)
                            }
                        }
                    }
                }

                MissionCard(tint: MissionTheme.mint) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Mesh Score History").sectionLabel()
                            Spacer()
                            Text("\(model.history.count) samples")
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                        MeshScoreChart(points: model.chartPoints)
                    }
                }
            }

            MissionCard(tint: MissionTheme.signal) {
                TopologyGraphView(graph: model.topology, compact: true, allowMotion: allowMotion)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                MetricCard(
                    title: "Routes",
                    value: "\(model.snapshot?.meshQuality?.healthyRoutes ?? 0)/\(model.snapshot?.meshQuality?.routeCount ?? 0)",
                    detail: model.routeSummary,
                    tint: .green
                )
                MetricCard(
                    title: "Execution",
                    value: "\(model.snapshot?.executionReadiness?.targets?.filter { $0.status == "ready" }.count ?? 0) ready",
                    detail: model.executionSummary,
                    tint: .cyan
                )
                MetricCard(
                    title: "Artifacts",
                    value: "\(model.snapshot?.artifactSync?.verifiedCount ?? 0) verified",
                    detail: model.artifactSummary,
                    tint: .orange
                )
            }

            MissionCard(tint: MissionTheme.copper) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Next Actions").sectionLabel()
                    ForEach(Array((model.snapshot?.nextActions ?? ["Start OCP and press Activate Mesh."]).enumerated()), id: \.offset) { _, action in
                        Label(action, systemImage: "arrow.right.circle")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
