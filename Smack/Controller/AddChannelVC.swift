//
//  AddChannelVC.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/12/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController, UITextFieldDelegate {
    //MARK: - UI elements

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelNameTextField: UITextField!
    @IBOutlet weak var descriptionChannelTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        channelNameTextField.delegate = self
        descriptionChannelTextField.delegate = self
        //
        self.setupView()
    }
    //MARK: - UI events
    
    @IBAction func handleCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleCreateChannel(_ sender: Any) {
        guard let channelName = channelNameTextField.text, channelNameTextField.text != "" else {return}
        guard let channelDesc = descriptionChannelTextField.text else {return}
        SocketServices.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }else{
                print("-----------------------error")
            }
        }
    }
    //MARK: - UI TextFeild Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == channelNameTextField{
            descriptionChannelTextField.becomeFirstResponder()
        }else{
            descriptionChannelTextField.resignFirstResponder()
        }
        return true
    }
    //MARK: - Helper Methods
    
    func setupView(){
        //
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handleTap(_recognizer:)) )
        bgView.addGestureRecognizer(tap)
        //
        channelNameTextField.attributedPlaceholder = NSAttributedString(string: "Channel Name", attributes: [NSAttributedString.Key.foregroundColor:SmackPurplePlaceholder])
        descriptionChannelTextField.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor:SmackPurplePlaceholder])
    }
    @objc func handleTap(_recognizer:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
