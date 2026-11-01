import Foundation
import ModelsR4

extension Quantity {
    var toDouble: Double? {
        guard let decimal = value?.value?.decimal else { return nil }
        let raw = NSDecimalNumber(decimal: decimal).doubleValue
        return (raw * 1_000_000).rounded() / 1_000_000
    }
}
