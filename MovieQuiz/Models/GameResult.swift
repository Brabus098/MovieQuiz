//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Владимир on 13.02.2025.
//

import Foundation

// Модель результатов игры
struct GameResult {
    let correct: Int // количество правильных ответов
    let total: Int // количество вопросов квиза
    let date: Date // дату завершения раунда
}
