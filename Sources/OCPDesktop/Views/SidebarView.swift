import SwiftUI

struct SidebarView: View {
    @Binding var selection: DesktopSection?

    var body: some View {
        List(selection: $selection) {
            Section("Mission Control") {
                ForEach(DesktopSection.allCases) { section in
                    HStack(spacing: 10) {
                        Image(systemName: section.systemImage)
                            .foregroundStyle(section == selection ? MissionTheme.signal : .secondary)
                            .frame(width: 16)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(section.title)
                                .lineLimit(1)
                                .fontWeight(section == selection ? .semibold : .regular)
                            Text(section.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .tag(section)
                }
            }
        }
        .listStyle(.sidebar)
    }
}
