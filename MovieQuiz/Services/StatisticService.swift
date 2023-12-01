import Foundation


final class StatisticService: StatisticServiceProtocol {
    
    private enum Keys: String {
        case correct,total,bestGame, gamesCount, totalAccurancy
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccurancy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAccurancy.rawValue) else {
                var newtotalAccurancy: Double = 0
                let newtotalAccurancyString = String(newtotalAccurancy)
                guard let newData = try? JSONEncoder().encode(newtotalAccurancyString) else {
                    print("Невозможно сохранить результат")
                    //Можно ошибки сделать
                    return 0
                }
                userDefaults.set(newData, forKey: Keys.totalAccurancy.rawValue)
                return newtotalAccurancy
                
            }
            guard let totalAccurancy = try? JSONDecoder().decode(String.self, from: data) else {
                print("Невозможно получить результат")
                //Можно ошибки сделать
                return -1 }
            guard let result = Double(totalAccurancy) else {
                print("Невозможно получить результат")
                //Можно ошибки сделать
                return -1
            }
            return result
        }
        set {
            guard let data = try? JSONEncoder().encode(String(newValue)) else {
                print("Can't save new result")
                return
                
            }
            userDefaults.set(data, forKey: Keys.totalAccurancy.rawValue )
        }
    
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue) else {
                var newGameCount = 0
                let newGameCountString = String(newGameCount)
                guard let newData = try? JSONEncoder().encode(newGameCountString) else {
                    print("Невозможно сохранить результат")
                    //Можно ошибки сделать
                    return 0
                }
                userDefaults.set(newData, forKey: Keys.gamesCount.rawValue)
                return newGameCount
            }
            guard let gameCount = try? JSONDecoder().decode(String.self, from: data) else {
                print("Невозможно получить результат")
                //Можно ошибки сделать
                return -1 }
            guard let result = Int(gameCount) else {
                print("Невозможно получить результат")
                //Можно ошибки сделать
                return -1
            }
            return result
        }
        set {
            guard let data = try? JSONEncoder().encode(String(newValue)) else {
                print("Can't save new result")
                return
                
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue )
        }
    }
    
    var bestGame: GameRecord {
        get{
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self,from: data) else {
                      print("SADADSASDDA")
                      return .init(date:Date() , correct: 0, total: 0)
                  }
            return record
        }
        set {
                
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Can't save new result")
                return
                
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue )
            
        
        }
    }
    func addAccurancy(correct count: Int, total amount: Int){
        guard let oldcorrectData = userDefaults.data(forKey: Keys.correct.rawValue),
            let oldtotalData = userDefaults.data(forKey: Keys.total.rawValue) else {
                let newCorrectScore = count
                let newTotalScore = amount
                let newAccurancy = newCorrectScore*100/newTotalScore
                
                let newCorrectScoreString = String(newCorrectScore)
                let newTotalScoreString = String(newTotalScore)
                let newAccurancyString = String(newAccurancy)
                
                guard let newAccurancyData = try? JSONEncoder().encode(newAccurancyString),
                      let newTotalScoreData = try? JSONEncoder().encode(newTotalScoreString),
                      let newCorrectScoreData = try? JSONEncoder().encode(newCorrectScoreString) else {return }
                userDefaults.set(newAccurancyData, forKey: Keys.totalAccurancy.rawValue)
                userDefaults.set(newCorrectScoreData, forKey: Keys.correct.rawValue)
                userDefaults.set(newTotalScoreData, forKey: Keys.total.rawValue)
                print("Can't save new result 1")
                return
        }
        guard let correctScoreString = try? JSONDecoder().decode(String.self, from: oldcorrectData),
              let totalScoreString = try? JSONDecoder().decode(String.self, from: oldtotalData) else {
                  print("Can't save new result 2")
                  return
              }
        
        guard let correctScore = Int(correctScoreString),
              let totalScore = Int(totalScoreString) else {
                  return
              }
        let newCorrectScore = correctScore + count
        let newTotalScore = totalScore + amount
        let newAccurancy = newCorrectScore*100/newTotalScore
        
        let newCorrectScoreString = String(newCorrectScore)
        let newTotalScoreString = String(newTotalScore)
        let newAccurancyString = String(newAccurancy)
        
        guard let newAccurancyData = try? JSONEncoder().encode(newAccurancyString),
              let newTotalScoreData = try? JSONEncoder().encode(newTotalScoreString),
              let newCorrectScoreData = try? JSONEncoder().encode(newCorrectScoreString) else {return }
        userDefaults.set(newAccurancyData, forKey: Keys.totalAccurancy.rawValue)
        userDefaults.set(newCorrectScoreData, forKey: Keys.correct.rawValue)
        userDefaults.set(newTotalScoreData, forKey: Keys.total.rawValue)
        
        
    }
    func store(correct count: Int, total amount: Int) {
        guard let oldData = userDefaults.data(forKey: Keys.bestGame.rawValue),
              let record = try? JSONDecoder().decode(GameRecord.self, from: oldData) else{
                  let newRecord = GameRecord(date: Date(), correct: count, total: amount)
                  guard let data = try? JSONEncoder().encode(newRecord) else {return
                  }
                  userDefaults.set(data, forKey: Keys.bestGame.rawValue)
                  return
              }
        if record.correct < count {
            let newRecord = GameRecord(date: Date(), correct: count, total: amount)
            guard let data = try? JSONEncoder().encode(newRecord) else {return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            
        }
    }
    
    
}
