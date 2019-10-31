//
//  View+Extension.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 29/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

extension UIView {
    
    func loadViewFromNib() -> UIView? {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return nil
        }
        
        return view

    }
    
    func rounded(with cornerRadius: CGFloat, shouldClipToBounds: Bool = true) {
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = shouldClipToBounds
        
        clipsToBounds = shouldClipToBounds
    }
    
}

// MARK: - Acitivity Indicator View
extension UIView {
    func lockView(with duration: TimeInterval = 0.3) {
        if viewWithTag(42) == nil {
            let quizActivityIndicatorView = QuizActivityIndicatorView(frame: UIScreen.main.bounds)
            
            quizActivityIndicatorView.shouldStartActivityIndicator(start: true)
            quizActivityIndicatorView.alpha = 0.0
            
            addSubview(quizActivityIndicatorView)
            
            UIView.animate(withDuration: duration) {
                quizActivityIndicatorView.alpha = 1.0
            }
        }
    }
    
    func unlockView(with duration: TimeInterval = 0.3) {
        if let quizActivityIndicatorView = self.viewWithTag(42) as? QuizActivityIndicatorView {
            UIView.animate(withDuration: duration, animations: {
                quizActivityIndicatorView.alpha = 0.0
                quizActivityIndicatorView.shouldStartActivityIndicator(start: false)
            }, completion: { _ in
                quizActivityIndicatorView.removeFromSuperview()
            })
        }
    }
}
