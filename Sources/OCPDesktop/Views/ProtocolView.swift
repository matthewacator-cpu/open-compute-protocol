import SwiftUI

struct ProtocolView: View {
    @ObservedObject var model: OCPDesktopModel
    var allowMotion: Bool = true

    var body: some View {
        let protocolStatus = model.snapshot?.protocolStatus

        MissionScroll(allowMotion: allowMotion) {
            PageHeader(
                eyebrow: "Protocol",
                title: "OCP \(protocolStatus?.release ?? "0.1")",
                summary: model.protocolSummary
            )

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                MetricCard(title: "Wire", value: protocolStatus?.version ?? "sovereign-mesh/v1", detail: "Current protocol version.", tint: .cyan)
                MetricCard(title: "Schemas", value: protocolStatus?.schemaVersion ?? "pending", detail: "Live schema registry version.", tint: .green)
                MetricCard(title: "Contract", value: protocolStatus?.contractURL ?? "/mesh/contract", detail: "HTTP contract route.", tint: .orange)
            }

            MissionCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Live Links").sectionLabel()
                    Link("Open Contract", destination: URL(string: model.serverBaseURL + "/mesh/contract")!)
                    Link("Open Manifest", destination: URL(string: model.serverBaseURL + "/mesh/manifest")!)
                    Link("Open App Status", destination: URL(string: model.serverBaseURL + "/mesh/app/status")!)
                    Link("Open App History", destination: URL(string: model.serverBaseURL + "/mesh/app/history")!)
                }
            }
        }
    }
}
