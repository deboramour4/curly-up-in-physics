//
//  ViewController.swift
//  wwdc-scholarship-2019
//
//  Created by Débora Oliveira on 17/03/19.
//  Copyright © 2019 Débora Oliveira. All rights reserved.
//

import UIKit
import SpriteKit

public class SpringsSimulateViewController: UIViewController {
    
    var scene : SpringsSimulateScene!
    
    var sceneViewFrame = CGRect(x:0.0, y: 0.0, width: 0.0, height: 0.0)
    var toolsViewFrame = CGRect(x:0.0, y: 0.0, width: 0.0, height: 0.0)
    var playButtonFrame = CGRect(x:0.0, y: 0.0, width: 0.0, height: 0.0)
    var equilibriumImgFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var paperImgFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    var rulesImgFrame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    
    public lazy var bgImg : UIImageView = {
        let bgImg = UIImageView(frame: self.view.frame)
        bgImg.image = UIImage(named: "background.png")
        bgImg.contentMode = .scaleAspectFill
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
    // Button play
    public lazy var playButton : UIButton = {
        let playButton = UIButton(type: .custom)
        playButton.frame = playButtonFrame
        playButton.setBackgroundImage(UIImage(named: "play.png"), for: .normal)
        playButton.setImage(UIImage(named: "play.png"), for: .selected)
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        return playButton
    }()
    
    public lazy var equilibriumImg : UIImageView = {
        let rulesImg = UIImageView(frame: equilibriumImgFrame)
        rulesImg.image = UIImage(named: "equilibrium.png")
        rulesImg.contentMode = .scaleAspectFit
        return rulesImg
    }()
    public lazy var paperImg : UIImageView = {
        let paperImg = UIImageView(frame: paperImgFrame)
        paperImg.image = UIImage(named: "paper_2.png")
        paperImg.contentMode = .scaleToFill
        return paperImg
    }()
    public lazy var rulesImg : UIImageView = {
        let rulesImg = UIImageView(frame: rulesImgFrame)
        rulesImg.image = UIImage(named: "ruler.png")
        rulesImg.contentMode = .scaleToFill
        return rulesImg
    }()
    
    @objc public func didPressPlayButton() {
        let curlsScene = sceneView.scene as! SpringsSimulateScene
        curlsScene.playAnimations()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        recalculateFrames()
        
        view.addSubview(bgImg)
        view.addSubview(paperImg)
        
    
        toolsView.addSubview(playButton)
        view.addSubview(toolsView)
        
        sceneView.addSubview(equilibriumImg)
        sceneView.sendSubviewToBack(equilibriumImg)
        view.addSubview(sceneView)
        
        scene = SpringsSimulateScene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = SKColor.clear
        sceneView.backgroundColor = UIColor.clear
//        sceneView.showsPhysics = true
//        sceneView.showsNodeCount = true
        sceneView.presentScene(scene)
        
        sceneView.addSubview(rulesImg)
    }
    func recalculateFrames() {
        sceneViewFrame = CGRect(x: (view.frame.width-(view.frame.width*0.8))/2, y: view.frame.height*0.15, width: view.frame.width*0.8, height: (view.frame.height*0.5))
        toolsViewFrame = CGRect(x: (view.frame.width-(view.frame.width*0.8))/2, y: view.frame.height*0.8, width: view.frame.width*0.8, height: view.frame.height*0.25)
        playButtonFrame = CGRect(x: (toolsViewFrame.width-(toolsViewFrame.width*0.2))/2, y: -10.0, width: view.frame.width*0.15, height: view.frame.width*0.15)
        
        equilibriumImgFrame = CGRect(x: (sceneViewFrame.width-(sceneViewFrame.width*0.5))/2, y: -sceneViewFrame.height*0.05, width: sceneViewFrame.width*0.5, height: sceneViewFrame.height*1.1)
        rulesImgFrame = CGRect(x: 0.0, y: sceneViewFrame.height*1.1, width: sceneViewFrame.width, height: sceneViewFrame.height*0.1)
        paperImgFrame = CGRect(x: (view.frame.width-(view.frame.width*0.95))/2, y: self.view.frame.height*0.02, width: self.view.frame.width*0.95, height: self.view.frame.height*0.75)
    }
    
    public override func viewDidLayoutSubviews(){
        if view.frame != CGRect.zero {
            recalculateFrames()
            
            //Update frames
            sceneView.frame = sceneViewFrame
            toolsView.frame = toolsViewFrame
            playButton.frame = playButtonFrame
            equilibriumImg.frame = equilibriumImgFrame
            paperImg.frame = paperImgFrame
            rulesImg.frame = rulesImgFrame
            bgImg.frame = self.view.frame
            
            scene.size = CGSize(width: sceneViewFrame.width, height: sceneViewFrame.height)
            scene.updateNodePositions()
        }
    }
}

