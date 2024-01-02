import UIKit
final class MovieQuizViewController: UIViewController{
    
    
    private var alertPresenter: AlertPresenterProtocol?
    private var staticService: StatisticServiceProtocol?
    private var presenter : MovieQuizPresenter!
        
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
    
    
    func showLoadingIndicator(){
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        activityIndicator.stopAnimating()
    }
    func showNetworkError(message: String){
        hideLoadingIndicator()
        var errorAlert: AlertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз", completion: {
            [weak self] in guard let self = self else { return }
            self.presenter.questionFactory?.loadData()
            self.presenter.restartGame()
            
        })
        alertPresenter?.show(alertModel: errorAlert)
        
    }

    
    func show(quiz result: QuizResultsViewModel){
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] in
                guard let self = self else {return }
                self.presenter.restartGame()
                }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func hideBorder(){
        imageView.layer.borderWidth = 0
    }
   func show(quiz step: QuizStepViewModel){
        self.imageView.image = step.image
        self.counterLabel.text = step.questionNumber
        self.textLabel.text = step.question
        
        self.imageView.isHidden = false 
    }
    func showAnswerResult(isCorrect: Bool) {
        
        
        self.presenter.didAnswer(isCorrectAnswer: isCorrect)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self ] in
            guard let self = self else {return}
            self.presenter.staticService = self.staticService
            self.presenter.correctAnswers = self.presenter.correctAnswers
            self.presenter.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    
  
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        alertPresenter = AlertPresenter(viewController: self)
        staticService = StatisticService()
        presenter = MovieQuizPresenter(viewController: self )
        imageView.isHidden = true
        
        
        showLoadingIndicator()
    
        
        imageView.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true
       
    }
    
   
    
}

