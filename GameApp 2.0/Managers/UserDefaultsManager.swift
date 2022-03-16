import Foundation

class UserDefaultsManager {
    //MARK: - properties
    static let shared = UserDefaultsManager()
    
    //MARK: - private init
    private init() {}
    
    //MARK: - methods
    func saveResults(results: GameResults) {
        var savedResults = receiveResults()
        savedResults?.append(results)
        
        UserDefaults.standard.setValue(encodable: savedResults, forKey: UserDefaultsKeys.resultKey)
    }
    
    func receiveResults() -> [GameResults]? {
        guard let models = UserDefaults.standard.loadValue([GameResults].self, forKey: UserDefaultsKeys.resultKey) else { return [] }
        return models
    }
}
