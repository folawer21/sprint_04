//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр  Сухинин on 02.01.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter{
    let questionsAmount = 10
    private var currentQuestionIndex: Int  = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func yesButtonClicked() {
            guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: true == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect:  false == currentQuestion.correctAnswer)
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
    
    
}
