import Foundation
import SwiftUI

class FlightSearchViewModel: ObservableObject {
    @Published var origin = "MOW"
    @Published var destination = "LON"
    @Published var month = "2025-11" // YYYY-MM
    @Published var isLoading = false
    @Published var flights = [PriceData]()
    @Published var selectedDate = Date()
    @Published var selectedTransport: TransportType = .any
    @Published var citySuggestionsOrigin: [CitySuggestion] = []
    @Published var citySuggestionsDestination: [CitySuggestion] = []
    
    private var service = APIService()
    
    func search() {
        guard !origin.isEmpty, !destination.isEmpty, !month.isEmpty else { return }
        isLoading = true
        service.fetchFlights(origin: origin, destination: destination, month: month) { [weak self] res in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch res {
                case .success(let data): self?.flights = data
                case .failure(let err): print(err)
                }
            }
        }
    }
    
    func suggestOrigin(for query: String) {
        guard query.count > 1 else {
            citySuggestionsOrigin = []
            return
        }

        service.fetchCitySuggestions(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    self?.citySuggestionsOrigin = suggestions
                case .failure:
                    self?.citySuggestionsOrigin = []
                }
            }
        }
    }
    
    func suggestDestination(for query: String) {
        guard query.count > 1 else {
            citySuggestionsDestination = []
            return
        }
        

        service.fetchCitySuggestions(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    self?.citySuggestionsDestination = suggestions
                case .failure:
                    self?.citySuggestionsDestination = []
                }
            }
        }
    }
    
    func updateMonthFromSelectedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        self.month = formatter.string(from: selectedDate)
    }
    
    enum TransportType: String, CaseIterable {
        case any = "Any"
        case plane = "Plane"
        case train = "Train"
        case bus = "Bus"
        case car = "Car"
        
        var symbolName: String {
                switch self {
                case .any: return "suitcase"
                case .plane: return "airplane"
                case .train: return "tram.fill"
                case .bus: return "bus.fill"
                case .car: return "car.fill"
                }
            }
        
        var backgroundColor: Color {
                switch self {
                case .any: return .green
                case .plane: return .blue
                case .train: return .red
                case .bus: return .orange
                case .car: return .purple
                }
            }
    }
}
