//
//  FavoriteManager.swift
//  weather2
//
//  Created by  Айя on 13.12.2025.
//

import Foundation

class FavoriteManager{
    static let shared=FavoriteManager()
    private let key="favoriteCity"
    
    private init(){}
    func getFavorites() -> [FavoriteCity] {
            guard
                let data = UserDefaults.standard.data(forKey: key),
                let cities = try? JSONDecoder().decode([FavoriteCity].self, from: data)
            else {
                return []
            }
            return cities
        }

        func isFavorite(_ city: CityLocation) -> Bool {
            return getFavorites().contains {
                $0.lat == city.lat && $0.lon == city.lon
            }
        }

        func toggleFavorite(_ city: CityLocation) {
            var favorites = getFavorites()

            if let index = favorites.firstIndex(where: {
                $0.lat == city.lat && $0.lon == city.lon
            }) {
                favorites.remove(at: index)
            } else {
                let fav = FavoriteCity(
                    name: city.name,
                    lat: city.lat,
                    lon: city.lon,
                    country: city.country
                )
                favorites.append(fav)
            }

            save(favorites)
        }
    func removeFavorite(_ city: FavoriteCity) {
        var favorites = getFavorites()
        favorites.removeAll {
            $0.lat == city.lat && $0.lon == city.lon
        }
        save(favorites)
    }

        private func save(_ favorites: [FavoriteCity]) {
            if let data = try? JSONEncoder().encode(favorites) {
                UserDefaults.standard.set(data, forKey: key)
            }
        }
}
