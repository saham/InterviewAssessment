struct VitalObservationModel {
    let testName: String?
    let value: Double?
    let unit: String?
    let rangeLow: Double?
    let rangeHigh: Double?
}

enum ResultStatus {
    case normal
    case low
    case high
    case unknown
}

extension VitalObservationModel {
    var status: ResultStatus {
        guard let value else { return .unknown }
        if let rangeLow, value < rangeLow { return .low }
        if let rangeHigh, value > rangeHigh { return .high }
        return (rangeLow == nil && rangeHigh == nil) ? .unknown : .normal
    }
}
