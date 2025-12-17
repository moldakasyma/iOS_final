import Alamofire
import Foundation

class WeatherService {

    let apiKey = "YOUR_API_KEY"

    func searchCities(
        _ query: String,
        completion: @escaping (Result<[CityLocation], Error>) -> Void
    ) {
        let url = "https://api.openweathermap.org/geo/1.0/direct"

        let parameters: [String: Any] = [
            "q": query,
            "limit": 5,
            "appid": apiKey,
            "lang": "en"
        ]

        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: [CityLocation].self) { response in
                switch response.result {

                case .success(let cities):
                    let englishCities = cities.filter {
                        $0.name.range(of: "[А-Яа-я]", options: .regularExpression) == nil
                    }

                    var uniqueCities: [CityLocation] = []
                    var seenNames = Set<String>()

                    for city in englishCities {
                        if !seenNames.contains(city.name) {
                            uniqueCities.append(city)
                            seenNames.insert(city.name)
                        }
                    }

                    let singleCity = uniqueCities.first.map { [$0] } ?? []
                    completion(.success(singleCity))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }   

    func fetchWeather(lat: Double, lon: Double, completion: @escaping (WeatherResponse?) -> Void) {

        let url = "https://api.openweathermap.org/data/2.5/weather"

        let parameters: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "appid": apiKey,
            "units": "metric"
        ]

        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: WeatherResponse.self) { response in
                switch response.result {
                case .success(let weather):
                    completion(weather)
                case .failure(let error):
                    print("Weather error:", error)
                    completion(nil)
                }
            }
    }
}
