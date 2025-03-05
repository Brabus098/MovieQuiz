import Foundation

// вью модель со структурой вопроса
struct QuizQuestion {
    // картинка в формате дата
    let image: Data
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
