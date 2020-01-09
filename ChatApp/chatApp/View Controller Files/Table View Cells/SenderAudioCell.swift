//
//  SenderAudioCell.swift
//  chatApp
//
//  Created by axiom1234 on 06/01/2020.
//  Copyright © 2020 Mohammad Arsalan. All rights reserved.
//

import UIKit
import AVFoundation

//protocol AudioCellDelegate {
//    func didTapPlayButton(url : String)
//}

class SenderAudioCell: UITableViewCell {
    
    
 //   var messageItem : Message!
//   var delegate: AudioCellDelegate?
//    var recordingSession : AVAudioSession!
//    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var SenderAudioCellView: UIView!{
        didSet{
            SenderAudioCellView.layer.cornerRadius  = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
    
    
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    @IBOutlet weak var audioDurationLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func playBtn(_ sender: Any) {
//        print(messageItem.messageBody)
//
//        delegate?.didTapPlayButton(url: messageItem.messageBody)
        
        
        
    }
    
}
