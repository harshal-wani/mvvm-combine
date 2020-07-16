//
//  WordGameViewController.swift
//  WordGame
//
//  Created by Harshal Wani on 26/06/20.
//  Copyright © 2020 Harshal Wani. All rights reserved.
//

import UIKit
import Combine

protocol WordGameVCDelegate: class {
    func back()
}

final class WordGameViewController: UIViewController, Storyboarded {

    /// Outlet
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var notAnsLabel: UILabel!

    @IBOutlet weak var quesTotalLabel: UILabel!
    @IBOutlet weak var langWordLabel: UILabel!
    @IBOutlet weak var translatedWordLabel: UILabel!
    @IBOutlet weak var correctAnsButton: UIButton!
    @IBOutlet weak var wrongAnsButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    /// Local
    internal var noOfWords: Int?
    private lazy var viewModel: WordGameViewModel = {
        return WordGameViewModel()
    }()
    weak var wordGameVCDelegate: WordGameVCDelegate?
    private var translatedTextObserver: NSKeyValueObservation?
    private var isAnswered: Bool = false
    private var animator: UIViewPropertyAnimator?

    /// Publishers and Actions
    private var bindings = Set<AnyCancellable>()

    // MARK: - View life cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBindings()
        self.viewModel.getWords(extractOnly: self.noOfWords)
        self.registerTextChangeObserver()
    }

    // MARK: - Actions
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        self.translatedWordLabel.layer.removeAllAnimations()
        isAnswered = true
        viewModel.answerAction.send(sender.tag == 1 ? .correct : .wrong)
    }

    @IBAction func quitButtonTapped(_ sender: UIButton) {
        UIAlertController.showAlert(title: LocalizableStrings.alert,
                                    message: LocalizableStrings.quitGame,
                                    cancelButton: LocalizableStrings.cancel,
                                    otherButtons: [LocalizableStrings.yes]) { [weak self] str in
                                        if str == LocalizableStrings.yes {
                                            self?.viewModel.bindings.removeAll()
                                            self?.wordGameVCDelegate?.back()
                                        }
        }
    }
}

extension WordGameViewController {

    // MARK: - Private
    private func setUpBindings() {

        bindViewModelToView()
        bindViewToViewModel()
    }

    private func bindViewModelToView() {

        let gameStateValueHandler: (GameState) -> Void  = { [weak self] state in
            switch state {
            case .loading:
                self?.updateUI(enable: false)
            case .loaded:
                self?.updateUI(enable: true)
            case .finished:
                self?.viewModel.bindings.removeAll()
                UIAlertController.showAlert(title: LocalizableStrings.awesome,
                                            message: LocalizableStrings.gameFinishedMessage,
                                            cancelButton: LocalizableStrings.ok) { _ in
                                                self?.wordGameVCDelegate?.back()
                }
            case .error(let error):
                UIAlertController.showAlert(title: LocalizableStrings.error,
                                            message: error.rawValue,
                                            cancelButton: LocalizableStrings.ok) { _ in
                                                self?.wordGameVCDelegate?.back()
                }
            }
        }

        viewModel.gameState
            .receive(on: RunLoop.main)
            .sink(receiveValue: gameStateValueHandler)
            .store(in: &bindings)
    }

    private func bindViewToViewModel() {

        viewModel.$userScore
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] score in
                print(score)
                self?.correctLabel.text = score.correctCount.description
                self?.wrongLabel.text = score.wrongCount.description
                self?.notAnsLabel.text = score.noAnsCount.description
                self?.quesTotalLabel.text = score.questionNumber
                self?.langWordLabel.text = score.langOne
                self?.translatedWordLabel.text = score.langTwo
            })
            .store(in: &bindings)

    }

    /// Register translatedWordLabel text change observer and animate it
    private func registerTextChangeObserver() {

        translatedTextObserver = translatedWordLabel.observe(\.text) { [weak self] (label, _) in
            if label.text != "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.animateFallDown { status in
                        if !status {
                            self?.viewModel.answerAction.send(.notAnswered)
                        }
                    }
                }
            }
        }
    }

    /// Animate words to falling down to bottom of screen
    private func animateFallDown(isAnimationAutoFinished completion: @escaping (Bool) -> Void) {
        isAnswered = false
        translatedWordLabel.layer.removeAllAnimations()
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear) {
            self.translatedWordLabel.center.y = UIScreen.main.bounds.size.height
        }
        animator?.addCompletion { _ in
            self.translatedWordLabel.center.y = self.translatedWordLabel.frame.origin.y
            completion(self.isAnswered)
        }
        animator?.startAnimation()
    }

    private func updateUI(enable: Bool) {

        self.correctAnsButton.isEnabled = enable
        self.wrongAnsButton.isEnabled = enable

        if enable {
            self.activityIndicatorView.stopAnimating()
        } else {
            self.activityIndicatorView.startAnimating()
        }
    }
}
