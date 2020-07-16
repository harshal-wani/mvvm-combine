//
//  WordGameViewModel.swift
//  WordGame
//
//  Created by Harshal Wani on 27/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import Combine

enum GameState {
    case loading
    case loaded
    case finished
    case error(APIError)
}

enum AnswerAction {
    case correct
    case wrong
    case notAnswered
}

final class WordGameViewModel: AbstractViewModel {

    /// Local
    private(set) var words: [Word] = []
    private var quesNumber = 0

    ///Publisher and Actions
    @Published var userScore: UserScore = UserScore()
    let gameState = CurrentValueSubject<GameState, Never>(.loading)
    let answerAction = PassthroughSubject<AnswerAction, Never>()

    internal var bindings = Set<AnyCancellable>()

    // MARK: - Init
    override init() {
        super.init()
        answerAction
            .sink(receiveValue: { [weak self] action in
                self?.updateScore(action)
            })
            .store(in: &bindings)
    }

    // MARK: - Private

    /// Check user answers and update score
    /// - Parameter action: Answer type
    private func updateScore(_ action: AnswerAction) {

        let word = self.words[quesNumber]

        switch action {
        case .correct:
            if word.isTranslationCorrect == action {
                userScore.correctCount += 1
            } else {
                userScore.wrongCount += 1
            }
        case .wrong:
            if word.isTranslationCorrect == action {
                userScore.correctCount += 1
            } else {
                userScore.wrongCount += 1
            }
        case .notAnswered:
            userScore.noAnsCount += 1
        }

        if quesNumber != self.words.count-1 {
            quesNumber += 1
            updateQuestion()
        } else {
            self.gameState.value = .finished
        }
    }

    private func updateQuestion() {
        userScore.questionNumber = "\(quesNumber+1)/\(words.count)"
        userScore.langOne = words[quesNumber].langOneWord
        userScore.langTwo = words[quesNumber].langTwoWord
    }

    // MARK: - Public

    /// Get all words API
    /// - Parameter noOfWords: To extract only no of words from received response
    func getWords(extractOnly noOfWords: Int? = 0) {
        gameState.value = .loading

        let completionHandler: (Subscribers.Completion<APIError>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.gameState.value = .error(error)
            case .finished:
                self?.gameState.value = .loaded
                self?.updateQuestion()
            }
        }

        let valueHandler: ([Word]) -> Void = { [weak self] (response) in

            guard !response.isEmpty else {
                self?.gameState.value = .error(APIError.noData)
                return
            }
            // Extract only no of words is valid
            self?.words = (noOfWords != 0)
                ? response.prefix(noOfWords!).map { $0 }
                : response.map { $0 }
        }

        self.apiService.fetch(.words())
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &bindings)
    }
}

struct UserScore {

    var correctCount = 0
    var wrongCount = 0
    var noAnsCount = 0

    var questionNumber = ""
    var langOne = ""
    var langTwo = ""

    init() { }
}
