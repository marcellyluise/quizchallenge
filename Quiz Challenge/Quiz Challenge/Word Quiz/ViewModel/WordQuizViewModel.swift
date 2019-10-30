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
    
    weak var delegate: WordQuizViewModelDelegate?
    
    init(delegate: WordQuizViewModelDelegate?) {
        self.fetchWordQuiz()
        self.delegate = delegate
    }
    
}

// MARK: - Business Rule
extension WordQuizViewModel {
    func addAnswer(with word: String?) {
        
        guard let word = word, word != "" else {
            return
        }
        
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

