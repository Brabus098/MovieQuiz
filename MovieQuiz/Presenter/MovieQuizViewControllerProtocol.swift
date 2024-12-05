//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz

import Foundation
protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func presentAlertResult()
    func showNetworkError(message: String)
}
