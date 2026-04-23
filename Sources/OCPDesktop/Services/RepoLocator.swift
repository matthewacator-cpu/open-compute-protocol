import Foundation

enum RepoLocator {
    static func defaultRepoRoot() -> URL {
        let env = ProcessInfo.processInfo.environment["OCP_REPO_ROOT"] ?? ""
        if !env.isEmpty {
            return URL(fileURLWithPath: env, isDirectory: true)
        }
        if let resourceURL = Bundle.main.resourceURL {
            let bundled = resourceURL.appendingPathComponent("open-compute-protocol", isDirectory: true)
            if FileManager.default.fileExists(atPath: bundled.appendingPathComponent("server.py").path) {
                return bundled
            }
        }
        return URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
    }
}
