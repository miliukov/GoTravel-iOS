import SwiftUI

struct SearchView: View {
    @StateObject var vm = FlightSearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("IATA origin", text: $vm.origin)
                TextField("IATA destination", text: $vm.destination)
                TextField("YYYY-MM", text: $vm.month)
                Button("Find Tickets") {
                    vm.search()
                }
                    .buttonStyle(.borderedProminent)
                
                if vm.isLoading { ProgressView() }
                
                List(vm.flights) { f in
                    VStack(alignment: .leading) {
                        Text("\(f.departure_at) — \(f.origin) → \(f.destination)")
                        Text("Цена: \(f.price) ₽")
                    }
                }
            }
            .padding()
            .navigationTitle("Find Flights")
        }
    }
}

#Preview {
    SearchView()
}
