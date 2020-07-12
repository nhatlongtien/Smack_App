//
//  AuthSevices.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/7/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class AuthService{
    static let instance = AuthService()
    let defaults = UserDefaults.standard
    var isLogin:Bool {
        get {
            
            return defaults.bool(forKey: LOGINED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGINED_IN_KEY)
        }
    }
    var authToken:String?{
        get {
            return defaults.value(forKey: TOKEN_KEY) as? String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    var userEmail:String{
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    func registerUser(email:String, password:String, completion: @escaping ComletionHandler){
        let lowerCaseEmail = email.lowercased()
        let header: HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        let body : [String:Any] = [
            "email":lowerCaseEmail,
            "password":password
        ]
        AF.request("https://newchatappproject.herokuapp.com/v1/account/register", method: .post, parameters: body, encoding: JSONEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseString { (response) in
            debugPrint(response)
            completion(true)
        }
    }
    //
    func loginUser(email:String, password:String, completion: @escaping ComletionHandler){
        let lowerCaseEmail = email.lowercased()
        let header:HTTPHeaders = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        let body:[String:Any] = [
            "email":lowerCaseEmail,
            "password":password
        ]
        AF.request("https://newchatappproject.herokuapp.com/v1/account/login", method: .post, parameters: body, encoding: JSONEncoding.default, headers: header, interceptor: nil, requestModifier: nil).validate().responseJSON { (response) in
            // using SwiftyJSON
            if response.error == nil{
                guard let data = response.data else {return}
                do{
                   let json = try JSON(data: data)
                    self.authToken = json["token"].stringValue
                    self.userEmail = json["user"].stringValue
                }catch{
                    print("Can not get json from data")
                }
                self.isLogin = true
                completion(true)
            }else{
                print("Can not login, error: \(response.error)")
                completion(false)
            }
        }
    }
    //
    func createUser(name: String, email:String, avatarName:String, avatarColor:String, completion: @escaping ComletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.authToken!)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body:[String:Any] = [
            "name":name,
            "email":email,
            "avatarName":avatarName,
            "avatarColor":avatarColor
        ]
        AF.request("https://newchatappproject.herokuapp.com/v1/user/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            guard let data = response.data else {return}
            do{
                let json = try JSON(data: data)
                let id = json["_id"].stringValue
                let email = json["email"].stringValue
                let name = json["name"].stringValue
                let color = json["avatarColor"].stringValue
                let avatarName = json["avatarName"].stringValue
                UserDataServices.instance.setUserData(id: id, name: name, email: email, avatarName: avatarName, avatarColor: color)
            }catch{
                print("Can not get json from data")
            }
            completion(true)
        }
    }
    func findUserByEmail(completion: @escaping ComletionHandler){
        let headers:HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.authToken!)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        AF.request("https://newchatappproject.herokuapp.com/v1//user/byEmail/\(AuthService.instance.userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            guard let data = response.data else {return}
            do{
               let json = try JSON(data: data)
                let id = json["_id"].stringValue
                let email = json["email"].stringValue
                let name = json["name"].stringValue
                let color = json["avatarColor"].stringValue
                let avatarName = json["avatarName"].stringValue
                UserDataServices.instance.setUserData(id: id, name: name, email: email, avatarName: avatarName, avatarColor: color)
            }catch{
                print("Can not get json from data")
            }
            completion(true)
        }
    }
}
