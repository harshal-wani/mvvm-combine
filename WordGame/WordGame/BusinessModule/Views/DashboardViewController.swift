//
//  DashViewController.swift
//  WordGame
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit
import Combine

protocol DhashboardVCDelegate: class {
    func gameVC(_ controller: DashboardViewController, noOfwords: Int)
}

final class DashboardViewController: UIViewController, Storyboarded {

    @IBOutlet weak var optionOneButton: UIButton!
    @IBOutlet weak var optionTwoButton: UIButton!
    @IBOutlet weak var optionThreeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    /// Local
    weak var dashVCDelegate: DhashboardVCDelegate?
    private lazy var viewModel: DashboardViewModel = {
        return DashboardViewModel()
    }()
    private var cancelables: [AnyCancellable] = []

    // MARK: - View life cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizableStrings.dashboardScreenTitle
        self.setUpBindings()

    }

    // MARK: - Actions
    @IBAction func wordsNumButtonTapped(_ sender: UIButton) {

        switch sender.tag {
        case 1:
            viewModel.buttonAction.send(.oneWords)
        case 2:
            viewModel.buttonAction.send(.twoWords)
        case 3:
            viewModel.buttonAction.send(.threeWords)
        default:
            break
        }
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.dashVCDelegate?.gameVC(self, noOfwords: viewModel.selectedWordCount.value)
    }
}

extension DashboardViewController {

    // MARK: - Private
    private func setUpBindings() {

        self.cancelables = [
            viewModel.btnArr.sink(receiveValue: { [weak self] arr in
                self?.optionOneButton.setTitle(arr?[0], for: .normal)
                self?.optionTwoButton.setTitle(arr?[1], for: .normal)
                self?.optionThreeButton.setTitle(arr?[2], for: .normal)
            }),
            viewModel.buttonEnabled.assign(to: \.isEnabled, on: startButton)
        ]
    }
}
