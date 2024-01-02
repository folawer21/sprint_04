//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Александр  Сухинин on 17.12.2023.
//


import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1,2,3,4,5]
        
        let item = array[2]
        
        XCTAssertNotNil(item)
        XCTAssertEqual(item, 3)
    }
    
    func testGetValueOutOfRange() throws{
        let array = [1,2,3,4,5]
        
        let item = array[safe:10]
        
        XCTAssertNil(item)
    }
    
    
}
