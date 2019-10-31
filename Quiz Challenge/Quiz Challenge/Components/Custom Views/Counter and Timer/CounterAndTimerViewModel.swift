//
//  CounterAndTimerViewModel.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 30/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

protocol CounterAndTimerViewModelDelegate: class {
    func reloadUI()
    func timerDidFinish()
    func userDidResetTimer()
}

class CounterAndTimerViewModel {

    // MARK: Properties
    
    private(set) var numberOfTypedWords: Int
    private(set) var numberOfExpectedWords: Int
    
    var wordsCounterText: String {
        return String(format: "%0.2d/%0.2d", numberOfTypedWords, numberOfExpectedWords)
    }
    
    var coundownTimerText: String {
        return TimerManager.shared.currentTimeString
    }
    
    var buttonTitle: String {
        return TimerManager.shared.timerIsValid ? "Reset" : "Start"
    }
    
    weak var delegate: CounterAndTimerViewModelDelegate?
    
    
    // MARK: - Init
    init(numberOfExpectedWords: Int, numberOfTypedWords: Int) {
        self.numberOfTypedWords = numberOfTypedWords
        self.numberOfExpectedWords = numberOfExpectedWords
        
        self.addObservers()
    }
    
    // MARK: - Deinit
    deinit {
        removeObservers()
    }
    
    func didTapPlayAgain() {
        resetTimer()
        
        updateUI()
    }
    
    // MARK: - Update UI
    @objc private func updateUI() {
        
        DispatchQueue.main.async {
            self.delegate?.reloadUI()
        }
    }
}

// MARK: - Features

extension CounterAndTimerViewModel {
    
    // MARK: Timer
    func handleTimer() {
        if TimerManager.shared.timerIsValid {
            resetTimer()
        } else {
            startTimer()
        }
    }
    
    @objc private func startTimer() {
        TimerManager.shared.startTimer(with: Double.fiveMinutes)
        
        updateUI()
    }
    
    @objc private func pauseTimer() {
        TimerManager.shared.pauseTimer()
    }
    
    func resetTimer() {
        TimerManager.shared.resetTimer()
        
        delegate?.userDidResetTimer()
    }
    
    @objc private func timerDidFinish() {
        delegate?.timerDidFinish()
    }
}

// MARK: - Observers

extension CounterAndTimerViewModel {
    
    // MARK: Add Observers
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .updateUI, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerDidFinish), name: .timerManagerDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: .pauseTimer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startTimer), name: .startTimer, object: nil)
    }
    
    // MARK: Hide Observers
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .updateUI, object: nil)
        NotificationCenter.default.removeObserver(self, name: .timerManagerDidFinish, object: nil)
        NotificationCenter.default.removeObserver(self, name: .pauseTimer, object: nil)
        NotificationCenter.default.removeObserver(self, name: .startTimer, object: nil)
    }
}
