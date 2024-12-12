//  MovieQuizPresenter.swift

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Properties
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol!
    private weak var viewController: MovieQuizViewController?
    private weak var viewControllerProtocol: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestionModel?
    
    // MARK: - Counters
    var currentQuestionIndexForNetworkError = 0
    private var correctAnswers = 0 // переменная со счётчиком правильных ответов
    private let questionsAmount: Int = 10 // констана с количеством вопросов всего
    private var currentQuestionIndex: Int = 0 // переменная с индексом текущего вопроса
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    init(viewController: MovieQuizViewControllerProtocol, statisticService: StatisticServiceProtocol?) { // инициализатор для тестов
        self.viewControllerProtocol = viewController
        self.statisticService = statisticService
    }
    
    // MARK: - Methods
    // метод конвертации, который принимает сетевые данные и возвращает вью модель для экрана вопроса
    func convert(model: QuizQuestionModel) -> QuizStepModel {
        
        return QuizStepModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
        currentQuestionIndexForNetworkError += 1
    }
    
    //  метод, который содержит логику перехода в один из сценариев
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            viewController?.presentAlertResult()
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func didAnswer(isCorrectAnswer: Bool){
        if isCorrectAnswer { correctAnswers += 1 }
    }
    
    //  метод, который меняет цвет рамки, переходит в следующее состояние в зависимости от количества отвеченных вопросов
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect) // считаем правильные ответы
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            
            self.viewController?.switchStatusButtonsAndBorders()
            self.proceedToNextQuestionOrResults()
        }
    }
    
    // метод обработки ответов да/нет
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

// MARK: Methods calls by controller
extension MovieQuizPresenter {
    func yesButtonClicked() {
        viewController?.switchButton(status: false)
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        viewController?.switchButton(status: false)
        didAnswer(isYes: false)
    }
    
    func checkCurrentQuestionIndexState() {
        if currentQuestionIndexForNetworkError == .zero {
            questionFactory?.loadData()
        } else {
            viewController?.hideLoadingIndicator()
            restartGame()
        }
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter {
    
    // метод для оповещения об успешной загрузке данных
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    // метод для не полученных данных из сети
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    // метод для показа полученных данных из сети
    func didReceiveNextQuestion(question: QuizQuestionModel?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
}
