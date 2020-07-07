//
//  WordGameTests.swift
//  WordGameTests
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import XCTest
@testable import WordGame

final class WordGameTests: XCTestCase {

    func testIsInternetAvailable() {
        if Utilities.isInternetAvailable() {
            XCTAssertTrue(Utilities.isInternetAvailable())
        } else {
            XCTAssertFalse(Utilities.isInternetAvailable())
        }
    }
}

final class WordGameViewModelTest: XCTestCase {

    func testWordViewModel() {

        let word = Word(langOneWord: "primary school", langTwoWord: "escuela primaria")
        let wordVM = WordViewModel(word: word)
        XCTAssertEqual(wordVM.langOneWord, "primary school")
        XCTAssertEqual(wordVM.langTranslatedWord, "escuela primaria")
    }

    func testWordListNotEmpty() throws {

        let jsonData = """
                [
                {
                  "text_eng":"primary school",
                  "text_spa":"escuela primaria"
                },
                {
                  "text_eng":"teacher",
                  "text_spa":"profesor / profesora"
                }
                ]
                """.data(using: .utf8)!

        let wordList = try JSONDecoder().decode([Word].self, from: jsonData)
        XCTAssertFalse(wordList.isEmpty)
    }

    func testWordListParcer() throws {

        let jsonData = try Data(contentsOf: Bundle.main.url(forResource: "words", withExtension: "json")!)
        XCTAssertNoThrow(try JSONDecoder().decode([Word].self, from: jsonData))
    }

    func testEmptyWordList() throws {

        let jsonData = """
                       []
                       """.data(using: .utf8)!

        let wordList = try JSONDecoder().decode([Word].self, from: jsonData)
        XCTAssertTrue(wordList.isEmpty)

    }

    func testExtractWordsCount() {

        //1. Given
        let expect = XCTestExpectation(description: "get words API called and count updated successfully")
        let wordGameVM = WordGameViewModel()

        //2.
        wordGameVM.getWords(extractOnly: 10)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //3. Then
            expect.fulfill()
            XCTAssertEqual(wordGameVM.wordViewModels.count, 10)
        }
        wait(for: [expect], timeout: 10.0)
    }
}
