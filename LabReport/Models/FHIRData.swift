struct FHIRData: Decodable {
    let resourceType: String?
    let id: String?
    let type: String?
    let entry: [Entry]?
}

struct Entry: Decodable {
    let fullUrl: String?
    let resource: Resource?
}

struct Resource: Decodable {
    let resourceType: String?
    let id: String?
    let meta: Meta?
    let text: Text?
    let identifier: [Identifier]?
    let status: String?
    let category: [CodeableConcept]?
    let code: CodeableConcept?
    let subject: Reference?
    let encounter: Reference?
    let effectiveDateTime: String?
    let issued: String?
    let performer: [Reference]?
    let result: [Reference]?
    let presentedForm: [PresentedForm]?
    let valueQuantity: Quantity?
    let referenceRange: [ReferenceRange]?
    let interpretation: [CodeableConcept]?
}

struct Meta: Decodable {
    let tag: [Coding]?
}

struct CodeableConcept: Decodable {
    let coding: [Coding]?
    let text: String?
}

struct Text: Decodable {
    let status: String?
    let div: String?
}

struct Identifier: Decodable {
    let system: String?
    let value: String?
}

struct Coding: Decodable {
    let system: String?
    let code: String?
    let display: String?
}

struct Reference: Decodable {
    let reference: String?
    let display: String?
}

struct PresentedForm: Decodable {
    let contentType: String?
    let language: String?
    let data: String?
    let title: String?
}

struct Quantity: Decodable {
    let value: Double?
    let unit: String?
    let system: String?
    let code: String?
}

struct ReferenceRange: Decodable {
    let low: Quantity?
    let high: Quantity?
}

