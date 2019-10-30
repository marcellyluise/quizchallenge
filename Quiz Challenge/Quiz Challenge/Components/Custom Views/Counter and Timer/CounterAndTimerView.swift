//
//  CounterAndTimerView.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 29/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

protocol CounterAndTimerDataSource: class {
    func numberOfTypedWords() -> Int
    func totalOfWords() -> Int
    func shouldStartTimer() -> Bool
}

protocol CounterAndTimerViewDelegate: class {
    func didTapStartTimer()
    func didTapResetTimer()
    func timerDidEnd()
}

class CounterAndTimerView: XibLoader {

    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var wordsCounterLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel! {
        didSet {
            countdownTimerLabel.font = UIFont.monospacedSystemFont(ofSize: countdownTimerLabel.font.pointSize, weight: .bold)
        }
    }
    
    private var timer: Timer?
    private var gameLimit = Double.fiveMinutes
    
    weak var delegate: CounterAndTimerViewDelegate?
    weak var dataSource: CounterAndTimerDataSource? {
        didSet {
            setupDataSource()
        }
    }

    private var numberOfTypedWords: Int {
        return dataSource?.numberOfTypedWords() ?? 0
    }
    
    private var totalOfWords: Int {
        return dataSource?.totalOfWords() ?? 0
    }
    
    @IBAction func startResetTimer(sender: UIButton) {
        handlerTimer()
    }
    
    private func setupDataSource() {
        wordsCounterLabel.text = "\(numberOfTypedWords)/\(totalOfWords)"
        
        if let shouldStartTime = dataSource?.shouldStartTimer(), shouldStartTime {
            startTimer()
        }
        
    }
    
    func reloadCounterAndTimerData() {
        setupDataSource()
    }
 
    private func handlerTimer() {
        if timer == nil {
            startTimer()
        } else {
            resetTimer()
        }
    }
    
    private func startTimer() {
        if timer == nil {
            gameLimit = Double.fiveMinutes
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
            
            timer?.fire()
        }
    }
    
    @objc private func updateCountdownLabel() {
        DispatchQueue.main.async {
            self.gameLimit -= 1.0
            self.countdownTimerLabel.text = self.gameLimit.countdownString()
            
            if self.gameLimit == 0 {
                self.pauseTimer()
                self.delegate?.timerDidEnd()
            }
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        gameLimit = Double.fiveMinutes
        
        DispatchQueue.main.async {
            self.countdownTimerLabel.text = "05:00"
        }
        
    }
    
    private func pauseTimer() {
        timer?.invalidate()
    }

}
