import Foundation

class AnimalManager {
    static let shared = AnimalManager()
    private let key = "selectedAnimal"
    
    private init() {}
    
    func getSelectedAnimal() -> AnimalType {
        if let value = UserDefaults.standard.string(forKey: key),
           let animal = AnimalType(rawValue: value) {
            return animal
        }
        return .panda // default
    }
    
    func setAnimal(_ animal: AnimalType) {
        UserDefaults.standard.set(animal.rawValue, forKey: key)
    }
}
