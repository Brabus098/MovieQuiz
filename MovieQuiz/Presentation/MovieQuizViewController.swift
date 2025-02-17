import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
    
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
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        // Создаем алерт
        alertPresent = AlertPresenter(controler: self)
        
        // Объявляем свойство статистики
        statistic = StatisticService()
        
        // Вызываем метод показа следующего вопроса
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Methods
    
    // метод заполнения алерта
    func presentAlertResult() {
        guard let stata = statistic else{return} // проверка на налияие значения
        stata.store(correct: correctAnswers, total: questionsAmount) // функция сравнения результата с лучшим
        let totalFormated = "\(String(format: "%.2f", stata.totalAccuracy))" // форматируем дату
        let alert = AlertModel(title: "Этот раунд окончен!",
                               message: "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыгранных квизов: \(stata.gamesCount) \n Рекорд: \(stata.bestGame.correct)/\(questionsAmount) (\((stata.bestGame.date).dateTimeString)) \n Средняя точность: \(totalFormated)%",
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
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
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
            YesButton.isEnabled = true
            NoButton.isEnabled = true
        } else {
            YesButton.isEnabled = false
            NoButton.isEnabled = false
        }
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

