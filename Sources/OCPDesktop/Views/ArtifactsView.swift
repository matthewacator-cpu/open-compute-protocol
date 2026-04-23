import Charts
import SwiftUI

struct ArtifactsView: View {
    @ObservedObject var model: OCPDesktopModel
    var allowMotion: Bool = true

    var body: some View {
        let sync = model.snapshot?.artifactSync
        let items = sync?.items ?? []

        MissionScroll(allowMotion: allowMotion) {
            PageHeader(
                eyebrow: "Artifacts",
                title: "\(sync?.verifiedCount ?? 0) verified",
                summary: sync?.operatorSummary ?? "Proof artifact sync appears after replication and mirror verification."
            )

            MissionCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Verification Trend").sectionLabel()
                    if model.chartPoints.isEmpty {
                        EmptyState(text: "Artifact verification history will appear after samples are recorded.")
                    } else {
                        Chart(model.chartPoints) { point in
                            LineMark(
                                x: .value("Sample", point.sampledAt),
                                y: .value("Verified artifacts", point.artifactVerifiedCount)
                            )
                            .foregroundStyle(.orange)
                            .lineStyle(.init(lineWidth: 3))
                            BarMark(
                                x: .value("Sample", point.sampledAt),
                                y: .value("Pending approvals", point.pendingApprovals)
                            )
                            .foregroundStyle(.purple.opacity(0.35))
                        }
                        .chartXAxis(.hidden)
                        .frame(height: 180)
                    }
                }
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                MetricCard(title: "Replicated", value: "\(sync?.replicatedCount ?? 0)", detail: "Artifacts copied from peer nodes.", tint: .orange)
                MetricCard(title: "Verified", value: "\(sync?.verifiedCount ?? 0)", detail: "Mirrors with digest verification.", tint: .green)
            }

            ForEach(items) { item in
                MissionCard {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.artifactID ?? "Artifact")
                                .font(.headline)
                            Spacer()
                            StatusPill(text: item.verificationStatus ?? "unknown", status: item.verificationStatus ?? "unknown")
                        }
                        Text(item.digest ?? "")
                            .font(.callout.monospaced())
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .textSelection(.enabled)
                        Text("Source: \(item.sourcePeerID ?? "unknown")")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
