import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: OCPDesktopModel
    var allowMotion: Bool = true
    @AppStorage("ocp.desktop.showGuide") private var showGuide = true
    @AppStorage("ocp.desktop.prefersReducedMissionMotion") private var prefersReducedMissionMotion = false

    var body: some View {
        MissionScroll(allowMotion: allowMotion) {
            PageHeader(
                eyebrow: "Settings",
                title: "Node profile",
                summary: "These settings feed the Python OCP server launched by the native Mac app."
            )

            MissionCard {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Profile").sectionLabel()
                    HStack(spacing: 12) {
                        labeledField("Display", text: $model.config.displayName)
                        labeledField("Node ID", text: $model.config.nodeID)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Port").sectionLabel()
                            TextField("Port", value: $model.config.port, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 110)
                        }
                    }
                    HStack(spacing: 12) {
                        labeledField("Device", text: $model.config.deviceClass)
                        labeledField("Form", text: $model.config.formFactor)
                    }
                    Button("Save Settings") { model.saveConfig() }
                        .buttonStyle(.borderedProminent)
                }
            }

            MissionCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Local State").sectionLabel()
                    pathRow("Config", model.paths.configPath.path)
                    pathRow("Database", model.paths.databasePath.path)
                    pathRow("Identity", model.paths.identityDirectory.path)
                    pathRow("Workspace", model.paths.workspaceDirectory.path)
                    pathRow("Repo", model.repoRoot.path)
                }
            }

            MissionCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Links").sectionLabel()
                    Text("App: \(model.appURL)")
                        .textSelection(.enabled)
                    Text("Phone: \(model.phoneURL)")
                        .textSelection(.enabled)
                    HStack {
                        Button("Open App") { model.openApp() }
                        Button("Copy Phone Link") { model.copyPhoneLink() }
                    }
                }
            }

            MissionCard(tint: MissionTheme.signal) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Experience").sectionLabel()
                    Toggle("Show guided path in Overview", isOn: $showGuide)
                    Toggle("Reduce Mission Control motion", isOn: $prefersReducedMissionMotion)
                    Text("The app also respects the system Reduce Motion accessibility setting.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func labeledField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).sectionLabel()
            TextField(label, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    private func pathRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.headline)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(.callout.monospaced())
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
        }
    }
}
