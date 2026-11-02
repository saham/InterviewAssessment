import UIKit

extension ResultStatus {
    var color: UIColor {
        switch self {
        case .normal: return .systemGreen
        case .low: return .systemOrange
        case .high: return .systemRed
        case .unknown: return .secondaryLabel
        }
    }
}
