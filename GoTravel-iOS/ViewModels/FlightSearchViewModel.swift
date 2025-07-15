import Foundation

class FlightSearchViewModel: ObservableObject {
    @Published var origin = "svo"
    @Published var destination = "gsv"
    @Published var month = "2025-11" // YYYY-MM
    @Published var isLoading = false
    @Published var flights = [PriceData]()
    
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
}
