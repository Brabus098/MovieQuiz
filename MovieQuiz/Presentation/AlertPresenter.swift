//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Владимир on 05.02.2025.
//

import UIKit

// Создаем класс и переносим в него ответсвенность за показ алерта

class AlertPresenter {
    
    weak var controler: UIViewController?
    
    init(controler: UIViewController) {
        self.controler = controler
    }
    
    func presentAlerts(alertModel model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in
            model.completion?()
        }
        
        alert.addAction(action)
        
        controler?.present(alert, animated: true, completion: nil)
    }
}
