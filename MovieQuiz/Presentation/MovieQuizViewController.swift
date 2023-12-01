import UIKit
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var staticService: StatisticServiceProtocol?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBAction private func noButtonClicked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == false {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer == true {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    private func show(quiz result: QuizResultsViewModel){
        
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()}
        )
        alertPresenter?.show(alertModel: alertModel)
//        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
//        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//            guard let self = self else {return }
//
//
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let stepViewModel = QuizStepViewModel(image:UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber:"\(currentQuestionIndex+1) / \(questionsAmount)")
        return stepViewModel
    }
    private func show(quiz step: QuizStepViewModel){
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
        self.textLabel.text = step.question
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect{
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self ] in
            guard let self = self else {return}
           self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults(){
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionsAmount - 1 {
            yesButton.isEnabled = true
            noButton.isEnabled = true
            guard let staticService = staticService as? StatisticService
            else  {
                return
            }
            staticService.gamesCount = staticService.gamesCount + 1
            staticService.store(correct: correctAnswers, total: questionsAmount)
            staticService.addAccurancy(correct: correctAnswers, total: questionsAmount)
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YY hh:mm"
            let date = dateFormatter.string(from: staticService.bestGame.date)
            let gamesCount = staticService.gamesCount
            let bestGameCorrect = staticService.bestGame.correct
            let bestGameTotal = staticService.bestGame.total
            let bestGameDate = date
            let totalAccurancy = staticService.totalAccurancy
            
            let text = "Ваш результат:\(correctAnswers)/10\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGameCorrect)/\(bestGameTotal) (\(bestGameDate))\nСредняя точность: \(totalAccurancy)%"
            //время поправить
        
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            print(viewModel.text)
            show(quiz: viewModel)
        }
        else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            yesButton.isEnabled = true
            noButton.isEnabled = true
            
        }
    }
    
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("!@$!$")
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        staticService = StatisticService()
        
        
        imageView.layer.cornerRadius = 20
        questionFactory?.requestNextQuestion()
       
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            [weak self] in self?.show(quiz: viewModel)
        }
    }
    
}

