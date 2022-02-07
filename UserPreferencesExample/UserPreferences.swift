import Combine
import Foundation

protocol UserDefaultsStorage {
    func value(forKey key: String) -> Any?
    func setValue(_ value: Any?, forKey key: String)
    func register(defaults registrationDictionary: [String : Any])
}

extension UserDefaults: UserDefaultsStorage { }

@propertyWrapper
struct UserPreference<T> {
    let key: String
    let defaultValue: T
    var storage: UserDefaultsStorage = UserDefaults.standard
    
    var wrappedValue: T {
        get {
            if let value = storage.value(forKey: key) as? T {
                return value
            } else {
                return defaultValue
            }
        }
        
        nonmutating set {
            storage.setValue(newValue, forKey: key)
        }
    }
    
    public init(key: String,
                defaultValue: T,
                storage: UserDefaultsStorage = UserDefaults.standard) {
        
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
        
        self.storage.register(defaults: [self.key: wrappedValue])
    }
}

extension UserDefaults {
    public enum Keys {
        static let unitPreference = "unit_preference"
    }
    
    @UserPreference(key: Keys.unitPreference, defaultValue: WeightUnitPreference.pounds.rawValue)
    private static var unitPreference: Int
    
    // This allows us to access the publisher for the given
    // preference via the `\.unitPreference` key path.
    @objc var unitPreference: Int {
        get {
            return Self.unitPreference
        }
        set {
            Self.unitPreference = newValue
        }
    }
}

enum WeightUnitPreference: Int {
    case pounds = 0
    case kilograms = 1
    
    var description: String {
        switch self {
        case .pounds:
            return "Pounds"
        case .kilograms:
            return "Kilograms"
        }
    }
}
