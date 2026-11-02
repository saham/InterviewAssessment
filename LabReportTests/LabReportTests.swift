import XCTest
import ModelsR4
@testable import LabReport

@MainActor
final class LabReportTests: XCTestCase {
    
    func testLongDate() {
        XCTAssertEqual("2011-03-04T08:30:00+11:00".longDate, "March 4, 2011 08:30:00")
    }
    
    func testShortDate() {
        XCTAssertEqual("2011-03-04T08:30:00+11:00".shortDate, "March 4, 2011")
    }
    
    func testToString() {
        XCTAssertEqual(0.92.toString, "0.92")
        XCTAssertEqual(20.0.toString, "20.0")
    }
    
    func testToDouble() throws {
        let json = #"{"value":0.92,"unit":"x10*9/L"}"#
        let quantity = try JSONDecoder().decode(Quantity.self, from: Data(json.utf8))
        XCTAssertEqual(quantity.toDouble, 0.92)
    }
    
    func testLoadReport() async throws {
        let url = try XCTUnwrap(
            Foundation.Bundle(for: type(of: self)).url(forResource: "data", withExtension: "json")
        )
        let bundle = try JSONDecoder().decode(ModelsR4.Bundle.self, from: Data(contentsOf: url))
        
        let mock = MockNetworkService(bundle: bundle)
        let viewModel = ReportViewModel(urlString: "N/A", networkService: mock)
        
        try await viewModel.loadReport()
        
        XCTAssertEqual(viewModel.reportName, "Complete Blood Count")
        XCTAssertEqual(viewModel.testPerformer, "Acme Laboratory, Inc")
        XCTAssertEqual(viewModel.detailDate, "March 4, 2011 08:30:00")
        XCTAssertEqual(viewModel.observations.count, 17)
        XCTAssertEqual(viewModel.observations.first?.testName, "Haemoglobin")
    }
    
    func testStatus() {
        func model(_ value: Double?, low: Double?, high: Double?) -> VitalObservationModel {
            VitalObservationModel(testName: nil, value: value, unit: nil, rangeLow: low, rangeHigh: high)
        }

        XCTAssertEqual(model(5, low: 1, high: 10).status, .normal)
        XCTAssertEqual(model(0, low: 1, high: 10).status, .low)
        XCTAssertEqual(model(11, low: 1, high: 10).status, .high)
        XCTAssertEqual(model(nil, low: 1, high: 10).status, .unknown)
        XCTAssertEqual(model(5, low: nil, high: nil).status, .unknown)
        XCTAssertEqual(model(5, low: nil, high: 10).status, .normal)
        XCTAssertEqual(model(1, low: 1, high: 10).status, .normal)
        XCTAssertEqual(model(10, low: 1, high: 10).status, .normal)
    }
    
    func testLoadReportFailure() async {
        let mock = MockNetworkService(error: URLError(.notConnectedToInternet))
        let viewModel = ReportViewModel(urlString: "N/A", networkService: mock)
        
        do {
            try await viewModel.loadReport()
            XCTFail("Expected an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }
}

final class MockNetworkService: NetworkService {
    var bundle: ModelsR4.Bundle?
    var error: Error?
    init(bundle: ModelsR4.Bundle? = nil, error: Error? = nil) {
        self.bundle = bundle
        self.error = error
        super.init()
    }
    override func fetchDiagnosticReport(from urlString: String) async throws -> ModelsR4.Bundle {
        if let error { throw error }
        guard let bundle else { throw URLError(.badServerResponse) }
        return bundle
    }
}
