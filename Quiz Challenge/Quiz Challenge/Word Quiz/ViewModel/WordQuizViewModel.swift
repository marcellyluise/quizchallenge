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
    
    func didCompleteQuizOnTime()
    func didNotFinishQuiz()
    
    func shouldStartTimer()
    func shouldResetTimer()
    func shouldPauseTimer()
    func shouldUpdateWordsCounter()
    func userDidResetQuiz()
}

class WordQuizViewModel {

    private var quiz: Quiz?
    private(set) var typedWords: [String] = []
    
    var question: String? {
        return quiz?.question
    }
 
    var numberOfWordsTyped: Int {
        return typedWords.count
    }
    
    var expectedNumberOfWords: Int {
        return quiz?.answer?.count ?? 50
    }
    
    private(set) var shouldResetTimer: Bool = false
    private(set) var userDidBeginToType: Bool = false
    
    weak var delegate: WordQuizViewModelDelegate?
    
    init(delegate: WordQuizViewModelDelegate?) {
        self.delegate = delegate
        
        DispatchQueue.main.async {
            self.delegate?.isLoading(isLoading: true)
        }
        
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(fetchWordQuiz), userInfo: nil, repeats: false)
    }
    
}

// MARK: - Quiz Result
enum QuizResult {
    case completed
    case notFinished
}

// MARK: - Business Rule
extension WordQuizViewModel {
    private func handleGameStart() {
        if typedWords.count == 0 {
            delegate?.shouldStartTimer()
        }
    }
    
    func addAnswer(with word: String?) {
        
        guard let word = word, word != "" else {
            return
        }
        
        handleGameStart()
        
        typedWords.insert(word, at: 0)
        
        if didTypeAllWords() {
            delegate?.didCompleteQuizOnTime()
            delegate?.shouldPauseTimer()
        }
        
        delegate?.shouldUpdateWordsCounter()
    }
    
    func verifyQuizResult(with timer: TimeInterval) -> QuizResult {
        if didTypeAllWords() && didFinishOnTime(currentTimer: timer) {
            return .completed
        } else {
            return .notFinished
        }
    }
    
    func playAgain() {
        typedWords.removeAll()
        delegate?.shouldResetTimer()
    }
    
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
    
    private func didTypeAllWords() -> Bool {
        return numberOfWordsTyped == expectedNumberOfWords
    }
    
    private func didFinishOnTime(currentTimer: TimeInterval) -> Bool {
        return currentTimer > 0
    }
}

// MARK: - Service
extension WordQuizViewModel {
    
    @objc private func fetchWordQuiz() {
//        DispatchQueue.main.async {
//            self.delegate?.isLoading(isLoading: true)
//        }
        
        Service().fetchQuiz { (fetchedQuiz, error) in
            
            DispatchQueue.main.async {
                self.quiz = fetchedQuiz
                self.delegate?.isLoading(isLoading: false)
            }
        }
    }
    
}
