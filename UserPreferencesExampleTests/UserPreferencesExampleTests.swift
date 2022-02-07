import XCTest
@testable import UserPreferencesExample

class UserPreferencesExampleTests: XCTestCase {

    let defaultValues = [UserDefaults.Keys.unitPreference: 0]
    var storage: MockUserDefaultsStorage!
    var preferences: MockUserDefaults!

    override func setUp() {
        storage = MockUserDefaultsStorage(values: defaultValues)
        preferences = MockUserDefaults(storage: storage)
    }

    override func tearDown() {
        preferences = nil
    }

    func testInitialDefaults() {
        XCTAssertEqual(preferences.unitPreference, 0)
    }
    
    func testChangingDefault() {
        preferences.unitPreference = 1
        XCTAssertEqual(preferences.unitPreference, 1)
        
        guard let intValue = storage.value(forKey: UserDefaults.Keys.unitPreference) as? Int else {
            XCTFail("Value in local storage expected to be Int")
            return
        }
        
        XCTAssertEqual(intValue, WeightUnitPreference.kilograms.rawValue)
    }
}
