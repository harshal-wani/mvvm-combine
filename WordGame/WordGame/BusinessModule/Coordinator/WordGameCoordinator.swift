//
//  WordGameCoordinator.swift
//  WordGame
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit

final class WordGameCoordinator: Coordinator {

    private var presenter: UINavigationController
    private var wordGameViewController: WordGameViewController?
    private let noOfWords: Int

    init(presenter: UINavigationController, noOfWords: Int) {
        self.presenter = presenter
        self.noOfWords = noOfWords
        self.presenter.navigationBar.isHidden = true
    }

    func start() {

        let wordGameViewController = WordGameViewController.instantiate()
        wordGameViewController.noOfWords = noOfWords
        wordGameViewController.wordGameVCDelegate = self
        self.wordGameViewController = wordGameViewController
        presenter.pushViewController(wordGameViewController, animated: true)
    }
}

extension WordGameCoordinator: WordGameVCDelegate {

    func back() {
        presenter.popViewController(animated: true)
    }
}
