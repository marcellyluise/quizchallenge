//
//  Service.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 27/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class Service {
    
    typealias QuizCompletion = (Quiz?, Error?) -> Void
    
    func fetchQuiz(with completionHandler: @escaping QuizCompletion) {
        let url = URL(string: "https://codechallenge.arctouch.com/quiz/1")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                
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
                    
                }
                
            } catch {
                completionHandler(nil, error)
            }
            
        }
        task.resume()
    }
}
