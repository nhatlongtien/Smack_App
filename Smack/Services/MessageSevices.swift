//
//  MessageSevices.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/12/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class MessageSevices{
    static let instance = MessageSevices()
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel = Channel()
    var unreadChannels = [String]()
    
    func findAllChannel(completion: @escaping ComletionHandler){
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.authToken!)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        AF.request("https://newchatappproject.herokuapp.com/v1/channel", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).validate().responseJSON { (response) in
            if response.error == nil{
                guard let data = response.data else {return}
                do{
                    if let json = try JSON(data: data).array{
                        for item in json{
                            let id = item["_id"].stringValue
                            let channelName = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let channel = Channel(channelName: channelName, channelDescription: channelDescription, id: id)
                            self.channels.append(channel)
                            print(self.channels.first)
                        }
                    }
                }catch{
                    print("Can not get Json from data")
                }
                NotificationCenter.default.post(name: NOTIF_CHANNEL_DID_LOAD, object: nil)
                completion(true)
            }else{
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    func clearChannel(){
        self.channels.removeAll()
    }
    //
    let headers:HTTPHeaders = [
        "Authorization": "Bearer \(AuthService.instance.authToken!)",
        "Content-Type": "application/json; charset=utf-8"
    ]
    func findAllMessageForChannel(channelId:String, completion:@escaping ComletionHandler){
        AF.request("https://newchatappproject.herokuapp.com/v1/message/byChannel/\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).validate().responseJSON { (response) in
            if response.error == nil{
                //
                self.clearMessages()
                //
                guard let data = response.data else {return}
                do{
                    if let json = try JSON(data: data).array{
                        for item in json{
                            let channelId = item["channelId"].stringValue
                            let userId = item["_id"].stringValue
                            let messageBody = item["messageBody"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            let message = Message(channelId: channelId, message: messageBody, userId: userId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
                            self.messages.append(message)
                        }
                    }
                }catch{
                    print("Can not get json from data")
                }
                print(self.messages)
                completion(true)
            }else{
                debugPrint(response.error as Any)
                completion(false)
            }
        }
    }
    //
    func clearMessages(){
        self.messages.removeAll()
    }
}

