import SwiftUI

struct SearchView: View {
    @StateObject var vm = FlightSearchViewModel()
    
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    OriginInputView(vm: vm)
                    Divider()
                    DestinationInputView(vm: vm)
                }
                .padding(8)
                .background(vm.selectedTransport.backgroundColor)
                .animation(.easeInOut(duration: 0.2), value: vm.selectedTransport)
                .clipShape(.rect(cornerRadius: 10))
                
                HStack(spacing: 16) {
                    ForEach(FlightSearchViewModel.TransportType.allCases, id: \.self) { type in
                        Button {
                            vm.selectedTransport = type
                        } label: {
                            HStack {
                                Image(systemName: type.symbolName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                if vm.selectedTransport == type {
                                    Text(type.rawValue)
                                        .font(.custom("Helvetica", size: 25))
                                }
                            }
                            .padding(10)
                            .background(vm.selectedTransport == type ? type.backgroundColor : Color.gray.opacity(0.2))
                            .foregroundColor(vm.selectedTransport == type ? .white : .primary)
                            .cornerRadius(10)
                            .animation(.easeInOut(duration: 0.3), value: vm.selectedTransport)
                        }
                    }
                }
                
                HStack {
                    DatePicker("Month", selection: $vm.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .font(.custom("Helvetica", size: 25))
                    
                    Button("Search") {
                        vm.updateMonthFromSelectedDate()
                        vm.search()
                        showResults = true
                    }
                        .buttonStyle(.borderedProminent)
                        .font(.custom("Helvetica", size: 25))
                }
                
                if vm.isLoading { ProgressView() }

                Spacer()
            }
            .padding()
            .navigationTitle("GoTravel")
            .navigationDestination(isPresented: $showResults) {
                TicketsView(vm: vm)
            }
        }
    }
}

struct OriginInputView: View {
    @ObservedObject var vm: FlightSearchViewModel

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Origin", text: $vm.origin)
                .font(.custom("Helvetica", size: 30))
                .foregroundStyle(.white)
                .padding(5)
                .onChange(of: vm.origin) { oldValue, newValue in
                    vm.suggestOrigin(for: newValue)
                }
                .autocorrectionDisabled(true)

            VStack(alignment: .leading) {
                ForEach(vm.citySuggestionsOrigin.prefix(3)) { suggestion in
                    Button {
                        vm.origin = suggestion.code
                        vm.citySuggestionsOrigin = []
                    } label: {
                        Text("\(suggestion.name), \(suggestion.country_name) (\(suggestion.code))")
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 4)
                            .padding(.leading, 5)
                    }
                }
            }
        }
    }
}

struct DestinationInputView: View {
    @ObservedObject var vm: FlightSearchViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Destination", text: $vm.destination)
                .font(.custom("Helvetica", size: 30))
                .foregroundStyle(.white)
                .padding(5)
                .onChange(of: vm.destination) { oldValue, newValue in
                    vm.suggestDestination(for: newValue)
                }
                .autocorrectionDisabled(true)
            VStack(alignment: .leading) {
                ForEach(vm.citySuggestionsDestination.prefix(3)) { suggestion in
                    Button(action: {
                        vm.destination = suggestion.code
                        vm.citySuggestionsDestination = []
                    }) {
                        Text("\(suggestion.name), \(suggestion.country_name) (\(suggestion.code))")
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 4)
                            .padding(.leading, 5)
                    }
                }
            }
        }
    }
}


#Preview {
    SearchView()
}
