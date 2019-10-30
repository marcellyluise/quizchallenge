//
//  XibLoader.swift
//  Quiz Challenge
//
//  Created by Marcelly Luise on 29/10/19.
//  Copyright © 2019 Celly Corp. All rights reserved.
//

import UIKit

class XibLoader: UIView {
    
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        xibSetup()
    }
    
    private func xibSetup() {
        
        guard let contentView = loadViewFromNib() else { return }
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
        
        didLoadViewFromXib()
    }
    
    func didLoadViewFromXib() {
        
    }

}
