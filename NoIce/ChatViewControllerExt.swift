//
//  ChatViewControllerExt.swift
//  NoIce
//
//  Created by Donelkys Santana on 5/27/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

extension ChatViewController: MessagesDataSource{
  func currentSender() -> SenderType {
    return Sender(id: MyVariables.userLogged.id, displayName: "")
  }
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messageList.count
  }
  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messageList[indexPath.section] as! MessageType
  }
  
}


// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
  
  func avatarSize(for message: MessageType, at indexPath: IndexPath,
                  in messagesCollectionView: MessagesCollectionView) -> CGSize {
    
    // 1
    return .zero
  }
  
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    avatarView.image = message.sender.senderId == MyVariables.userLogged.id ? MyVariables.userLogged.FotoPerfil : MyVariables.usuariosMostrar[self.chatOpenPos].FotoPerfil
  }
  
  func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> CGSize {
    
    // 2
    return CGSize(width: 0, height: 8)
  }
  
  func heightForLocation(message: MessageType, at indexPath: IndexPath,
                         with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
    // 3
    return 0
  }
}

extension ChatViewController: MessagesDisplayDelegate {
  
  func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                       in messagesCollectionView: MessagesCollectionView) -> UIColor {
    
    // 1
    return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : .green
  }
  
  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                           in messagesCollectionView: MessagesCollectionView) -> Bool {
    
    // 2
    return false
  }
  
  func messageStyle(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    
    // 3
    return .bubbleTail(corner, .curved)
  }
}

//extension ChatViewController: MessageInputBarDelegate{
//  func messageInputBar(_ inputBar: MessageInputBar,didPressSendButtonWith text: String) {
//    print("heress")
//  }
//}

extension ChatViewController: InputBarAccessoryViewDelegate{
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    
    // Here we can parse for which substrings were autocompleted
    let attributedText = messageInputBar.inputTextView.attributedText!
    let range = NSRange(location: 0, length: attributedText.length)
    attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
      
      let substring = attributedText.attributedSubstring(from: range)
      let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
      print("Autocompleted: `", substring, "` with context: ", context ?? [])
    }
    
    let components = inputBar.inputTextView.components
    messageInputBar.inputTextView.text = String()
    messageInputBar.invalidatePlugins()
    
    // Send button activity animation
    messageInputBar.sendButton.startAnimating()
    messageInputBar.inputTextView.placeholder = "Sending..."
    DispatchQueue.global(qos: .default).async {
      // fake send request task
      sleep(1)
      DispatchQueue.main.async { [weak self] in
        
        self?.messageInputBar.sendButton.stopAnimating()
        self?.messageInputBar.inputTextView.placeholder = "Type message"
        self?.insertMessages(components)
        self?.messagesCollectionView.scrollToBottom(animated: true)
      }
    }
  }
  
  private func insertMessages(_ data: [Any]) {
    
    for component in data {
      let user = Sender(id: MyVariables.userLogged.id, displayName: "text")
      if let str = component as? String {
        let message = Message(from: MyVariables.userLogged!.id, to: MyVariables.usuariosMostrar[self.chatOpenPos].id, text: str)
        insertNewMessage(message)
      }
//      } else if let img = component as? UIImage {
//        let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
//        insertMessage(message)
//      }
    }
  }
}

// MARK: - MessageCellDelegate
extension ChatViewController: MessageCellDelegate {
  
  func didTapAvatar(in cell: MessageCollectionViewCell) {
    print("Avatar tapped")
  }
  
  func didTapMessage(in cell: MessageCollectionViewCell) {
    print("Message tapped")
  }
  
  func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
    print("Top cell label tapped")
  }
  
  func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
    print("Bottom cell label tapped")
  }
  
  func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
    print("Top message label tapped")
  }
  
  func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
    print("Bottom label tapped")
  }
  
//  func didTapPlayButton(in cell: AudioMessageCell) {
//    guard let indexPath = messagesCollectionView.indexPath(for: cell),
//      let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
//        print("Failed to identify message when audio cell receive tap gesture")
//        return
//    }
//    guard audioController.state != .stopped else {
//      // There is no audio sound playing - prepare to start playing for given audio message
//      audioController.playSound(for: message, in: cell)
//      return
//    }
//    if audioController.playingMessage?.messageId == message.messageId {
//      // tap occur in the current cell that is playing audio sound
//      if audioController.state == .playing {
//        audioController.pauseSound(for: message, in: cell)
//      } else {
//        audioController.resumeSound()
//      }
//    } else {
//      // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
//      audioController.stopAnyOngoingPlaying()
//      audioController.playSound(for: message, in: cell)
//    }
//  }
  
  func didStartAudio(in cell: AudioMessageCell) {
    print("Did start playing audio sound")
  }
  
  func didPauseAudio(in cell: AudioMessageCell) {
    print("Did pause audio sound")
  }
  
  func didStopAudio(in cell: AudioMessageCell) {
    print("Did stop audio sound")
  }
  
  func didTapAccessoryView(in cell: MessageCollectionViewCell) {
    print("Accessory view tapped")
  }

}


