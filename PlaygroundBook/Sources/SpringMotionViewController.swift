//
//  ViewController.swift
//  wwdc-scholarship-2019
//
//  Created by Débora Oliveira on 17/03/19.
//  Copyright © 2019 Débora Oliveira. All rights reserved.
//

import UIKit
import SpriteKit

public class SpringMotionViewController: UIViewController {
    
    var scene : SpringMotionScene!
    
    var sceneViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var toolsViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var dragLabelFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var typesHairFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var sliderWeightFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var sliderRepetionsFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var rulesImgFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var paperImgFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var typesHairImgFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var textSize = CGFloat(0.0)
    
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
        //        toolsView.backgroundColor = .yellow
        return toolsView
    }()
    // Riffness
    public lazy var sliderWeight : UISlider = {
        let sliderWeight = UISlider(frame: sliderWeightFrame)
        sliderWeight.minimumValue = 1.0
        sliderWeight.maximumValue = 5.0
        sliderWeight.value = 3.0
        sliderWeight.isContinuous = true
        sliderWeight.tintColor = UIColor.bluePen
        sliderWeight.minimumValueImage = UIImage(named: "loose.png")
        sliderWeight.maximumValueImage = UIImage(named: "stiff.png")
        sliderWeight.setThumbImage(UIImage(named: "slider_box.png"), for: .normal)
        sliderWeight.addTarget(self, action: #selector(sliderWeightValueDidChange(_:)), for: .valueChanged)
        return sliderWeight
    }()
    
    public lazy var dragLabel : UILabel = {
        let dragLabel = UILabel(frame: dragLabelFrame)
        dragLabel.textColor = UIColor.bluePen
        dragLabel.text = "Drag the ball to simulate force applied"
        dragLabel.textAlignment = .center
        dragLabel.font = UIFont(name: "Gaegu-Regular", size: textSize)
        return dragLabel
    }()
    public lazy var typesHairLabel : UILabel = {
        let typesHairLabel = UILabel(frame: dragLabelFrame)
        typesHairLabel.textColor = UIColor.bluePen
        typesHairLabel.text = "Your spring is\nsimilar to which\ncurl type?"
        typesHairLabel.textAlignment = .center
        typesHairLabel.numberOfLines = 3
        typesHairLabel.font = UIFont(name: "Gaegu-Regular", size: 20)
        return typesHairLabel
    }()
    public lazy var rulesImg : UIImageView = {
        let rulesImg = UIImageView(frame: rulesImgFrame)
        rulesImg.image = UIImage(named: "ruler.png")
        rulesImg.contentMode = .scaleToFill
        return rulesImg
    }()
//    public lazy var typesHairImg : UIImageView = {
//        let typesHairImg = UIImageView(frame: typesHairImgFrame)
//        typesHairImg.image = UIImage(named: "box3.png")
//        typesHairImg.contentMode = .scaleToFill
//        return typesHairImg
//    }()
    public lazy var paperImg : UIImageView = {
        let paperImg = UIImageView(frame: paperImgFrame)
        paperImg.image = UIImage(named: "paper_3.png")
        paperImg.contentMode = .scaleToFill
        return paperImg
    }()
    
    public lazy var sliderRepetions : UISlider = {
        let sliderRepetions = UISlider(frame: sliderRepetionsFrame)
        sliderRepetions.minimumValue = 2
        sliderRepetions.maximumValue = 8
        sliderRepetions.value = 3.0
        sliderRepetions.isContinuous = true
        sliderRepetions.tintColor = UIColor.bluePen
        sliderRepetions.minimumValueImage = UIImage(named: "wavy.png")
        sliderRepetions.maximumValueImage = UIImage(named: "coily.png")
        sliderRepetions.setThumbImage(UIImage(named: "slider_box.png"), for: .normal)
        sliderRepetions.addTarget(self, action: #selector(sliderRepetionsValueDidChange(_:)), for: .valueChanged)
        return sliderRepetions
    }()
    
    @objc public func sliderWeightValueDidChange(_ sender:UISlider!) {
        //Update spring weight in scene
        let curlsScene = sceneView.scene as! SpringMotionScene
        curlsScene.springWeight = Double(sender.value)
    }
    
    @objc public func sliderRepetionsValueDidChange(_ sender:UISlider!) {
        //Update spring weight in scene
        let curlsScene = sceneView.scene as! SpringMotionScene
        curlsScene.springRepetions = Int(sender.value)
    }
    
    func recalculateFrames() {
        sceneViewFrame = CGRect(x: (view.frame.width-(view.frame.width*0.8))/2, y: self.view.frame.height*0.1, width: self.view.frame.width*0.8, height: self.view.frame.height*0.3)
        toolsViewFrame = CGRect(x: (view.frame.width-(view.frame.width*0.8))/2, y: self.view.frame.height*0.45, width: self.view.frame.width*0.8, height: self.view.frame.height*0.5-100.0)
        sliderWeightFrame = CGRect(x: 0.0, y: 0.0, width: toolsViewFrame.width, height: toolsViewFrame.height*0.2)
        sliderRepetionsFrame = CGRect(x: 0.0, y: toolsViewFrame.height*0.3, width: toolsViewFrame.width, height: toolsViewFrame.height*0.2)
        
        typesHairFrame = CGRect(x: (view.frame.width-(view.frame.width*0.4))/2, y: self.view.frame.height*0.6, width: self.view.frame.width*0.4, height: self.view.frame.height*0.3)
        typesHairImgFrame = CGRect(x: (view.frame.width-(view.frame.width*0.4))/2, y: self.view.frame.height*0.7, width: self.view.frame.width*0.4, height: self.view.frame.width*0.4)
        
        dragLabelFrame = CGRect(x: 0.0, y: 0.0, width: sceneViewFrame.width, height: sceneViewFrame.height*0.3)
        rulesImgFrame = CGRect(x: 0.0, y: sceneViewFrame.height*0.8, width: sceneViewFrame.width, height: sceneViewFrame.height*0.2)
        
        paperImgFrame = CGRect(x: (view.frame.width-(view.frame.width*0.95))/2, y: self.view.frame.height*0.02, width: self.view.frame.width*0.95, height: self.view.frame.height*0.85)
        
        textSize = sceneViewFrame.width*0.06
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        recalculateFrames()
        
        view.addSubview(bgImg)
        view.addSubview(paperImg)
        
        toolsView.addSubview(sliderWeight)
        toolsView.addSubview(sliderRepetions)
        
        view.addSubview(sceneView)
        view.addSubview(toolsView)
        view.addSubview(typesHairLabel)
//        view.addSubview(typesHairImg)
        
        scene = SpringMotionScene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = SKColor.clear
        sceneView.backgroundColor = UIColor.clear
//        sceneView.showsPhysics = true
//        sceneView.showsNodeCount = true
        sceneView.presentScene(scene)
        
        sceneView.addSubview(dragLabel)
        sceneView.addSubview(rulesImg)
    }
    
    public override func viewDidLayoutSubviews(){
        if view.frame != CGRect.zero {
            recalculateFrames()
            
            //Update frames
            sceneView.frame = sceneViewFrame
            toolsView.frame = toolsViewFrame
            sliderWeight.frame = sliderWeightFrame
            sliderRepetions.frame = sliderRepetionsFrame
            typesHairLabel.frame = typesHairFrame
            dragLabel.frame = dragLabelFrame
            bgImg.frame = self.view.frame
            rulesImg.frame = rulesImgFrame
            paperImg.frame = paperImgFrame
//            typesHairImg.frame = typesHairFrame
            
            dragLabel.font = dragLabel.font.withSize(textSize)
            typesHairLabel.font = dragLabel.font.withSize(textSize)
            
            scene.size = CGSize(width: sceneViewFrame.width, height: sceneViewFrame.height)
            scene.updateNodePositions()
        }
    }
}

