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
}

protocol CounterAndTimerViewDelegate: class {
    func didTapStartTimer()
    func didTapResetTimer()
}

class CounterAndTimerView: XibLoader {

    @IBOutlet weak var startResetButton: UIButton!
    @IBOutlet weak var wordsCounterLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    
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
        
    }
    
    private func setupDataSource() {
        wordsCounterLabel.text = "\(numberOfTypedWords)/\(totalOfWords)"
    }
    
    func reloadCounterAndTimerData() {
        setupDataSource()
    }
    
}
