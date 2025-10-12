//
//  MovieQuizPresenter.swift
//  MovieQuiz
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Properties
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol!
    private weak var viewController: MovieQuizViewController?
    private weak var viewControllerProtocol: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestion?
    
    
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
    
    init(viewController: MovieQuizViewControllerProtocol, statisticService: StatisticServiceProtocol?) {
            self.viewControllerProtocol = viewController
            self.statisticService = statisticService
        }
    
    // MARK: - QuestionFactoryDelegate
    
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
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Methods
    
    // Методы подсчета очков для статистики
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
        currentQuestionIndexForNetworkError += 1
    }
    
    // метод конвертации, который принимает сетевые данные и возвращает вью модель для экрана вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    //  метод переключения состояния кнопки
    func switchButton(status: Bool) {
            viewController?.yesButton.isEnabled = status
            viewController?.noButton.isEnabled = status
    }
    
    //  метод, который содержит логику перехода в один из сценариев
    func proceedToNextQuestionOrResults() {
        
        // идём в состояние "Результат квиза"
        if self.isLastQuestion() {
            
            viewController?.presentAlertResult()
            
        } else { // 2
            self.switchToNextQuestion()
            
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
        }
    }
    
    // метод подсчета правильных ответов
    func didAnswer(isCorrectAnswer: Bool){
        if (isCorrectAnswer) { correctAnswers += 1 }
    }
    
    // метод подсчета результатов статистики и преобразования их в модель
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
    
    //  метод, который меняет цвет рамки, переходит в следующее состояние в зависимости от количества отвеченных вопросов
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect) // считаем правильные ответы
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        // показываем следующий вопрос через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in // слабая ссылка на self
            guard let self = self else { return } // разворачиваем слабую ссылку
            
            self.viewController?.switchStatusBottonsAndBordesrs()
            self.proceedToNextQuestionOrResults()
        }
    }
    
    // MARK: Buttons methods
    
    func yesButtonClicked() {
        
        switchButton(status: false)
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        
        switchButton(status: false)
        didAnswer(isYes: false)
    }
    
    // метод обработки ответов да/нет
    func didAnswer(isYes: Bool) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
