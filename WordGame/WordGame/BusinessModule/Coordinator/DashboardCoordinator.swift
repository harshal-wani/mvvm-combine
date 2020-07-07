//
//  DashboardCoordinator.swift
//  WordGame
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit

final class DashboardCoordinator: Coordinator {

    private var presenter: UINavigationController
    private var dashViewController: DashboardViewController?
    private var wordGameCoordinator: WordGameCoordinator?

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let dashViewController = DashboardViewController.instantiate()
        dashViewController.dashVCDelegate = self
        self.dashViewController = dashViewController
        presenter.pushViewController(dashViewController, animated: true)
    }
}

extension DashboardCoordinator: DhashboardVCDelegate {

    func gameVC(_ controller: DashboardViewController, noOfwords: Int) {
        let wordGameCoordinator = WordGameCoordinator(presenter: presenter, noOfWords: noOfwords)
        self.wordGameCoordinator = wordGameCoordinator
        wordGameCoordinator.start()

    }
}
