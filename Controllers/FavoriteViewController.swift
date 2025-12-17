import UIKit

class FavoriteViewController: ViewController, FavoriteCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var favorites: [FavoriteCity] = []
    var weatherResults: [(city: CityLocation, weather: WeatherResponse?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        
    }
    
    func didRemoveFavorite(_ city: FavoriteCity) {
        FavoriteManager.shared.removeFavorite(city)
        loadFavorites()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func loadFavorites() {
        favorites = FavoriteManager.shared.getFavorites()
        tableView.reloadData()
    }
    
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "FavoriteCell",
            for: indexPath
        ) as! FavoriteCell
        
        let city = favorites[indexPath.row]
        cell.configure(with: city)
        cell.delegate = self 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteCity = favorites[indexPath.row]
        let cityLocation = CityLocation(
            name: favoriteCity.name,
            lat: favoriteCity.lat,
            lon: favoriteCity.lon,
            country: favoriteCity.country
        )
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let weatherVC = storyboard.instantiateViewController(
            withIdentifier: "WeatherViewController"
        ) as? WeatherViewController {
            weatherVC.city = cityLocation
            navigationController?.pushViewController(weatherVC, animated: true)
        }
    }
}


