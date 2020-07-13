//
//  CreateAccountVC.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/4/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    //MARK: Data Model
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var avatarName = "profileDefault"
    
    //MARK: UI Elements
    
    @IBOutlet weak var userTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        passwordTxt.isSecureTextEntry = true
        //
        userTxt.delegate = self
        passwordTxt.delegate = self
        emailTxt.delegate = self
        //
        setupView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDataServices.instance.avatarName != ""{
            avatarImg.image = UIImage(named: UserDataServices.instance.avatarName)
            avatarName = UserDataServices.instance.avatarName
            if avatarName.hasPrefix("light"){
                avatarImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    //MARK: - UI Events
    
    @IBAction func handlePickAvatar(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func handleChooseBackgroundColor(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        let bgColor:UIColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        print(avatarColor)
        UIView.animate(withDuration: 0.2) {
            self.avatarImg.backgroundColor = bgColor
        }
    }
    
    @IBAction func handleCreateAccount(_ sender: Any) {
        //
        spiner.isHidden = false
        spiner.startAnimating()
        //
        guard let name = userTxt.text, userTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success{
                print("registered user!")
                AuthService.instance.loginUser(email: email, password: password) { (success) in
                    if success{
                        print("loged in user!", AuthService.instance.authToken)
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success) in
                            if success {
                                print("Create user successfully, Name: \(UserDataServices.instance.name), AvatarName: \(UserDataServices.instance.avatarName)")
                                //
                                MessageSevices.instance.findAllChannel { (success) in
                                    if success{
                                        print("Find all channel")
                                    }
                                }
                                self.spiner.isHidden = true
                                self.spiner.startAnimating()
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                //
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func handleClosseButton(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    //
    @IBAction func preForUnwind(unwind:UIStoryboardSegue){
//        if UserDataServices.instance.avatarName != ""{
//            avatarImg.image = UIImage(named: UserDataServices.instance.avatarName)
//        }
    }
    //MARK: UI TextFeild Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTxt{
            emailTxt.becomeFirstResponder()
        }else if textField == emailTxt{
            passwordTxt.becomeFirstResponder()
        }else{
            passwordTxt.resignFirstResponder()
        }
        return true
    }
    //MARK: - Helper Method
    func setupView(){
        //
        spiner.isHidden = true
        //
        userTxt.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor:SmackPurplePlaceholder])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : SmackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: SmackPurplePlaceholder])
        //
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap(){
        self.view.endEditing(true)
    }
}

