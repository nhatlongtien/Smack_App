//
//  SocketServices.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/13/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
import SocketIO
let manger = SocketManager(socketURL: URL(string: "https://newchatappproject.herokuapp.com/v1/")!)
let socket = manger.defaultSocket
class SocketServices: NSObject {
    static let instance = SocketServices()
    
    override init(){
        super.init()
    }
    func establishConnection(){
        socket.connect()
    }
    func closeConnection(){
        socket.disconnect()
    }
    func addChannel(channelName:String, channelDescription:String, competion: @escaping ComletionHandler){
        socket.emit("newChannel", channelName,channelDescription)
        competion(true)
    }
    func getChannel(completion: @escaping ComletionHandler){
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            let newChnanel = Channel(channelName: channelName, channelDescription: channelDesc, id: channelId)
            MessageSevices.instance.channels.append(newChnanel)
            completion(true)
        }
    }
    //
    func addMessage(messageBody:String, channelId:String, completion:@escaping ComletionHandler){
        socket.emit("newMessage", messageBody, UserDataServices.instance.id,channelId, UserDataServices.instance.name, UserDataServices.instance.avatarName, UserDataServices.instance.avatarColor)
        completion(true)
    }
    //
    func getChatMessage(completion: @escaping (_ message:Message) -> Void){
        socket.on("messageCreated") { (dataArray, ack) in
            guard let message = dataArray[0] as? String else {return}
            guard let userId = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            let newMessage = Message(channelId: channelId, message: message, userId: userId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
            completion(newMessage)
        }
    }
    
    func getTypingUers(_ completionHandler: @escaping (_ typingUsers: [String:String]) -> Void){
        socket.on("userTypingUpdate") { (arrayData, ack) in
            guard let typingUsers = arrayData[0] as? [String:String] else {return}
            completionHandler(typingUsers)
        }
    }
    
    
    
    
    
    
    
    
}
