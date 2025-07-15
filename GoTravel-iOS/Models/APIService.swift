import Foundation

class APIService {
    let token = Secrets.travelpayoutsToken
    
    func fetchFlights(origin: String, destination: String, month: String, completion: @escaping (Result<[PriceData], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.travelpayouts.com/aviasales/v3/prices_for_dates")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "origin", value: origin.uppercased()),
            URLQueryItem(name: "destination", value: destination.uppercased()),
            URLQueryItem(name: "departure_at", value: month),
            URLQueryItem(name: "one_way", value: "true"),
            URLQueryItem(name: "sorting", value: "price"),
            URLQueryItem(name: "limit", value: "30"),
            URLQueryItem(name: "token", value: token)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request) { data, resp, err in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            print("Получены данные: \(String(data: data, encoding: .utf8) ?? "nil")")
            do {
                let resp = try JSONDecoder().decode(FlightApiResponce.self, from: data)
                if resp.success {
                    completion(.success(resp.data))
                } else {
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchCitySuggestions(query: String, completion: @escaping (Result<[CitySuggestion], Error>) -> Void) {
        var components = URLComponents(string: "https://autocomplete.travelpayouts.com/places2")!
        components.queryItems = [
            URLQueryItem(name: "term", value: query),
            URLQueryItem(name: "types[]", value: "city")
        ]

        guard let url = components.url else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0)))
                return
            }

            do {
                let suggestions = try JSONDecoder().decode([CitySuggestion].self, from: data)
                completion(.success(suggestions))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
