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
}

protocol CounterAndTimerViewModelDataSource: class {
    
}

class CounterAndTimerViewModel {

    private(set) var numberOfTypedWords: Int
    private(set) var numberOfExpectedWords: Int
    
    weak var delegate: CounterAndTimerViewModelDelegate?
    weak var dataSource: CounterAndTimerViewModelDataSource?
    
    init(numberOfExpectedWords: Int, numberOfTypedWords: Int) {
        self.numberOfTypedWords = numberOfTypedWords
        self.numberOfExpectedWords = numberOfExpectedWords
        
        self.addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("UpdateUI"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerDidFinish), name: Notification.Name("TimeDidFinish"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: Notification.Name("PauseTimer"), object: nil)
    }
    
    var wordsCounterText: String {
        return "\(numberOfTypedWords)/\(numberOfExpectedWords)"
    }
    
    var coundownTimerText: String {
        return TimerManager.shared.currentTimeString
    }
    
    var buttonTitle: String {
        return TimerManager.shared.timerIsValid ? "Reset" : "Start"
    }
    
    func didTapPlayAgain() {
        resetTimer()
        
        updateUI()
    }
    
    @objc private func pauseTimer() {
        TimerManager.shared.pauseTimer()
    }
    
    func handleTimer() {
        if TimerManager.shared.timerIsValid {
            resetTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        TimerManager.shared.startTimer(with: Double.fiveMinutes)
        
        updateUI()
    }
    
    func resetTimer() {
        TimerManager.shared.resetTimer()
        
        updateUI()
    }
    
    @objc private func timerDidFinish() {
        delegate?.timerDidFinish()
    }
    
    @objc private func updateUI() {
        
        DispatchQueue.main.async {
            self.delegate?.reloadUI()
        }
    }

}
