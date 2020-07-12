//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by NGUYENLONGTIEN on 5/8/20.
//  Copyright © 2020 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //MARK: - Data model
    let avatarName = [
        ["dark0", "dark1", "dark2","dark3", "dark4", "dark5", "dark6", "dark7", "dark8", "dark9", "dark10", "dark11", "dark12", "dark13", "dark14", "dark15", "dark16", "dark17", "dark18", "dark19", "dark20", "dark21", "dark22", "dark23", "dark24", "dark25", "dark26", "dark27"],
        ["light0", "light1", "light2", "light3", "light4", "light5", "light6", "light7", "light8", "light9", "light10", "light11", "light12", "light13", "light14", "light15", "light16", "light17", "light18", "light19", "light20", "light21", "light22", "light23", "light24", "light25", "light26", "light27"]
        ]
    var typeOfAvatarName = [""]
    //MARK: - UI elements
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //
        typeOfAvatarName = avatarName[segmentControl.selectedSegmentIndex]
    }
    //MARK: UICollectionView Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns:CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        var padding:CGFloat = 40
        var spaceBetweenCell:CGFloat = 10
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1)*spaceBetweenCell)/numberOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let avatarName = typeOfAvatarName[indexPath.row]
        UserDataServices.instance.setAvatarName(avatarName: avatarName)
        self.dismiss(animated: true, completion: nil)
        
        //performSegue(withIdentifier: "unwindToCreateAccountVC", sender: nil)
        print(avatarName)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(name: typeOfAvatarName[indexPath.row])
            return cell
        }else{
            return AvatarCell()
        }
    }
    //MARK: - UI events
    @IBAction func handleBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func handleSegmentControl(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0{
            typeOfAvatarName = avatarName[0]
        }else{
            typeOfAvatarName = avatarName[1]
        }
        collectionView.reloadData()
    }
}
