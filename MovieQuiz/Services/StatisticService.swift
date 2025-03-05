import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Remove duplication
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        //Кейсы к всей игре
        case correctAnswers // правильные ответы всего
        case gamesCount // количество игр всего
        
        // Кейсы к bestgame
        case correct // правильные ответы за раунд
        case totalQuestion // количество вопросов за раунд
        case bestDate // время лучшего раунда
    }
    
    // MARK: - Computed properties
    private var correctAnswers: Int { // количество правильных ответов всего
        
        get {storage.integer(forKey: Keys.correctAnswers.rawValue) }
        set {storage.set(newValue, forKey: Keys.correctAnswers.rawValue) }
    }
    
    var gamesCount: Int { // количество завершенных игр
        
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameResult { // информация о лучшей попытке
        
        get { // Чтение значений полей GameResult(correct, total и date) из UserDefaults
            let correct = storage.integer(forKey: Keys.correct.rawValue) // количество правильных ответов
            let total = storage.integer(forKey: Keys.totalQuestion.rawValue) // количество вопросов квиза
            if let date1 = storage.object(forKey:  Keys.bestDate.rawValue) as? Date {
                return GameResult(correct: correct, total: total, date: date1) // дату завершения раунда
            } else {
                return GameResult(correct: correct, total: total, date: Date())}
        }
        set {  // Запись значений каждого поля из newValue в UserDefaults
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.totalQuestion.rawValue)
            storage.set(newValue.date, forKey:  Keys.bestDate.rawValue)
        }
    }
    
    var totalAccuracy: Double { // средняя точность правильных ответов за все игры в процентах
        let result = (Double(correctAnswers) / Double(gamesCount * 10)) * 100
        return result }
    
    // MARK: - Function
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count // обновляем количество правильных ответов
        gamesCount += 1 // обновляем количество заданных вопросов
        if count > bestGame.correct { // проверяем условия на лучший результат
            bestGame = GameResult(correct: count, total: 10, date: Date())
        } else {}
    }
}
