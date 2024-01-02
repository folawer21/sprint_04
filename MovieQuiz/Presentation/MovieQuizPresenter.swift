//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр  Сухинин on 02.01.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter{
    var correctAnswers = 0
    let questionsAmount = 10
    private var currentQuestionIndex: Int  = 0
    
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var staticService: StatisticServiceProtocol?
    
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
        viewController?.showAnswerResult(isCorrect: isYes)
    }
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex(){
        currentQuestionIndex = 0
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
    func showNextQuestionOrResults(){
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
            questionFactory?.requestNextQuestion()
        }
    }
    
}
