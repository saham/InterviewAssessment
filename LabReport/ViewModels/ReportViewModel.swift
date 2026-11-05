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
        
        var report: Resource?
        var observationsByID: [String: Resource] = [:]
        
        for entry in entries {
            guard let resource = entry.resource,
                  let resourceType = resource.resourceType else { continue }
            
            switch resourceType {
            case AppConstant.FHIR.diagnosticReport:
                report = resource //One report per bundle
            case AppConstant.FHIR.observation:
                if let id = resource.id {
                    observationsByID["Observation/\(id)"] = resource
                }
            default: break
            }
        }
        
        guard let report else { throw ReportError.noReport }
        
        reportName = report.code?.text ?? "Lab Report"
        //The first performer is used
        testPerformer = report.performer?.first?.display ?? "Unknown"
        dateTime = report.effectiveDateTime ?? report.issued ?? ""
        
        observations = (report.result ?? []).compactMap {
            guard let key = $0.reference,
                  let resource = observationsByID[key] else { return nil }
            return VitalObservationModel(
                testName: resource.code?.text,
                value: resource.valueQuantity?.value,
                unit: resource.valueQuantity?.unit,
                rangeLow: resource.referenceRange?.first?.low?.value,
                rangeHigh: resource.referenceRange?.first?.high?.value
            )
        }
    }
}
