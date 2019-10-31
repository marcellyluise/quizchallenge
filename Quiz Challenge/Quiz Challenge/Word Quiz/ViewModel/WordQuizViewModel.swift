//
//  WordQuizViewModel.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import Foundation

protocol WordQuizViewModelDelegate: class {
    func isLoading(isLoading: Bool)
    func serviceDidFail(with error: ServiceError)
    
    func didCompleteQuizOnTime()
    func didNotFinishQuiz()
    
    func shouldStartTimer()
    func shouldResetTimer()
    func shouldPauseTimer()
    func shouldUpdateWordsCounter()
    func userDidResetQuiz()
}

class WordQuizViewModel {

    // MARK: - Properties
    private var quiz: Quiz?
    
    private(set) var typedWords: [String] = []
    private(set) var shouldResetTimer: Bool = false
    private(set) var userDidBeginToType: Bool = false
    
    var question: String? {
        return quiz?.question
    }
 
    var numberOfWordsTyped: Int {
        return typedWords.count
    }
    
    var expectedNumberOfWords: Int {
        return quiz?.answer?.count ?? 50
    }
    
    weak var delegate: WordQuizViewModelDelegate?
    
    // MARK: - Init
    init(delegate: WordQuizViewModelDelegate?) {
        self.delegate = delegate
        
        addDelayToViewActivityIndicatorWorking()
    }
    
}

// MARK: - Quiz Enum State

enum QuizResult {
    case completed
    case notFinished
}

// MARK: - Business Rule

extension WordQuizViewModel {
    
    // MARK: Add Delay
    private func addDelayToViewActivityIndicatorWorking() {
        DispatchQueue.main.async {
            self.delegate?.isLoading(isLoading: true)
        }
        
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(fetchWordQuiz), userInfo: nil, repeats: false)
    }
    
    // MARK: Start Quiz
    private func HandleQuizStart() {
        if typedWords.count == 0 {
            delegate?.shouldStartTimer()
        }
    }
    
    // MARK: Add Answer
    func addAnswer(with word: String?) {
        
        guard let word = word, word != "" else {
            return
        }
        
        HandleQuizStart()
        
        typedWords.insert(word, at: 0)
        
        if didTypeAllWords() {
            delegate?.didCompleteQuizOnTime()
            delegate?.shouldPauseTimer()
        }
        
        delegate?.shouldUpdateWordsCounter()
    }
    
    // MARK: Check Results
    func verifyQuizResult(with timer: TimeInterval) -> QuizResult {
        if didTypeAllWords() && didFinishOnTime(currentTimer: timer) {
            return .completed
        } else {
            return .notFinished
        }
    }
    
    private func didTypeAllWords() -> Bool {
        return numberOfWordsTyped == expectedNumberOfWords
    }
    
    private func didFinishOnTime(currentTimer: TimeInterval) -> Bool {
        return currentTimer > 0
    }
    
    // MARK: Play Again
    func playAgain() {
        typedWords.removeAll()
        delegate?.shouldResetTimer()
    }
    
    // MARK: - Timer
    func timerDidFinish() {
        if didTypeAllWords() {
            delegate?.didCompleteQuizOnTime()
        } else {
            delegate?.didNotFinishQuiz()
        }
    }
    
    func userDidResetTimer() {
        typedWords.removeAll()
        delegate?.userDidResetQuiz()
    }

}

// MARK: - Service
extension WordQuizViewModel {
    
    @objc private func fetchWordQuiz() {
        
        Service().fetchQuiz { (fetchedQuiz, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.isLoading(isLoading: false)
                    self.delegate?.serviceDidFail(with: error)
                }
            } else {
                DispatchQueue.main.async {
                    self.quiz = fetchedQuiz
                    self.delegate?.isLoading(isLoading: false)
                }
            }
        }
    }
    
}
