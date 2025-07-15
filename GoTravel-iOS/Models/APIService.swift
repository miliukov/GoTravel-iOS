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
            URLQueryItem(name: "limit", value: "10"),
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
}
