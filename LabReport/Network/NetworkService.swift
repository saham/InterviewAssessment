import Foundation

class NetworkService {
    func fetchDiagnosticReport(from urlString: String) async throws -> FHIRData {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(FHIRData.self, from: data)
    }
}
