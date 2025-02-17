//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Владимир on 03.02.2025.
//
import Foundation



// вью модель со структурой вопроса
    struct QuizQuestion {
    // строка с названием фильма,
    // совпадает с названием картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}

