//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Александр  Сухинин on 02.01.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func showBorder(isCorrect: Bool)
    func hideBorder()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func enableButtons()
}
