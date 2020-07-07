//
//  DashboardViewModel.swift
//  WordGame
//
//  Created by Harshal Wani on 28/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import Foundation
import Combine

final class DashboardViewModel {

    /// Local
    enum OptionAction {
        case idle
        case oneWords
        case twoWords
        case threeWords
    }

    ///Publisher and Actions
    let btnArr = CurrentValueSubject<[String]?, Never>(nil)
    let buttonEnabled = CurrentValueSubject<Bool, Never>(false)
    let selectedWordCount = CurrentValueSubject<Int, Never>(0)

    let buttonAction = CurrentValueSubject<OptionAction, Never>(.idle)
    private var bindings = Set<AnyCancellable>()

    // MARK: - Init
    init() {

        buttonAction.sink(receiveValue: { [weak self] action in
            self?.processAction(action)
        })
            .store(in: &bindings)
    }
    // MARK: - Private
    private func processAction(_ action: OptionAction) {

        switch action {

        case .idle:
            selectedWordCount.value = 0
            btnArr.value = [LocalizableStrings.oneWords, LocalizableStrings.twoWords, LocalizableStrings.threeWords]
            buttonEnabled.value = false

        case .oneWords:
            selectedWordCount.value = 10
            btnArr.value = ["✓ \(LocalizableStrings.oneWords)",
                LocalizableStrings.twoWords,
                LocalizableStrings.threeWords]
            buttonEnabled.value = true

        case .twoWords:
            selectedWordCount.value = 20
            btnArr.value = [LocalizableStrings.oneWords,
                            "✓ \(LocalizableStrings.twoWords)",
                LocalizableStrings.threeWords]
            buttonEnabled.value = true

        case .threeWords:
            selectedWordCount.value = 30
            btnArr.value = [LocalizableStrings.oneWords,
                            LocalizableStrings.twoWords,
                            "✓ \(LocalizableStrings.threeWords)"]
            buttonEnabled.value = true
        }
    }
}
