//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Владимир on 05.02.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: (() -> Void)?
}
