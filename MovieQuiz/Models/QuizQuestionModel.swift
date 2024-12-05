import Foundation

// модель со структурой вопроса
struct QuizQuestionModel {
    let image: Data // картинка в формате дата
    let text: String // строка с вопросом о рейтинге фильма
    let correctAnswer: Bool // булевое значение (true, false), правильный ответ на вопрос
}
