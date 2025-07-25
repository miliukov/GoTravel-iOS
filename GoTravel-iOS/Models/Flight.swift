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
    let origin_airport: String
    let destination: String
    let destination_airport: String
    let departure_at: String // ISO
    let price: Int
    let expires_at: String?
    let airline: String
    let flight_number: String
    let duration: Int
    let duration_to: Int
    let duration_back: Int
    let transfers: Int
    let link: String
    
    var id: UUID {
        UUID()
    }
    
    private enum CodingKeys: String, CodingKey {
        case origin, origin_airport, destination, destination_airport, departure_at, price, expires_at, airline, flight_number, duration, duration_to, duration_back, transfers, link
    }
}
