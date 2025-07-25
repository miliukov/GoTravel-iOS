import SwiftUI

struct TicketsView: View {
    @StateObject var vm: FlightSearchViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.flights) { ticket in
                    PlaneCard(ticket: ticket, vm: vm)
                }
            }
            .padding(.horizontal)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Moscow - Saratov")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaneCard: View {
    let ticket: PriceData
    let vm: FlightSearchViewModel
    
    var body: some View {
        let formattedDepartureAt = vm.formatDeparture(ticket.departure_at)

        VStack {
            HStack(alignment: .top) {
                Text("\(ticket.price)₽")
                    .font(.custom("Helvetica", size: 30))
                Spacer()
                AsyncImage(url: URL(string: "https://pics.avs.io/200/70/\(ticket.airline)@2x.png"), scale: 3)
            }
            HStack {
                Text(ticket.origin_airport)
                    .font(.custom("Helvetica", size: 30))
                VStack {
                    HStack {
                        Text(formattedDepartureAt?.time ?? "–:–")
                        Spacer()
                        Text("-:-")
                    }
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                        .frame(height: 2)
                    HStack {
                        Text(formattedDepartureAt?.date ?? "-.-.-")
                        Spacer()
                        Text("-.-.-")
                    }
                }
                .padding(.horizontal)
                
                Text(ticket.destination_airport)
                    .font(.custom("Helvetica", size: 30))
            }
        }
        .padding()
        .background()
        .cornerRadius(10)
        .shadow(radius: 4, x: 5, y: 5)
    }
}

#Preview {
    TicketsView(vm: FlightSearchViewModel())
}
