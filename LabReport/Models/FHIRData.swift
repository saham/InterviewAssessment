struct FHIRData: Decodable {
    let entry: [Entry]?
}

struct Entry: Decodable {
    let resource: Resource?
}

struct Resource: Decodable {
    let resourceType: String?
    let id: String?
    let code: CodeableConcept?
    let effectiveDateTime: String?
    let issued: String?
    let performer: [Reference]?
    let result: [Reference]?
    let valueQuantity: Quantity?
    let referenceRange: [ReferenceRange]?
}


struct CodeableConcept: Decodable {
    let text: String?
}

struct Reference: Decodable {
    let reference: String?
    let display: String?
}

struct Quantity: Decodable {
    let value: Double?
    let unit: String?
}

struct ReferenceRange: Decodable {
    let low: Quantity?
    let high: Quantity?
}

