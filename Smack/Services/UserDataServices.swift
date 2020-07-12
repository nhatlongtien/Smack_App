//
//  UserDataServices.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/8/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
class UserDataServices{
    static let instance = UserDataServices()
    public private(set) var id = ""
    public private(set) var name = ""
    public private(set) var email = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    
    func setUserData(id: String, name: String, email:String, avatarName:String, avatarColor:String){
        self.id = id
        self.name = name
        self.email = email
        self.avatarName = avatarName
        self.avatarColor = avatarColor
    }
    func setAvatarName(avatarName:String){
        self.avatarName = avatarName
    }
    func returnUIColor(componets:String) -> UIColor{
        // [0.9450980392156862, 0.611764705882353, 0.6941176470588235, 1]
        let scaner = Scanner(string: componets)
        let skiped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scaner.charactersToBeSkipped = skiped
        var r,g,b,a :NSString?
        scaner.scanUpToCharacters(from: comma, into: &r)
        scaner.scanUpToCharacters(from: comma, into: &g)
        scaner.scanUpToCharacters(from: comma, into: &b)
        scaner.scanUpToCharacters(from: comma, into: &a)
        let defaultColor = UIColor.lightGray
        guard let rUnwarpped = r else {return defaultColor}
        guard let gUnwarpped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rFloat = CGFloat(rUnwarpped.doubleValue)
        let gFloat = CGFloat(gUnwarpped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newBgColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        return newBgColor
    }
    func logOut(){
        self.name = ""
        self.email = ""
        self.avatarName = ""
        self.avatarColor = ""
        AuthService.instance.isLogin = false
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        MessageSevices.instance.clearChannel()
        MessageSevices.instance.clearMessages()
    }
}
