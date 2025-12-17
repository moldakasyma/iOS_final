import UIKit

class LocationsViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var emptyResultLabel: UILabel!
    let weatherService = WeatherService()
    var weatherResults: [(city: CityLocation, weather: WeatherResponse?)] = []
    private var searchWorkItem: DispatchWorkItem?
    
    private let popularCities: [CityLocation] = [
        CityLocation(name: "Almaty", lat: 43.2220, lon: 76.8512, country: "KZ"),
        CityLocation(name: "Astana", lat: 51.1605, lon: 71.4704, country: "KZ"),
        CityLocation(name: "London", lat: 51.5074, lon: -0.1278, country: "GB"),
        CityLocation(name: "New York", lat: 40.7128, lon: -74.0060, country: "US")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSearchBarTransparent()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        emptyResultLabel.isHidden = true

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        view.bringSubviewToFront(searchBar)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = .clear
        searchBar.placeholder="Search for a city"
        showPopularCities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func makeSearchBarTransparent() {
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = true
        searchBar.backgroundColor = .clear

        let textField = searchBar.searchTextField
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.25)
            textField.textColor = .white
            textField.tintColor = .white

            let placeholder = NSAttributedString(
                string: "Search for a city",
                attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
            )
            textField.attributedPlaceholder = placeholder
        

        searchBar.searchTextField.leftView?.tintColor = .white
    }
    private func showPopularCities() {
            weatherResults = popularCities.map { ($0, nil) }
            tableView.reloadData()
            
            fetchWeatherForCities(popularCities)
        }
}

// MARK: - TABLE VIEW
extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherResults.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CityCell",
            for: indexPath
        ) as! CityCell

        let data = weatherResults[indexPath.row]
        cell.configure(with: data.city, temperature: data.weather?.main.temp)
        
        cell.cityLabel.text = "\(data.city.name), \(data.city.country ?? "")"
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let indexPath = tableView.indexPathForSelectedRow,
           let vc = segue.destination as? WeatherViewController {

            let selectedCity = weatherResults[indexPath.row].city
            vc.city = selectedCity
        }
    }
}

// MARK: - SEARCH BAR
extension LocationsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Cancel previous search request if user types quickly
        searchWorkItem?.cancel()
        
        guard searchText.count >= 2 else {
            emptyResultLabel.isHidden = true
            weatherResults = popularCities.map { ($0, nil) }
            tableView.reloadData()
            fetchWeatherForCities(popularCities)
            return
        }
        // Create a new work item
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(searchText)
        }
        
        searchWorkItem = workItem
        
        // Wait 0.5 seconds before searching 
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Hide keyboard
    }
    
    private func performSearch(_ searchText: String) {
        weatherService.searchCities(searchText) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {

                case .success(let cities):
                    if cities.isEmpty {
                            self.weatherResults = []
                            self.tableView.reloadData()
                        
                            self.emptyResultLabel.text =
                                "Nothing found for \"\(searchText)\""
                            self.emptyResultLabel.isHidden = false
                            
                        } else {
                            self.emptyResultLabel.isHidden = true
                            
                            

                            self.weatherResults = cities.map { ($0, nil) }
                            self.tableView.reloadData()
                            self.fetchWeatherForCities(cities)
                        }
                case .failure(let error):
                    self.handleNetworkError(error)
                }
            }
        }
    }
    private func handleNetworkError(_ error: Error) {
        if let afError = error.asAFError,
           afError.isSessionTaskError {

            showNoInternetAlert()
        }
    }
    private func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your network and try again.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func fetchWeatherForCities(_ cities: [CityLocation]) {
        for city in cities {
            weatherService.fetchWeather(lat: city.lat, lon: city.lon) { [weak self] weather in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // Find the index and update only that row
                    if let index = self.weatherResults.firstIndex(
                        where: { $0.city.lat == city.lat && $0.city.lon == city.lon }
                    ) {
                        self.weatherResults[index] = (city, weather)
                        
                        // Reload only the specific row (better performance)
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
}
