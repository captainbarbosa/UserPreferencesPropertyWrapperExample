import Foundation
@testable import UserPreferencesExample

class MockUserDefaults {
    @UserPreference(key: UserDefaults.Keys.unitPreference,
                    defaultValue: 0)
    var unitPreference: Int
    
    let storage: UserDefaultsStorage
    
    init(storage: MockUserDefaultsStorage) {
        self.storage = storage
        _unitPreference.storage = storage
    }
}
