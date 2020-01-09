//
//  MessageVCExtension.swift
//  chatApp
//
//  Created by axiom1234 on 28/12/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import AVFoundation


extension MessagesViewController: UITextViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    func textViewDidChange(_ textView: UITextView) {
        print(messageTextView.text)
        
        adjustTextViewHeight()
    }
    
    
    
    func adjustTextViewHeight() {
        //let fixedWidth = messageTextView.frame.size.width
        let newSize = messageTextView.sizeThatFits(CGSize(width: 254, height: CGFloat.greatestFiniteMagnitude))
        print(newSize.height)
        
        if newSize.height <= 120{
            
            heightConstraint.constant = newSize.height + 25
        }else if newSize.height >= 120{
            messageTextView.isScrollEnabled = true
        }
        
        self.view.layoutIfNeeded()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    
    @objc func play()  {
        //  let url =  getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
        let url = URL(string: audioURL!)
        do {
            print(url!)
            audioPlayer = try AVPlayer(url: url!)
            audioPlayer.play()
            print("Audio Playing......")
        } catch  {
            //Error
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        // if Sender
        if messageArray[indexPath.row].senderID == self.uid{
            
            if (messageArray[indexPath.row].messageType?.contains("image"))!{
                
                let senderImageCell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderSideImageCell
                self.indexPathRowForSenderImage = indexPath.row
                let url = URL(string: self.messageArray[indexPath.row].messageBody )
                senderImageCell.MessageImageView.sd_setImage(with: url as! URL, placeholderImage: self.image)
               // senderImageCell.MessageImageView.image = self.image
                return senderImageCell
              //  cell.newChatUserImageView.sd_setImage(with: url as! URL, placeholderImage: self.image)
            }else if (messageArray[indexPath.row].messageType?.contains("audio"))!{
                let cell = tableView.dequeueReusableCell(withIdentifier: "senderAudioCell", for: indexPath) as! SenderAudioCell
                
                
                
                    //cell.playOrPauseBtn.tag = indexPath.row
                audioURL = self.messageArray[indexPath.row].messageBody
                cell.playOrPauseBtn.addTarget(self, action: #selector(play), for: .touchUpInside)

//                cell.delegate = self
                self.indexPathRowForSenderAudio = indexPath.row
//                let message = messageArray[indexPath.row].messageBody
//                let url = URL(string: message!)
//                cell.playBtn(url)
                return cell
            }
            
            else{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
                cell.messageBodyLbl.text = messageArray[indexPath.row].messageBody
                cell.timeLbl.text = messageArray[indexPath.row].time
                return cell
            }
            
        }
            // if Receiver
        else {
            
            if (messageArray[indexPath.row].messageType?.contains("image"))!{
                
                let receiverImageCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell", for: indexPath) as! ReceiverImageCell
                
                self.indexPathRowForSenderImage = indexPath.row
                let url = URL(string: self.messageArray[indexPath.row].messageBody )
                
                receiverImageCell.messageImageView.sd_setImage(with: url as! URL, placeholderImage: self.image)
                // senderImageCell.MessageImageView.image = self.image
                return receiverImageCell
                //  cell.newChatUserImageView.sd_setImage(with: url as! URL, placeholderImage: self.image)
            }
            else if (messageArray[indexPath.row].messageType?.contains("audio"))!{
                let receiverAudioCell = tableView.dequeueReusableCell(withIdentifier: "receiverAudioCell", for: indexPath) as! ReceiverAudioCell
                self.indexPathRowForSenderAudio = indexPath.row
                
                audioURL = self.messageArray[indexPath.row].messageBody
                receiverAudioCell.playOrPauseBtn.addTarget(self, action: #selector(play), for: .touchUpInside)
                
                
              //  receiverAudioCell.playBtn(url)
                
                return receiverAudioCell
            }

            else{
                
                let receiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                receiverCell.receiverMessageBodyLbl.text = messageArray[indexPath.row].messageBody
                receiverCell.timeLbl.text = messageArray[indexPath.row].time
                return receiverCell
            }
            
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == indexPathRowForSenderImage{
            return 110
        }else if indexPath.row == indexPathRowForSenderAudio{
            return 70
        }else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
    }
   

    
}

