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
    func shoudResetTimer()
    func shouldPauseTimer()
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
        return quiz?.answer?.count ?? 0
    }
    
    private(set) var shouldResetTimer: Bool = false
    private(set) var userDidBeginToType: Bool = false
    
    weak var delegate: WordQuizViewModelDelegate?
    
    init(delegate: WordQuizViewModelDelegate?) {
        self.fetchWordQuiz()
        self.delegate = delegate
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
        
        if didTypeAllWords() {
            delegate?.didCompleteQuizOnTime()
            delegate?.shouldPauseTimer()
        }
        
        typedWords.insert(word, at: 0)

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
        delegate?.shoudResetTimer()
    }
    
    func timerDidFinish() {
        if didTypeAllWords() {
            delegate?.didCompleteQuizOnTime()
        } else {
            delegate?.didNotFinishQuiz()
        }
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
    
    private func fetchWordQuiz() {
        
        delegate?.isLoading(isLoading: true)
        
        Service().fetchQuiz { (fetchedQuiz, error) in
            
            self.quiz = fetchedQuiz
            
            self.delegate?.isLoading(isLoading: false)
        }
    }
    
}
