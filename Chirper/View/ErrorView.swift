//
//  ErrorView.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import UIKit

class ErrorView: BaseView {
    
    let titleLabel: BaseLabel = {
        let lbl = BaseLabel(frame: .zero)
        lbl.text = "Ooops!"
        lbl.textColor = .darkGray
        lbl.font = .systemFont(ofSize: 24)
        return lbl
    }()
    
    let errorLabel: BaseLabel = {
        let lbl = BaseLabel(frame: .zero)
        lbl.text = "Error Label"
        return lbl
    }()
    
    var errorMessage: String = "Error Label" {
        didSet {
            errorLabel.text = errorMessage
        }
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        titleLabel.anchorCenterXToSuperview()
        titleLabel.anchorCenterYToSuperview(constant: -2)
        addSubview(errorLabel)
        errorLabel.anchorCenterXToSuperview()
        errorLabel.anchorCenterYToSuperview(constant: 2)
        errorLabel.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 20)
    }
    
}
