import Foundation

enum Secrets {
    static let travelpayoutsToken: String = {
        guard
            let url = Bundle.main.url(forResource: "Tokens", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let token = dict["TRAVELPAYOUTS_TOKEN"] as? String
        else {
            fatalError("Не удалось загрузить TRAVELPAYOUTS_TOKEN из Secrets.plist")
        }
        return token
    }()
}
