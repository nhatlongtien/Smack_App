//
//  Constants.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/4/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
// Segue
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannelVC"
let TO_AVATAR_PICKER = "toAvatarPicker"
// User defaults
let TOKEN_KEY = "token"
let LOGINED_IN_KEY = "loginedIn"
let USER_EMAIL = "userEmail"
//
typealias ComletionHandler = (_ Success: Bool) -> ()
//Color
let SmackPurplePlaceholder = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 0.5)
//
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChange")
let NOTIF_CHANNEL_DID_LOAD = Notification.Name("notififChannelLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name(rawValue: "channelSelected")
