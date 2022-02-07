import Foundation
@testable import UserPreferencesExample

class MockUserDefaultsStorage: UserDefaultsStorage {
    
    var registrationDict: [String : Any]?
    
    func register(defaults registrationDictionary: [String : Any]) {
        registrationDict = registrationDictionary
    }
    
    var values: [String: Any]

    init(values: [String: Any] = [:]) {
        self.values = values
    }

    func value(forKey key: String) -> Any? {
        return values[key]
    }

    func setValue(_ value: Any?, forKey key: String) {
        values[key] = value
    }
}
