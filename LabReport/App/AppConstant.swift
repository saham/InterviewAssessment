enum AppConstant {
    enum Titles {
        static let labTitle = "Lab and Diagnostics"
        static let resultTitle = "Results for blood, urine, and general lab."
        static let reportTitle = "Report Name"
        static let testPerformer = "Test Performer"
        static let resultDateAndTime = "Result Date and Time"
    }
    
    enum FHIR {
        static let diagnosticReport = "DiagnosticReport"
        static let observation = "Observation"
    }
    
    enum CellIdentifiers {
        static let observationCell = "ObservationCell"
    }
    
    enum Network {
        static let urlString = "https://build.fhir.org/diagnosticreport-example.json"
        static let noEntries = "The response contains no data."
        static let noReport = "No diagnostic report was found in the response."
    }
}
