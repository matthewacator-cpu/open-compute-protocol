import Foundation
import OCPDesktopCore

struct OCPServerClient {
    var baseURL: String
    var operatorToken: String

    func fetchStatus() async throws -> AppStatusSnapshot {
        try await request(path: "/mesh/app/status", method: "GET", body: nil)
    }

    func fetchHistory(limit: Int = 240) async throws -> AppStatusHistory {
        try await request(path: "/mesh/app/history?limit=\(limit)", method: "GET", body: nil)
    }

    func recordHistorySample(source: String = "swift-desktop") async throws -> AppHistorySampleResponse {
        try await request(path: "/mesh/app/history/sample", method: "POST", body: ["source": source])
    }

    func activateMesh() async throws {
        let _: AppStatusSnapshotEnvelope = try await request(
            path: "/mesh/autonomy/activate",
            method: "POST",
            body: [
                "mode": "assisted",
                "limit": 24,
                "run_proof": true,
                "repair": true,
                "actor_agent_id": "ocp-swift-desktop"
            ]
        )
    }

    private func request<T: Decodable>(path: String, method: String, body: [String: Any]?) async throws -> T {
        guard let url = URL(string: baseURL + path) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if !operatorToken.isEmpty {
            request.setValue(operatorToken, forHTTPHeaderField: "X-OCP-Operator-Token")
        }
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

private struct AppStatusSnapshotEnvelope: Decodable {}
