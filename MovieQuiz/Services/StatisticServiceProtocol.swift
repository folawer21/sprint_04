import Foundation

protocol StatisticServiceProtocol {
    var totalAccurancy: Double {get }
    var gamesCount: Int {get }
    var bestGame: GameRecord {get }
    
    func store(correct count: Int, total amount: Int)
    
}

struct GameRecord: Codable {
    let date : Date
    let correct: Int
    let total: Int
    
    func compareGameRecord(newResult: GameRecord) -> Bool{
        return self.correct > newResult.correct
    }
}

