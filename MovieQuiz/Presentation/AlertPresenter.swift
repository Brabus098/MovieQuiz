import UIKit

final class AlertPresenter {
    
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
