import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // MARK: - Counters & Mock
    
    private var correctAnswers = 0  // переменная со счётчиком правильных ответов
    
    private var currentQuestionIndex = 0 // переменная с индексом текущего вопроса
    
    private let questionsAmount: Int = 10 // констана с количеством вопросов всего
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresent: AlertPresenter?
    
    private var currentQuestion: QuizQuestion?
    private var statistic: StatisticServiceProtocol?
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFonts()
        
        // Создаем фабрику вопросов
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        //questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        //Показываем индикатор
        showLoadingIndicator()
        
        // Начинаем загружать данные
        questionFactory.loadData()
        
        // Создаем алерт
        alertPresent = AlertPresenter(controler: self)
        
        // Объявляем свойство статистики
        statistic = StatisticService()
        
    }
    
    // MARK: - QuestionFactoryDelegate
    // Осуществляем показ с полученных данных из сети
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    // Принимаем инфу об успешном результате от делегата
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    // Принимаем ошибку в случае если данные не получены
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    // MARK: - Methods
    
    // метод заполнения алерта
    private func presentAlertResult() {
        guard let stata = statistic else{return} // проверка на налияие значения
        stata.store(correct: correctAnswers, total: questionsAmount) // функция сравнения результата с лучшим
        let totalFormated = "\(String(format: "%.2f", stata.totalAccuracy))" // форматируем дату
        let alert = AlertModel(
                               title: "Этот раунд окончен!",
                               message: """
                               Ваш результат: \(correctAnswers)/\(questionsAmount)  
                               Количество сыгранных квизов: \(stata.gamesCount)  
                               Рекорд: \(stata.bestGame.correct)/\(questionsAmount) (\((stata.bestGame.date).dateTimeString))
                               Средняя точность: \(totalFormated)% 
                               """,
                               buttonText: "Сыграть еще раз",
                               completion: { [weak self] in // слабая ссылка на self
            guard let self = self else { return }
            // обнуляем результаты текущей игры
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        })
        
        alertPresent?.presentAlerts(alertModel: alert) // вызываем показ алерта
    }
    
    // метод настройки шрифтов
    private func setupFonts() {
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    // метод конвертации, который принимает сетевые данные и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // приватный метод вывода на экран вопроса
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод, который меняет цвет рамки, переходит в следующее состояние в зависимости от количества отвеченых вопросов
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1 } // считаем правильные ответы
        
        // Красим рамку
        imageView.layer.masksToBounds = true // Даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // Указываем толщину рамки согласно по макету
        
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // определяем цвет рамки
        
        // показываем следующий вопрос через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in // слабая ссылка на self
            guard let self = self else { return } // разворачиваем слабую ссылку
            self.imageView.layer.borderWidth = 0
            switchButton(status: true) // делаем кнопки активными
            self.showNextQuestionOrResults()
        }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        // идём в состояние "Результат квиза"
        if currentQuestionIndex == questionsAmount - 1 {
            presentAlertResult()
            
        } else { // 2
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
        }
    }
    
    // Приватный метод переключения состояния кнопки
    private func switchButton(status: Bool) {
        if status {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        } else {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        }
    }
    
    // Приватный метод загрузки индикатора
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func showNetworkError(message: String) {
        showLoadingIndicator() // скрываем индикатор загрузки
        // создайте и покажите алерт
        let errorModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз", completion: { [weak self] in // слабая ссылка на self
            guard let self = self else { return }
            
            if currentQuestionIndex == .zero {
                self.questionFactory?.loadData() // если ошибка возникла при первом вызове
            } else {
                activityIndicator.isHidden = true
                self.questionFactory?.requestNextQuestion()
                // обнуляем результаты текущей игры
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
            }
        })
        
        alertPresent?.presentAlerts(alertModel: errorModel)
        
    }
    
    // MARK: Buttons
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        switchButton(status: false)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        switchButton(status: false)
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
