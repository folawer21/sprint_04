//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр  Сухинин on 02.01.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter:QuestionFactoryDelegate {
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var currentQuestionIndex: Int  = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private var staticService: StatisticServiceProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        staticService = StatisticService()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            [weak self] in self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func loadDataAfterError(){
        questionFactory?.loadData()
    }
    
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        proceedWithAnswer(isCorrect: isYes)
    }
    
    func didAnswer(isCorrectAnswer: Bool){
        if isCorrectAnswer{
            correctAnswers += 1
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame(){
        currentQuestionIndex = 0
        correctAnswers = 0
        viewController?.hideBorder()
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestionIndex(){
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let stepViewModel = QuizStepViewModel(image:UIImage(data: model.image)  ?? UIImage(),
            question: model.text,
            questionNumber:"\(currentQuestionIndex+1) / \(questionsAmount)")
        return stepViewModel
    }
    
   
    private func proceedToNextQuestionOrResults(){
        if isLastQuestion(){
            guard let staticService = staticService as? StatisticService else  {return}
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
        
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        }
        else {
            switchToNextQuestionIndex()
            viewController?.hideBorder()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.showBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self ] in
            guard let self = self else {return}
            self.proceedToNextQuestionOrResults()
            self.viewController?.enableButtons()
        }
    }
    
}
