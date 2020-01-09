//
//  ReceiverAudioCell.swift
//  chatApp
//
//  Created by axiom1234 on 08/01/2020.
//  Copyright © 2020 Mohammad Arsalan. All rights reserved.
//

import UIKit
import AVFoundation
class ReceiverAudioCell: UITableViewCell {

    var audioPlayer : AVPlayer!
    //    var recordingSession : AVAudioSession!
    //    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var receiverAudioCellView: UIView!{
        didSet{
            receiverAudioCellView.layer.cornerRadius  = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
    
    
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    @IBOutlet weak var audioDurationLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
//    @IBAction func playBtn(_ sender: Any) {
//        let path = sender
//
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: path as! URL)
//            audioPlayer.play()
//            print("Audio Playing......")
//        } catch  {
//            //Error
//        }
//    }
//}
}
