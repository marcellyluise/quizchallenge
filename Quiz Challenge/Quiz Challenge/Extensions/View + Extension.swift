//
//  View + Extension.swift
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
    
}
