import UIKit
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
  
   
    
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var staticService: StatisticServiceProtocol?
    private let presenter = MovieQuizPresenter()
        
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        yesButton.isEnabled = false

        presenter.yesButtonClicked()
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        presenter.noButtonClicked()
    }
    
    
    private func showLoadingIndicator(){
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        activityIndicator.stopAnimating()
    }
    private func showNetworkError(message: String){
        hideLoadingIndicator()
        var errorAlert: AlertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз", completion: {
            [weak self] in guard let self = self else { return }
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.loadData()
        })
        alertPresenter?.show(alertModel: errorAlert)
        
    }
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
  
    
    func show(quiz result: QuizResultsViewModel){
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
            [weak self] in
            guard let self = self else {return }
            self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()}
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
 
   func show(quiz step: QuizStepViewModel){
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
        self.textLabel.text = step.question
        
        self.imageView.isHidden = false 
    }
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 0
        yesButton.isEnabled = true
        noButton.isEnabled = true
        if isCorrect{
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self ] in
            guard let self = self else {return}
            self.presenter.staticService = self.staticService
            self.presenter.questionFactory = self.questionFactory
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        staticService = StatisticService()
        presenter.viewController = self
        imageView.isHidden = true
        
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
        imageView.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true
       
    }
    
    // MARK: - QuestionFactoryDelegate
    
   
    
}

