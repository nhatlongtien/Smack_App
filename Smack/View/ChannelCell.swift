//
//  ChannelCell.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/12/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.4).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    func configureCell(channel:Channel){
        let title = channel.channelName ?? ""
        self.channelNameLbl.text = "#\(title)"
        self.channelNameLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        //
        for id in MessageSevices.instance.unreadChannels{
            if id == channel.id{
                self.channelNameLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            }
        }
    }

}
