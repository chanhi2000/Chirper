//
//  LoadingView.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import UIKit

let indicatorSize: CGFloat = 37

class LoadingView: BaseView {
    
    let indicator: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.color = AppColor.darkGreen
        iv.hidesWhenStopped = true
        return iv
    }()
    
    var isAnimating = false {
        didSet {
            isAnimating ? indicator.startAnimating() : indicator.stopAnimating()
        }
    }
    
    override func setupViews() {
        addSubview(indicator)
        indicator.anchorCenterSuperview()
        indicator.widthAnchor.constraint(equalToConstant: indicatorSize).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: indicatorSize).isActive = true
//        indicator.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: indicatorSize, heightConstant: indicatorSize)
    }
}
