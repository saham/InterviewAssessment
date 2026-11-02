import Foundation
import ModelsR4

class NetworkService {
    func fetchDiagnosticReport(from urlString: String) async throws -> ModelsR4.Bundle {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(ModelsR4.Bundle.self, from: data)
    }
}
