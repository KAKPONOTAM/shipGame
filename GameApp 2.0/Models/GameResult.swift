import Foundation

class GameResults: Codable {
    var result: String?
    var resultDate: String
  
    init(result: String?, resultDate: String) {
        self.result = result
        self.resultDate = resultDate
    }

    private enum CodingKeys: String, CodingKey {
        case result
        case resultDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(resultDate, forKey: .resultDate)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decode(String.self, forKey: .result)
        self.resultDate = try container.decode(String.self, forKey: .resultDate)
    }
}

