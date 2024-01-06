//
//  MovieQuizUITests2.swift
//  MovieQuizUITests2
//
//  Created by Александр  Сухинин on 18.12.2023.
//

import XCTest

final class MovieQuizUITests2: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        app = XCUIApplication()
        app.launch()
       
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
    func testYesButton(){
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2 / 10")
        
    }
    
    func testNoButton(){
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2 / 10")
    }
    
    func testAlertFinish(){
        for i in 1...10{
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        
        let alert = app.alerts["Game results"]
        let alertExists = alert.exists
        let alertButtonText = alert.buttons.firstMatch.label
        let alertLabel = alert.label
        
        XCTAssertTrue(alertExists)
        XCTAssertEqual(alertButtonText, "Сыграть ещё раз")
        XCTAssertEqual(alertLabel, "Этот раунд окончен!")
        
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
