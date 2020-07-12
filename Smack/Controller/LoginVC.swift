//
//  LoginVC.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/4/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    //MARK: UI elements

    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    // MARK: - UI evets
    @IBAction func handleDismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func handleCreateAccount(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    @IBAction func handleLogin(_ sender: Any) {
        //
        spiner.isHidden = false
        spiner.startAnimating()
        //Handle login
        guard let email = userName.text, userName.text != "" else {return}
        guard let pass = password.text, password.text != "" else {return}
        //
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            if success {
                print("User is Logined")
                AuthService.instance.findUserByEmail { (success) in
                    if success{
                        print("Find userinfo by email is successful: name: \(UserDataServices.instance.name)")
                        //
                        MessageSevices.instance.findAllChannel { (success) in
                            if success{
                                print("Find all channel")
                            }
                        }
                        //
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spiner.isHidden = true
                        self.spiner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print("Can not found userinfo by your email")
                    }
                }
            }else{
                print("Wrong email or pass, please enter again")
                //
                self.spiner.isHidden = true
                self.spiner.stopAnimating()
                // show alert to user
                let alert = UIAlertController(title: "Notification", message: "Your username or password is wrong, please typing again!", preferredStyle: UIAlertController.Style.alert)
                let btn_OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
                alert.addAction(btn_OK)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    //
    func setupView(){
        userName.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor:SmackPurplePlaceholder])
        password.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor:SmackPurplePlaceholder])
        //
        spiner.isHidden = true
    }
}
