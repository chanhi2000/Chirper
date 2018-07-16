//
//  TableViewCell.swift
//  Chirper
//
//  Created by 전정철 on 16/07/2018.
//  Copyright © 2018 MarkiiimarK. All rights reserved.
//

import UIKit
import AVKit

let containerWidth:CGFloat = 100
let stackViewMargin:CGFloat = 8
let playbackButtonDimen: CGFloat = 60

class BirdSoundTableViewCell:  BaseTableViewCell {
    
    lazy var descriptionStackView: BaseStackView = {
        let stkv = BaseStackView(arrangedSubviews: [namesStackView, miscStackView])
        stkv.axis = .vertical
        stkv.distribution = .fillEqually
        stkv.spacing = stackViewMargin
        return stkv
    }()
    
    lazy var namesStackView: BaseStackView = {
        let stkv = BaseStackView(arrangedSubviews: [nameLabel, scientificNameLabel])
        return stkv
    }()
    
    let nameLabel: BaseLabel = {
        let lbl = BaseLabel(frame: .zero)
        lbl.text = "Name"
        return lbl
    }()
    
    let scientificNameLabel: BaseLabel = {
        let lbl = BaseLabel(frame: .zero)
        lbl.text = "Scientific Name"
        lbl.textColor = .darkGray
        return lbl
    }()
    
    lazy var miscStackView: BaseStackView = {
        let stkv = BaseStackView(arrangedSubviews: [countryLabel, dateLabel])
        return stkv
    }()
    
    let countryLabel: BaseLabel = {
        let lbl = BaseLabel(frame: .zero)
        lbl.text = "Country"
        return lbl
    }()
    
    let dateLabel: BaseLabel = {
        let lbl = BaseLabel(frame: .zero)
        lbl.text = "Date"
        lbl.textColor = .darkGray
        return lbl
    }()
    
    let audioPlayerContainer: BaseView = {
        let v = BaseView(frame: .zero)
        return v
    }()
    
    lazy var playbackButton: BaseButton = {
        let btn = BaseButton(type: .custom)
        btn.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        return btn
    }()
    
    var playbackURL: URL?
    var player = AVPlayer()
    
    var isPlaying = false {
        didSet {
            let newImage = isPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
            let img = newImage.resize(height: 60)?.withRenderingMode(.alwaysOriginal)
            playbackButton.setImage(img, for: .normal)
            if isPlaying, let url = playbackURL {
                player.replaceCurrentItem(with: AVPlayerItem(url: url))
                player.play()
            } else {
                player.pause()
            }
        }
    }
    
    override func prepareForReuse() {
        NotificationCenter.default.removeObserver(self)
        isPlaying = false
        super.prepareForReuse()
    }
    
    override func setupViews() {
        super.setupViews()
        selectionStyle = .none
        addSubview(audioPlayerContainer)
        addSubview(descriptionStackView)
        descriptionStackView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: audioPlayerContainer.leftAnchor, topConstant: stackViewMargin, leftConstant: stackViewMargin, bottomConstant: stackViewMargin, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        audioPlayerContainer.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: containerWidth, heightConstant: 0)
        
        audioPlayerContainer.addSubview(playbackButton)
        playbackButton.anchorCenterYToSuperview()
        playbackButton.anchorCenterXToSuperview()
        playbackButton.widthAnchor.constraint(equalToConstant: playbackButtonDimen)
        playbackButton.heightAnchor.constraint(equalToConstant: playbackButtonDimen)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

@objc extension BirdSoundTableViewCell {
    func togglePlayback() {
        #if DEBUG
        print("BirdSoundTableViewCell:togglePlayback")
        #endif
        isPlaying = !isPlaying
    }
    
    func playerDidFinishPlaying(_:NSNotification) {
        isPlaying = false
    }
    func itemDidReachEnd(_:NSNotification) {
        player.seek(to: kCMTimeZero)
    }
}

extension BirdSoundTableViewCell {
    func load(recording: Recording) {
        nameLabel.text = recording.friendlyName
        scientificNameLabel.text = "\(recording.genus) \(recording.species)"
        countryLabel.text = recording.country
        dateLabel.text = recording.date
        
        let playableRecordingURLString = "https:\(recording.fileURL.absoluteString)"
        playbackURL = URL(string: playableRecordingURLString)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(playerDidFinishPlaying(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(itemDidReachEnd(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)
        
    }
    
    func ensurePlaybackWorksForDeviceOnSilent() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: [])
    }
}
