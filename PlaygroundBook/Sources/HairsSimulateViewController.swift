//
//  ViewController.swift
//  wwdc-scholarship-2019
//
//  Created by Débora Oliveira on 17/03/19.
//  Copyright © 2019 Débora Oliveira. All rights reserved.
//

import UIKit
import SpriteKit

public class HairsSimulateViewController: UIViewController {
    
    var sceneViewFrame = CGRect(x:0.0, y:0.0, width:0.0, height: 0.0)
    var toolsViewFrame = CGRect(x:0.0, y:0.0, width:0.0, height: 0.0)
    var playButtonFrame = CGRect(x:0.0, y:0.0, width:0.0, height: 0.0)
    var itemCollectionFrame = CGSize(width:0.0, height: 0.0)
    var hairsCollectionFrame = CGRect(x:0.0, y:0.0, width:0.0, height: 0.0)
    var paperImgFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    
    var scene : HairsSimulateScene!
    
    var hairs = [("2A",2.0, 2, CGFloat(0.5), true),
                 ("2B",3.0, 2, CGFloat(0.5), false),
                 ("2C",4.0, 2, CGFloat(0.5), false),
                 ("3A",2.0, 5, CGFloat(0.45), false),
                 ("3B",3.0, 5, CGFloat(0.45), false),
                 ("3C",4.0, 5, CGFloat(0.45), false),
                 ("4A",2.0, 9, CGFloat(0.3), false),
                 ("4B",3.0, 9, CGFloat(0.3), false),
                 ("4C",4.0, 9, CGFloat(0.3), false)]
    
    var hairSelected = 0
    //type, weight, repetions, ray, selected
    
    public lazy var bgImg : UIImageView = {
        let bgImg = UIImageView(frame: self.view.frame)
        bgImg.image = UIImage(named: "background.png")
        bgImg.contentMode = .scaleToFill
        return bgImg
    }()
    
    public lazy var sceneView : SKView = {
        let sceneView = SKView(frame: sceneViewFrame)
        sceneView.backgroundColor = .yellow
        return sceneView
    }()
    public lazy var toolsView : UIView = {
        let toolsView = UIView(frame: toolsViewFrame)
        toolsView.backgroundColor = .clear
        return toolsView
    }()
    public lazy var paperImg : UIImageView = {
        let paperImg = UIImageView(frame: paperImgFrame)
        paperImg.image = UIImage(named: "paper_1.png")
        paperImg.contentMode = .scaleToFill
        return paperImg
    }()
    // Button play
    public lazy var playButton : UIButton = {
        let playButton = UIButton(type: .custom)
        playButton.frame = playButtonFrame
        playButton.setBackgroundImage(UIImage(named: "play.png"), for: .normal)
        playButton.setImage(UIImage(named: "play.png"), for: .selected)
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        return playButton
    }()
    //Collection view types of hairs
    public lazy var hairsCollection : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = view.frame.width*0.5
        flowLayout.itemSize = itemCollectionFrame
        
        let hairsCollection = UICollectionView(frame: hairsCollectionFrame, collectionViewLayout: flowLayout)
        //        let hairsCollection = UICollectionView(frame: hairsCollectionFrame)
        hairsCollection.register(HairTypesCollectionViewCell.self, forCellWithReuseIdentifier: "hairCell")
        hairsCollection.delegate = self
        hairsCollection.dataSource = self
        hairsCollection.backgroundColor = UIColor.clear
        return hairsCollection
    }()
    
    @objc public func didPressPlayButton() {
        let curlsScene = sceneView.scene as! HairsSimulateScene
        curlsScene.playAnimations()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        recalculateFrames()
        
        view.addSubview(bgImg)
        view.addSubview(paperImg)
        
        toolsView.addSubview(playButton)
        toolsView.addSubview(hairsCollection)

        view.addSubview(toolsView)
        view.addSubview(sceneView)
        
        scene = HairsSimulateScene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = SKColor.clear
        sceneView.backgroundColor = UIColor.clear
//        sceneView.showsPhysics = true
//        sceneView.showsNodeCount = true
        sceneView.presentScene(scene)
        
    }
    
    func recalculateFrames() {
        sceneViewFrame = CGRect(x: 0.0, y: view.frame.height*0.1, width: self.view.frame.width, height: (self.view.frame.height*0.5)) //ok
        
        toolsViewFrame = CGRect(x: (self.view.frame.width*0.1)/2, y: self.view.frame.height*0.62, width: self.view.frame.width-self.view.frame.width*0.1, height: self.view.frame.height*0.2) //ok
        
        playButtonFrame = CGRect(x: (toolsViewFrame.width*0.5)-(toolsViewFrame.width*0.2/2), y: toolsViewFrame.height*0.8, width: toolsViewFrame.width*0.15, height: toolsViewFrame.width*0.15)
        
        itemCollectionFrame = CGSize(width: toolsViewFrame.height*0.8*0.8, height: toolsViewFrame.height*0.8)
        
        hairsCollectionFrame = CGRect(x: 0.0, y: 0.0, width: toolsViewFrame.width, height: toolsViewFrame.height*0.7)
        
        paperImgFrame = CGRect(x: (view.frame.width-(view.frame.width*0.95))/2, y: self.view.frame.height*0.02, width: self.view.frame.width*0.95, height: self.view.frame.height*0.58)
    }
    
    public override func viewDidLayoutSubviews(){
        if view.frame != CGRect.zero {
            recalculateFrames()
            
            //Update frames
            sceneView.frame = sceneViewFrame
            toolsView.frame = toolsViewFrame
            playButton.frame = playButtonFrame
            bgImg.frame = self.view.frame
            paperImg.frame = paperImgFrame
            hairsCollection.frame = hairsCollectionFrame
            
            let flowLayout = hairsCollection.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = itemCollectionFrame
            
            scene.size = CGSize(width: sceneViewFrame.width, height: sceneViewFrame.height)
            scene.updateNodePositions()
        }
    }
    
}

extension UIColor {
    static var bluePen = UIColor(red:0.08, green:0.15, blue:0.52, alpha:1.0)
}
