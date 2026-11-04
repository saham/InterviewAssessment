import Foundation
import ModelsR4

@MainActor
final class ReportViewModel {
    private let networkService: NetworkService
    private let urlString: String
    private var dateTime = ""
    private(set) var reportName = "Lab Report"
    private(set) var testPerformer = "Unknown"
    private(set) var observations: [VitalObservationModel] = []
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
        var observationsByID: [String: Observation] = [:]
        
        for entry in entries {
            switch entry.resource {
            case .diagnosticReport(let r):
                report = r // One report per bundle
            case .observation(let o):
                if let id = o.id?.value?.string {
                    observationsByID["\(AppConstant.FHIR.observation)/\(id)"] = o
                }
            default:
                break
            }
        }
        
        guard let report else { throw ReportError.noReport }
        
        reportName = report.code.text?.value?.string ?? "Lab Report"
        
        // Only first test performer
        testPerformer = report.performer?.first?.display?.value?.string ?? "Unknown"
        
        var effective: String?
        switch report.effective {
        case .dateTime(let value)?:
            effective = value.value?.description
        default:
            break
        }
        dateTime = effective ?? report.issued?.value?.description ?? ""
        observations = (report.result ?? []).compactMap {
            guard let key = $0.reference?.value?.string,
                  let observation = observationsByID[key] else { return nil }
            
            var quantity: Quantity?
            switch observation.value {
            case .quantity(let q)?:
                quantity = q
            default:
                break
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
