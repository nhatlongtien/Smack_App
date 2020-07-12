//
//  ProfileVC.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/11/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    //MARK: - UI elements
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.setupView()
    }
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func handleLogOut(_ sender: Any) {
        UserDataServices.instance.logOut()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    //
    func setupView(){
        profileImg.image = UIImage(named: UserDataServices.instance.avatarName)
        profileImg.backgroundColor = UserDataServices.instance.returnUIColor(componets: UserDataServices.instance.avatarColor)
        userName.text = UserDataServices.instance.name
        userEmail.text = UserDataServices.instance.email
        //
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(tap)
    }
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
}
