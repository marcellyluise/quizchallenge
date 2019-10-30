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
}

protocol CounterAndTimerViewModelDataSource: class {
    
}

class CounterAndTimerViewModel {

    private(set) var numberOfTypedWords: Int
    private(set) var numberOfExpectedWords: Int
    
    private var timer: Timer?
    
    weak var delegate: CounterAndTimerViewModelDelegate?
    weak var dataSource: CounterAndTimerViewModelDataSource?
    
    init(numberOfExpectedWords: Int, numberOfTypedWords: Int) {
        self.numberOfTypedWords = numberOfTypedWords
        self.numberOfExpectedWords = numberOfExpectedWords
        
        self.addNotification()
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("UpdateUI"), object: nil)
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
    
    private func resetTimer() {
        TimerManager.shared.resetTimer()
        
        updateUI()
    }
    
    @objc private func updateUI() {
        
        DispatchQueue.main.async {
            self.delegate?.reloadUI()
        }
    }

}

class TimerManager {
    
    static let shared = TimerManager()
    
    private var timer: Timer?
    private var timeLimit: TimeInterval = 0
    private var timeElapsed: TimeInterval = 0
    
    var currentTimerValue: TimeInterval {
        return timeElapsed
    }
    
    var currentTimeString: String {
        return timeElapsed.countdownString()
    }
    
    var timerIsValid: Bool {
        return timer?.isValid ?? false
    }
    
    private init() {
        
    }
    
    func startTimer(with timeLimit: TimeInterval) {
        self.timeLimit = timeLimit
        self.timeElapsed = timeLimit
        
        if !timerIsValid {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerCountdown), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    func resetTimer() {
        
        timer?.invalidate()
        timer = nil
        
        timeElapsed = timeLimit
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UpdateUI"), object: nil)
    }
    
    @objc private func updateTimerCountdown() {
        timeElapsed -= 1
        
        NotificationCenter.default.post(name: Notification.Name("UpdateUI"), object: nil)
    }
    
}


