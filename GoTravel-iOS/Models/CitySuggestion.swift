import Foundation

struct CitySuggestion: Decodable, Identifiable {
    var id: String { code }
    let name: String
    let code: String
    let country_name: String
}

