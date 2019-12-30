//
//  CMensaje.swift
//  NoIce
//
//  Created by Done Santana on 4/2/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import MessageKit

class Message: Equatable, MessageType{
  var sender: SenderType
  
  var messageId: String
  
  var sentDate: Date
  
  var kind: MessageKind
  
  
  var id: String!
  var from : String!
  var to : String!
  var text: String!
  
  var MessageContainer = CKContainer.default()
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs == rhs
  }
  
  init(newMessage: CKRecord) {
    self.id = newMessage.recordID.recordName
    self.from = (newMessage.value(forKey: "from") as! CKRecord.Reference).recordID.recordName
    self.to = (newMessage.value(forKey: "to") as! CKRecord.Reference).recordID.recordName
    self.text = newMessage.value(forKey: "text") as? String
    
    sender = Sender(id: self.from, displayName: "")
    messageId = self.id
    sentDate = Date()//(newMessage.value(forKey: "created") as? Date)!
    kind = .text(self.text)
  }
  
  init(from: String, to: String, text: String) {
    self.from = from
    self.to = to
    self.text = text
    self.messageId = "test"
    sender = Sender(id: GlobalVariables.userLogged.cloudId, displayName: "")
    
    sentDate = Date()
    kind = .text(text)
    
    let recordMensaje = CKRecord(recordType: "Messages")
    let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: from), action: .deleteSelf)
    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: to), action: .deleteSelf)
    recordMensaje.setObject(fromReference as CKRecordValue, forKey: "from")
    recordMensaje.setObject(toReference as CKRecordValue, forKey: "to")
    recordMensaje.setObject(text as CKRecordValue, forKey: "text")
    
    self.MessageContainer.publicCloudDatabase.save(recordMensaje, completionHandler: {(record, error) in
      if error == nil{
        self.id = record?.recordID.recordName
        self.messageId = self.id
      }else{
        
        print("error \(error.debugDescription)")
      }
    })
  }
  
//  func RecibirMensaje() {
//    self.text = "Resultado de Consulta"
//  }
//
//  func EnviarMensaje(){
//    //Enviar el mensaje al servidor
//    let recordMensaje = CKRecord(recordType: "Messages")
//    recordMensaje.setObject(self.from as CKRecordValue, forKey: "from")
//    recordMensaje.setObject(self.to as CKRecordValue, forKey: "to")
//    recordMensaje.setObject(self.text as CKRecordValue, forKey: "text")
//
//    let chatRecordsOperation = CKModifyRecordsOperation(
//      recordsToSave: [recordMensaje],
//      recordIDsToDelete: nil)
//    self.MessageContainer.publicCloudDatabase.add(chatRecordsOperation)
//  }
//
}

//extension Message: MessageType {
//  var sender: SenderType {
//    return SenderType
//  }
//  
//  var messageId: String {
//    <#code#>
//  }
//  
//  var sender: Sender {
//    return Sender(id: GlobalVariables.userLogged.recordID.recordName, displayName: "")
//  }
//  
//  var sentDate: Date {
//    return Date()
//  }
//  
//  var kind: MessageKind {
//    return .text(text)
//  }
//}
