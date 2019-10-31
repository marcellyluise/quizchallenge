//
//  CounterAndTimerView.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 29/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class CounterAndTimerView: XibLoader {

    // MARK: - Properties
    @IBOutlet private weak var startResetButton: UIButton!
    @IBOutlet private weak var wordsCounterLabel: UILabel!
    @IBOutlet private weak var countdownTimerLabel: UILabel! {
        didSet {
            countdownTimerLabel.font = UIFont.monospacedSystemFont(ofSize: countdownTimerLabel.font.pointSize, weight: .bold)
        }
    }

    private var buttonTitle: String? {
        didSet {
            startResetButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    var viewModel: CounterAndTimerViewModel? {
        didSet {
            
            viewModel?.delegate = self
            updateUI()
        }
    }
    
    // MARK: - View Lifecycle
    override func didLoadViewFromXib() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetTimer), name: .resetTimer, object: nil)
    }
    
    // MARK: - Setup UI
    private func updateUI() {
        DispatchQueue.main.async {
            self.startResetButton.setTitle(self.viewModel?.buttonTitle, for: .normal)
            self.wordsCounterLabel.text = self.viewModel?.wordsCounterText
            self.countdownTimerLabel.text = self.viewModel?.coundownTimerText
        }
    }
    
    // MARK: - Start/Reset Timer
    @IBAction func startResetTimer(sender: UIButton) {
        viewModel?.handleTimer()
    }

    @objc private func resetTimer() {
        viewModel?.resetTimer()
    }
}

// MARK: - Counter and Timer View Model Delegate
extension CounterAndTimerView: CounterAndTimerViewModelDelegate {
    func timerDidFinish() {
        NotificationCenter.default.post(name: .timerDidFinish, object: nil)
    }
    
    func reloadUI() {
        updateUI()
    }
    
    func userDidResetTimer() {
        NotificationCenter.default.post(name: .userDidResetTimer, object: nil)
    }
}
