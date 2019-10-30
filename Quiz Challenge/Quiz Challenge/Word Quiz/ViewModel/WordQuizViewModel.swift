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
    func shouldStartTimer()
    func shoudResetTimer()
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
//        return quiz?.answer?.count ?? 0
        return 5
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
        userDidBeginToType = typedWords.count == 0
    }
    
    func addAnswer(with word: String?) {
        
        guard let word = word, word != "" else {
            return
        }
        
        handleGameStart()
        
        typedWords.insert(word, at: 0)
        
        if didTypeAllWords() {
            delegate?.didCompleteQuizOnTime()
            shouldResetTimer = true
            delegate?.shoudResetTimer()
        }
    }
    
    func resetAnswers() {
        typedWords.removeAll()
        shouldResetTimer = false
    }
    
    func verifyQuizResult(with timer: TimeInterval) -> QuizResult {
        if didTypeAllWords() && didFinishOnTime(currentTimer: timer) {
            return .completed
        } else {
            return .notFinished
        }
    }
    
    func playAgain() {
        shouldResetTimer = true
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

