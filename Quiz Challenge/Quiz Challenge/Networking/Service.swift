//
//  Service.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

enum ServiceError: Error {
    case endpointInvalid
    case errorMessage(message: String?)
    case errorStatusCode(statusCode: Int)
    case unknown
    case emptyData
}

class Service {
    
    typealias QuizCompletion = (Quiz?, ServiceError?) -> Void
    
    func fetchQuiz(with completionHandler: @escaping QuizCompletion) {
        
        guard let baseURL = URL(string: "https://codechallenge.arctouch.com/quiz/1") else {
            completionHandler(nil, ServiceError.endpointInvalid)
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: baseURL) { data, response, error in
            
            if let error = error {
                completionHandler(nil, ServiceError.errorMessage(message: error.localizedDescription))
                
                return
            }
            
            guard let successfullHTTPResponseStatusCode = response as? HTTPURLResponse,
                (200...299).contains(successfullHTTPResponseStatusCode.statusCode) else {
                
                    
                    completionHandler(nil, ServiceError.unknown)
                    
                    return
            }
            
            do {
                
                if let fetchData = data {
                    let quiz = try JSONDecoder().decode(Quiz.self, from: fetchData)
                    
                   completionHandler(quiz, nil)
                    
                    
                    if let answer = quiz.answer {
                        for word in answer {
                            print(word)
                        }
                    }
                    
                } else {
                    completionHandler(nil, ServiceError.emptyData)
                }
                
            } catch {
                completionHandler(nil, ServiceError.errorMessage(message: error.localizedDescription))
            }
            
        }
        
        task.resume()
    }
}
