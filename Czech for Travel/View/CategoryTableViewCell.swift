//
//  CategoryTableViewCell.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 5/29/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//

import UIKit
import AVFoundation

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var audioButton: UIImageView!
    
    var audioFileName: String?
    var player: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        audioButton.isUserInteractionEnabled = true
        audioButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            self.backgroundColor = UIColor.black
            audioButton.isHidden = false
        } else {
            self.backgroundColor = UIColor.darkGray
            audioButton.isHidden = true
        }
    }
    
    func configureCell(phrase: Phrase) {
        audioButton.accessibilityElementsHidden = true
        phraseLabel.text = phrase.english
        phraseLabel.textColor = UIColor.white
        self.backgroundColor = UIColor.darkGray
        self.selectionStyle = .none
        audioButton.isHidden = true
        self.audioFileName = phrase.audioFileName ?? "kde"
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        playSound(file: self.audioFileName ?? "kde")
    }
    
    private func playSound(file: String) {
        guard
            let url = Bundle.main.url(forResource: file, withExtension: "mp3")
            else {
                print(file, "not found")
                return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

}



