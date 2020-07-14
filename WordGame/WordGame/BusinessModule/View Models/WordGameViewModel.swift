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
    private(set) var wordViewModels: [WordViewModel] = []
    private var quesNumber = 0

    ///Publisher and Actions
    let correctAnsCount = CurrentValueSubject<Int, Never>(0)
    let wrongAnsCount = CurrentValueSubject<Int, Never>(0)
    let notAnsCount = CurrentValueSubject<Int, Never>(0)

    let quesTotal = CurrentValueSubject<String?, Never>(nil)
    let langOne = CurrentValueSubject<String?, Never>(nil)
    let langTwo = CurrentValueSubject<String?, Never>(nil)

    let gameState = CurrentValueSubject<GameState, Never>(.loading)
    let answerAction = PassthroughSubject<AnswerAction, Never>()

    internal var bindings = Set<AnyCancellable>()

    // MARK: - Init
    override init() {
        super.init()

        answerAction.sink(receiveValue: { [weak self] action in
            self?.updateScore(action)
        })
            .store(in: &bindings)
    }

    // MARK: - Private

    /// Check user answers and update score
    /// - Parameter action: Answer type
    private func updateScore(_ action: AnswerAction) {

        let wordViewModel = self.wordViewModels[quesNumber]

        switch action {
        case .correct:
            if wordViewModel.isTranslationCorrect == action {
                correctAnsCount.value += 1
            } else {
                wrongAnsCount.value += 1
            }
        case .wrong:
            if wordViewModel.isTranslationCorrect == action {
                correctAnsCount.value += 1
            } else {
                wrongAnsCount.value += 1
            }
        case .notAnswered:
            notAnsCount.value += 1
        }

        if quesNumber != self.wordViewModels.count-1 {
            quesNumber += 1
            updateQuestion()
        } else {
            self.gameState.value = .finished
        }
    }

    private func updateQuestion() {
        quesTotal.value = "\(quesNumber+1)/\(wordViewModels.count)"
        langOne.value = wordViewModels[quesNumber].langOneWord
        langTwo.value = wordViewModels[quesNumber].langTranslatedWord
    }

    // MARK: - Public

    /// Get all words API
    /// - Parameter noOfWords: To extract only no of words from received response
    func getWords(extractOnly noOfWords: Int? = 0) {
        gameState.value = .loading

        let wordsCompletionHandler: (Subscribers.Completion<APIError>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.gameState.value = .error(error)
            case .finished:
                self?.gameState.value = .loaded
                self?.updateQuestion()
            }
        }

        let wordsValueHandler: (Data) -> Void = { [weak self] (data) in
            do {
                let response = try JSONDecoder().decode([Word].self, from: data)

                guard !response.isEmpty else {
                    self?.gameState.value = .error(APIError.noData)
                    return
                }
                // Extract only no of words is valid
                self?.wordViewModels = (noOfWords != 0) ? response.prefix(noOfWords!).map {
                    WordViewModel(word: $0) } : response.map { WordViewModel(word: $0)
                }

            } catch {
                self?.gameState.value = .error(APIError.decodeError)
            }
        }

        self.apiService.fetch(.words())
            .sink(receiveCompletion: wordsCompletionHandler, receiveValue: wordsValueHandler)
            .store(in: &bindings)
    }
}

struct WordViewModel {

    let langOneWord: String
    let langTranslatedWord: String
    let isTranslationCorrect: AnswerAction

    init(word: Word) {
        langOneWord = word.langOneWord
        langTranslatedWord = word.langTwoWord

        //IMPORTANT: Set is translation true/false randomly
        isTranslationCorrect = (Bool.random() == true) ? .correct : .wrong
    }
}
