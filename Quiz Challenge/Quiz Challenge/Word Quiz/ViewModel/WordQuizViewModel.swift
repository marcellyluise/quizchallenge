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
    
    var question: String? {
        return quiz?.question
    }
    
    var words: [String]? {
        return quiz?.answer
    }
    
    var counter: Int {
        return answers.count
    }
    
    private(set) var answers: [String] = []
    
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
        
        answers.append(word)
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

