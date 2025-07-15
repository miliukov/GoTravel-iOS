import Foundation

struct Flight: Identifiable, Codable {
    var id = UUID()
    let from: String
    let to: String
    let date: Date
    let duration: Int
    let price: Int
}

struct FlightApiResponce: Codable {
    let success: Bool
    let data: [PriceData]
}

struct PriceData: Identifiable, Codable {
    let origin: String
    let destination: String
    let departure_at: String // ISO
    let price: Int
    let expires_at: String?
    
    var id: UUID {
        UUID()
    }
    
    private enum CodingKeys: String, CodingKey {
        case origin, destination, departure_at, price, expires_at
    }
}
