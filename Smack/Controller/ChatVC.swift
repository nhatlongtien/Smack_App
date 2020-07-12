//
//  ChatVC.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/4/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //MARK: - UI Elements
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var menu_btn: UIButton!
    @IBOutlet weak var typingUserLbl: UILabel!
    //
    var isTyping = false
    //MARK: - UI viewConroller
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        if AuthService.instance.authToken == nil{
            AuthService.instance.authToken = ""
        }
        //
        typingUserLbl.text = ""
        //
        sendButton.isHidden = true
        //
        messageTextField.delegate = self
        //
        tableView.delegate = self
        tableView.dataSource = self
        //
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        //
        view.bindToKeyboard() // view will go up when keyboard show
        // Hide keyboard when user tap into the view
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        //
        menu_btn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControl.Event.touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDidChane(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        //
        //
        if AuthService.instance.isLogin{
            //
            AuthService.instance.findUserByEmail { (success) in
                if success{
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }else{
                    print("Can not find userInfo")
                }
            }
            //
            MessageSevices.instance.findAllChannel { (success) in
                if success{
                    if MessageSevices.instance.channels.count > 0 {
                        MessageSevices.instance.selectedChannel = MessageSevices.instance.channels[0]
                        self.updateWithChanel()
                    }
                }
            }
            // Update channel title
        }else{
            titleLable.text = "Please login" // update channel title
        }
        SocketServices.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageSevices.instance.selectedChannel.id && AuthService.instance.isLogin{
                MessageSevices.instance.messages.append(newMessage)
                self.tableView.reloadData()
                if MessageSevices.instance.messages.count > 0{
                    let endIndexPath = IndexPath(row: MessageSevices.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndexPath, at: UITableView.ScrollPosition.bottom, animated: false)
                }
            }
        }
        //
        SocketServices.instance.getTypingUers { (typingUsers) in
            guard let channelID = MessageSevices.instance.selectedChannel.id  else {return}
            var names = ""
            var numberOfUserTyping = 0
            for (typingUser, channel) in typingUsers{
                if typingUser != UserDataServices.instance.name && channel == channelID{
                    if names == ""{
                        names = typingUser
                    }else{
                        names = "\(names), \(typingUser)"
                    }
                    numberOfUserTyping += 1
                }
            }
            if numberOfUserTyping > 0 && AuthService.instance.isLogin{
                var verb = "is"
                if numberOfUserTyping > 1{
                    verb = "are"
                }
                self.typingUserLbl.text = "\(names) \(verb) typing a message"
            }else{
                self.typingUserLbl.text = ""
            }
        }
        
    }
    //MARK: - UI tableView Delegate & datasource
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MessageSevices.instance.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell{
            let message = MessageSevices.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    //MARK: - UI events
    @IBAction func sendMessageButton(_ sender: Any) {
        if AuthService.instance.isLogin{
            guard let channelId = MessageSevices.instance.selectedChannel.id else {return}
            guard let message = messageTextField.text else {return}
            SocketServices.instance.addMessage(messageBody: message, channelId: channelId) { (success) in
                if success{
                    self.messageTextField.text = ""
                    //self.sendButton.isHidden = true
                    socket.emit("stopType", UserDataServices.instance.name, channelId)
                    self.messageTextField.resignFirstResponder()
                }else{
                    print("can not send message")
                }
            }
        }
    }
    @IBAction func messageTextBox(_ sender: Any) {
        guard let channelId = MessageSevices.instance.selectedChannel.id else {return}
        if messageTextField.text == ""{
            isTyping = false
            sendButton.isHidden = true
            //
            socket.emit("stopType", UserDataServices.instance.name, channelId)
        }else{
            sendButton.isHidden = false
            //
            socket.emit("startType", UserDataServices.instance.name, channelId)
        }
    }
    
    //MARK: - Helper Methods
    @objc func channelSelected(_ notif: Notification){
        updateWithChanel()
    }
    @objc func userDidChane(_ notif:Notification){
        self.tableView.reloadData()
    }
    func updateWithChanel(){
        let nameChannel = MessageSevices.instance.selectedChannel.channelName ?? ""
        titleLable.text = "#\(nameChannel)"
        self.getMessages()
        
    }
    func getMessages(){
        guard let channelId = MessageSevices.instance.selectedChannel.id else {return}
        MessageSevices.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if success {
                print("get message for channel Name: \(MessageSevices.instance.selectedChannel.channelName) is successful")
                self.tableView.reloadData()
            }
        }
    }
    //
    @objc func handleTap(){
        view.endEditing(true)
        //sendButton.isHidden = true
    }
}
