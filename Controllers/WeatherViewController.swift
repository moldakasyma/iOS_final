import UIKit

class WeatherViewController: ViewController {
    
    @IBOutlet weak var backgroundAnimationView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    var city: CityLocation?
    let weatherService = WeatherService()
    private let animationManager = WeatherAnimationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        guard let city = city else {
            if presentingViewController != nil {
                dismiss(animated: true)
            }
            return
        }
        
        cityLabel.text = city.name
        updateFavoriteButton()
        loadWeather(for: city)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let city = city else { return }
        
        FavoriteManager.shared.toggleFavorite(city)
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let city = city else {
            favoriteButton.isHidden = true
            return
        }
        
        favoriteButton.isHidden = false
        let isFavorite = FavoriteManager.shared.isFavorite(city)
        let heartImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        favoriteButton.setImage(heartImage, for: .normal)
        favoriteButton.tintColor = isFavorite ? .red : .blue
    }

    func loadWeather(for city: CityLocation) {
        print("DEBUG: Loading weather for \(city.name)")
        
        weatherService.fetchWeather(lat: city.lat, lon: city.lon) { [weak self] weather in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let weather = weather {
                    print("DEBUG: Weather loaded: \(weather.main.temp)°C")
                    self.tempLabel.text = "\(Int(weather.main.temp))°C"
                    self.descriptionLabel.text = weather.weather.first?.description ?? ""
                    let feelsLike = Int(weather.main.feels_like)
                    self.feelsLikeLabel.text = "Feels like \(feelsLike)°C"
                    
                    let condition = weather.weather.first?.main ?? "Clear"
                    print("DEBUG: Weather condition: \(condition)")
                    
                    // ВСЕ обновления здесь!
                    self.updateWeatherIcon(condition: condition)
                    self.updateAnimalImage(weatherCondition: condition)
                    self.updateBackgroundAnimation(condition: condition)
                    
                } else {
                    print("DEBUG: Failed to load weather")
                    self.tempLabel.text = "N/A"
                    self.descriptionLabel.text = "Weather data unavailable"
                    self.feelsLikeLabel.text = nil
                    self.weatherIconImageView.image = UIImage(systemName: "questionmark.circle")
                    self.petImageView.image = UIImage(named: "panda_cloud")
                }
            }
        }
    }
    
    func updateBackgroundAnimation(condition: String) {
        let c = condition.lowercased()

        if c.contains("rain") || c.contains("drizzle") {
            animationManager.showRain(on: backgroundAnimationView)
        } else if c.contains("snow") {
            animationManager.showSnow(on: backgroundAnimationView)
        } else if c.contains("cloud") || c.contains("mist") || c.contains("fog") {
            animationManager.showClouds(on: backgroundAnimationView)
        } else {
            animationManager.showSun(on: backgroundAnimationView)
        }
    }
    
    func updateWeatherIcon(condition: String) {
        let lowercasedCondition = condition.lowercased()
        var systemImageName = "questionmark.circle"
        var iconColor: UIColor = .systemBlue
        
        switch lowercasedCondition {
        case let str where str.contains("clear") || str.contains("dust"):
            systemImageName = "sun.max.fill"
            iconColor = .systemOrange
        case let str where str.contains("cloud"):
            systemImageName = "cloud.fill"
            iconColor = .systemGray
        case let str where str.contains("rain"):
            systemImageName = "cloud.rain.fill"
            iconColor = .systemBlue
        case let str where str.contains("drizzle"):
            systemImageName = "cloud.drizzle.fill"
            iconColor = .systemBlue
        case let str where str.contains("thunderstorm"):
            systemImageName = "cloud.bolt.rain.fill"
            iconColor = .systemPurple
        case let str where str.contains("snow"):
            systemImageName = "snowflake"
            iconColor = .systemTeal
        case let str where str.contains("mist") || str.contains("fog") || str.contains("haze"):
            systemImageName = "cloud.fog.fill"
            iconColor = .systemGray2
        case let str where str.contains("wind"):
            systemImageName = "wind"
            iconColor = .systemGray
        default:
            systemImageName = "questionmark.circle"
            iconColor = .systemGray
        }
        
        weatherIconImageView.image = UIImage(systemName: systemImageName)
        weatherIconImageView.tintColor = iconColor
    }
    
    func updateAnimalImage(weatherCondition: String) {
        let animal = AnimalManager.shared.getSelectedAnimal()
        let condition: String
        let lowercasedCondition = weatherCondition.lowercased()
        
        switch lowercasedCondition {
        case let str where str.contains("clear") || str.contains("sun"):
            condition = "sun"
        case let str where str.contains("rain") || str.contains("drizzle"):
            condition = "rain"
        case let str where str.contains("snow") || str.contains("sleet"):
            condition = "snow"
        case let str where str.contains("cloud") || str.contains("mist") || str.contains("fog"):
            condition = "cloud"
        default:
            condition = "cloud"
        }
        
        let imageName = "\(animal.rawValue)_\(condition)"
        
        print("DEBUG: Animal: \(animal.rawValue), Condition: \(condition)")
        print("DEBUG: Image name: \(imageName)")
        
        if let image = UIImage(named: imageName) {
            petImageView.image = image
        } else {
            print("WARNING: Image '\(imageName)' not found. Trying fallback...")
            
            let fallbackNames = [
                "\(animal.rawValue)_cloud",
                "panda_cloud",
                "panda_sun"
            ]
            
            for fallbackName in fallbackNames {
                if let fallbackImage = UIImage(named: fallbackName) {
                    petImageView.image = fallbackImage
                    print("Using fallback: \(fallbackName)")
                    return
                }
            }
            
            petImageView.image = nil
            print("ERROR: No animal images found!")
        }
    }
}
