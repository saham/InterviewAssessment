import Foundation
enum ReportError: LocalizedError {
    case noEntries
    case noReport

    var errorDescription: String? {
        switch self {
        case .noEntries: return AppConstant.Network.noEntries
        case .noReport: return AppConstant.Network.noReport
        }
    }
}
