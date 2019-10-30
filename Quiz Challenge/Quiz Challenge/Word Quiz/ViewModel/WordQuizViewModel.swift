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
    
    private(set) var userDidBeginToType: Bool = false
    
    weak var delegate: WordQuizViewModelDelegate?
    
    init(delegate: WordQuizViewModelDelegate?) {
        self.fetchWordQuiz()
        self.delegate = delegate
    }
    
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
    }
    
    func resetAnswers() {
        typedWords.removeAll()
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

