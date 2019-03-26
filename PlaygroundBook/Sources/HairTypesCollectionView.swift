//
//  HairTypesCollectionView.swift
//  wwdc-scholarship-2019
//
//  Created by Débora Oliveira on 22/03/19.
//  Copyright © 2019 Débora Oliveira. All rights reserved.
//

import UIKit

extension HairsSimulateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hairCell = hairsCollection.dequeueReusableCell(withReuseIdentifier: "hairCell", for: indexPath) as! HairTypesCollectionViewCell
        
        if hairs[indexPath.row].4 {
            hairCell.hairImage.image = UIImage(named: "\(hairs[indexPath.row].0)-selected.png")
        } else {
            hairCell.hairImage.image = UIImage(named: "\(hairs[indexPath.row].0).png")
        }
        hairCell.name.text = hairs[indexPath.row].0
        return hairCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scene.didClickedInHair(hairs[indexPath.row])
        
        for i in 0..<hairs.count {
            hairs[i].4 = false
        }
        if !hairs[indexPath.row].4 {
            hairs[indexPath.row].4 = true
            hairsCollection.reloadData()
        }
    }
}

public class HairTypesCollectionViewCell : UICollectionViewCell {
    var identifier : String?
    
    public lazy var hairImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height))
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    public lazy var name: UILabel = {
        let name = UILabel(frame: CGRect(x: frame.width*0.05, y: frame.height*0.6, width: frame.width*0.3, height: frame.height*0.3))
        name.textColor = .bluePen
        name.textAlignment = .center
        name.numberOfLines = 0
        name.font = UIFont(name: "Gaegu-Regular", size: 28)
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        addSubview(hairImage)
        addSubview(name)
    }
    
}
