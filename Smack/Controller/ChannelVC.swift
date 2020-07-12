//
//  ChannelVC.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/4/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - UI elements
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - UI ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        tableView.delegate = self
        tableView.dataSource = self
        //
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        //
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(channelDidLoad), name: NOTIF_CHANNEL_DID_LOAD, object: nil)
     
        //
        SocketServices.instance.getChannel { (success) in
            if success{
                print("Upadate new channel is successful")
                self.tableView.reloadData()
            }else{
                print("kgong lay dc du lieu")
            }
        }
        //
        SocketServices.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageSevices.instance.selectedChannel.id && AuthService.instance.isLogin{
                MessageSevices.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if AuthService.instance.isLogin {
            login_btn.setTitle(UserDataServices.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataServices.instance.avatarName)
            userImg.backgroundColor = UserDataServices.instance.returnUIColor(componets: UserDataServices.instance.avatarColor)
        }else{
            login_btn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
        }
    }
    //MARK: - UI Events
    @IBAction func handleLogin(_ sender: Any) {
        if AuthService.instance.isLogin{
            // show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    @IBAction func handleAddChannel(_ sender: Any) {
        if AuthService.instance.isLogin{
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = UIModalPresentationStyle.custom
            present(addChannel, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Notification", message: "You need to login to create a new channel!", preferredStyle: UIAlertController.Style.alert)
            let btn_OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(btn_OK)
            present(alert, animated: true, completion: nil)
        }
    }
    //MARK: - UI tableView delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageSevices.instance.channels.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelCell
        let channel = MessageSevices.instance.channels[indexPath.row]
        cell.configureCell(channel: channel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageSevices.instance.channels[indexPath.row]
        MessageSevices.instance.selectedChannel = channel
        //
        if MessageSevices.instance.unreadChannels.count > 0{
            MessageSevices.instance.unreadChannels = MessageSevices.instance.unreadChannels.filter{$0 != channel.id}
        }
        let index = IndexPath(row: indexPath.row, section: 0)
        self.tableView.reloadRows(at: [index], with: UITableView.RowAnimation.none)
        self.tableView.selectRow(at: index, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        //
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        //
        self.revealViewController()?.revealToggle(animated: true)
    }
    //MARK: - Helper Method
    @objc func userDataDidChange(_notif:Notification){
        if AuthService.instance.isLogin {
            login_btn.setTitle(UserDataServices.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataServices.instance.avatarName)
            userImg.backgroundColor = UserDataServices.instance.returnUIColor(componets: UserDataServices.instance.avatarColor)
        }else{
            login_btn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    @objc func channelDidLoad(_notif:Notification){
        tableView.reloadData()
    }
}















