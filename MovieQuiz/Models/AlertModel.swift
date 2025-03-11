import Foundation

// Модель со структурой алерта
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)? // функциональность кнопки
}
