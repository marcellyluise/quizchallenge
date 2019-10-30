//
//  CounterAndTimerView.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 29/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

extension Notification {
    static let timerDidFinish = Notification.Name("TimerDidFinish")
}


class CounterAndTimerView: XibLoader {

    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var wordsCounterLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel! {
        didSet {
            countdownTimerLabel.font = UIFont.monospacedSystemFont(ofSize: countdownTimerLabel.font.pointSize, weight: .bold)
        }
    }

    var viewModel: CounterAndTimerViewModel? {
        didSet {
            
            viewModel?.delegate = self
            updateUI()
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.startResetButton.setTitle(self.viewModel?.buttonTitle, for: .normal)
            self.wordsCounterLabel.text = self.viewModel?.wordsCounterText
            self.countdownTimerLabel.text = self.viewModel?.coundownTimerText
        }
        
    }
    
    private var buttonTitle: String? {
        didSet {
            startResetButton.setTitle(buttonTitle, for: .normal)
        }
    }

    @IBAction func startResetTimer(sender: UIButton) {
        viewModel?.handleTimer()
    }

    override func didLoadViewFromXib() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetTimer), name: Notification.Name("ResetTimer"), object: nil)
    }

    
    @objc private func resetTimer() {
        viewModel?.resetTimer()
    }
}

extension CounterAndTimerView: CounterAndTimerViewModelDelegate {
    func timerDidFinish() {
        NotificationCenter.default.post(name: Notification.Name("TimerDidFinish"), object: nil)
        
    }
    
    func reloadUI() {
        updateUI()
    }
}
