//
//  ResultView.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import UIKit

class ResultView: BaseView {
    
    let messageLabel: BaseLabel = {
        let lbl = BaseLabel(frame: .zero)
        lbl.text = "No results! \nTry searching for something different."
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    var message: String = "No results! \nTry searching for something different." {
        didSet {
            messageLabel.text = message
        }
    }
    
    override func setupViews() {
        addSubview(messageLabel)
        messageLabel.anchorCenterSuperview()
        messageLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 20).isActive = true
    }
    
}


