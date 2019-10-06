//
//  TrackCell.swift
//  iTunesTracker
//
//  Created by Alexander on 02/10/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit
import AVFoundation

class TrackCell: UITableViewCell {
    let playButtonImage = UIImage(named: "play_btn_image.png")
    let stopButtonImage = UIImage(named: "stop_btn_image.png")
    var urlSound: URL?
    var player: AVPlayer?

    var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(dynamicProvider: { trait -> UIColor in
            return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        })
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(dynamicProvider: { trait -> UIColor in
            return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        })
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var trackNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(dynamicProvider: { trait -> UIColor in
            return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        })
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var playStopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(playButtonImage, for: .normal)
        button.alpha = 0.8
        button.addTarget(self, action: #selector(playStopButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(albumImageView)
        albumImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        
        addSubview(playStopButton)
        playStopButton.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor).isActive = true
        playStopButton.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor).isActive = true
        
        addSubview(trackNameLabel)
        trackNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        trackNameLabel.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 10).isActive = true
        
        addSubview(artistNameLabel)
        artistNameLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 10).isActive = true
        
        addSubview(collectionNameLabel)
        collectionNameLabel.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor).isActive = true
        collectionNameLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    func setup(_ track: Track) {
        artistNameLabel.text = track.artistName
        collectionNameLabel.text = track.collectionName
        trackNameLabel.text = track.trackName
        urlSound = track.soundPreview
    }
    
    @objc func playStopButtonPressed(_ sender: UIButton) {
        playStopButton.setImage(UIImage(), for: .normal)
        
        if playStopButton.currentBackgroundImage == stopButtonImage {
            playStopButton.setBackgroundImage(playButtonImage, for: .normal)
            
            player?.pause()
        } else {
            playStopButton.setBackgroundImage(stopButtonImage, for: .normal)
            
            if let urlSound = urlSound {
                player = AVPlayer(url: urlSound)
                player?.play()
            }
        }
    }
}
