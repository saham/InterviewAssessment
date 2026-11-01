import Foundation
import ModelsR4

@MainActor
final class ReportViewModel {
    private let networkService: NetworkService
    private let urlString: String
    var reportName = "Lab Report"
    var testPerformer = "Unknown"
    var dateTime = ""
    var observations: [VitalObservationModel] = []
    var summaryDate: String { dateTime.shortDate }
    var detailDate: String { dateTime.longDate }

    init(urlString: String, networkService: NetworkService) {
        self.urlString = urlString
        self.networkService = networkService
    }

    func loadReport() async throws {
        let bundle = try await networkService.fetchDiagnosticReport(from: urlString)
        guard let entries = bundle.entry else { throw ReportError.noEntries }

        var report: DiagnosticReport?
        var observationsByReference: [String: Observation] = [:]

        for entry in entries {
            switch entry.resource {
            case .diagnosticReport(let value):
                report = value
            case .observation(let value):
                if let id = value.id?.value?.string {
                    observationsByReference["Observation/\(id)"] = value
                }
            default:
                break
            }
        }

        guard let report else { throw ReportError.noReport }

        reportName = report.code.text?.value?.string ?? "Lab Report"
        testPerformer = report.performer?.first?.display?.value?.string ?? "Unknown"

        var effective: String?
        if case .dateTime(let value)? = report.effective {
            effective = value.value?.description
        }
        dateTime = effective ?? report.issued?.value?.description ?? ""
        observations = (report.result ?? []).compactMap { reference in
            guard let key = reference.reference?.value?.string,
                  let observation = observationsByReference[key] else { return nil }

            var quantity: Quantity?
            if case .quantity(let value)? = observation.value {
                quantity = value
            }
            let range = observation.referenceRange?.first

            return VitalObservationModel(
                testName: observation.code.text?.value?.string,
                value: quantity?.toDouble,
                unit: quantity?.unit?.value?.string,
                rangeLow: range?.low?.toDouble,
                rangeHigh: range?.high?.toDouble
            )
        }
    }
}
