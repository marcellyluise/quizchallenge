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
    
    weak var delegate: WordQuizViewModelDelegate?
    
    init() {
        self.fetchWordQuiz()
    }
    
}

// MARK: - Service
extension WordQuizViewModel {
    
    private func fetchWordQuiz() {
        
        delegate?.isLoading(isLoading: true)
        
        Service().fetchQuiz { (fetchedQuiz, error) in
            
            self.delegate?.isLoading(isLoading: false)
            
            self.quiz = fetchedQuiz
        }
    }
    
}

