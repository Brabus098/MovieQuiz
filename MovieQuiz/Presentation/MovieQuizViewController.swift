import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Properties
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Presenters
    
    private var alertPresent: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //настраиваем фон
        setupFonts()
        
        // Назначаем контролер для презентера
        presenter = MovieQuizPresenter(viewController: self)
        
        // Назначаем контролер для алерта
        alertPresent = AlertPresenter(controler: self)
        
    }
    // MARK: - Methods
    
    // метод заполнения алерта
    func presentAlertResult() {
        
        let message = presenter.makeResultsMessage()
        let alert = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in // слабая ссылка на self
                guard let self = self else { return }
                // обнуляем результаты текущей игры
                self.presenter.restartGame()
            })
        
        alertPresent?.presentAlerts(alertModel: alert) // вызываем показ алерта
    }
    
    // метод заполнения данных на экране
    func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // метод скрытия рамки и включения реакции кнопок
    func switchStatusBottonsAndBordesrs(){
        presenter.switchButton(status: true) // делаем кнопки активными
        self.imageView.layer.borderWidth = 0
    }
    
    // метод для показа рамок
    func highlightImageBorder(isCorrectAnswer: Bool) {
        // Красим рамку
        imageView.layer.masksToBounds = true // Даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // Указываем толщину рамки согласно по макету
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // определяем цвет рамки
    }
    
    // метод загрузки индикатора
    func showLoadingIndicator() {
        activityIndicator.isHidden = false 
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // метод скрытия индикатора
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    // метод для показа alert с ошибкой
    func showNetworkError(message: String) {
        showLoadingIndicator()
        // создайте и покажите алерт
        let errorModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать еще раз",
                                    completion: { [weak self] in // слабая ссылка на self
            guard let self = self else { return }
            
            if presenter.currentQuestionIndexForNetworkError == .zero {
                //self.questionFactory?.loadData() // если ошибка возникла при первом вызове ??????
                presenter.questionFactory?.loadData()
            } else {
                activityIndicator.isHidden = true
                // обнуляем результаты текущей игры
                self.presenter.restartGame()
            }
        })
        
        alertPresent?.presentAlerts(alertModel: errorModel)
        
    }
    
    // метод настройки шрифтов
    private func setupFonts() {
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    // MARK: Buttons
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        
    }
}
