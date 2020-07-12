//
//  MessageCell.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/15/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    //MARK: - UI Elements
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //
    func configureCell(message: Message){
        let avatarName = message.userAvatar ?? "profileDefault"
        let userName = message.userName ?? ""
        let mess = message.message ?? ""
        avatarImg.image = UIImage(named: avatarName)
        avatarImg.backgroundColor = UserDataServices.instance.returnUIColor(componets: message.userAvatarColor)
        userNameLbl.text = userName
        timeStampLbl.text = formatterDate(date: message.timeStamp)
        messageLbl.text = mess
    }
    //
    func formatterDate(date:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatterGet.date(from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date!)
    }

}
