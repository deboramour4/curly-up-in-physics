//
//  SpringsMotionScene.swift
//  Book_Sources
//
//  Created by Débora Oliveira on 21/03/19.
//

import UIKit
import SpriteKit

class SpringMotionScene: SKScene {
    var springView = SpringView()
    var shape : SKShapeNode!
    var originalSpringPosition : CGPoint!

    
    public var springWeight = 3.0 {
        didSet {
            didChangedWeight(springWeight)
        }
    }
    public var springRepetions = 5
    public var springCurlWidth = CGFloat(60.0)
    public var springColor = UIColor.black
    public var springRay = CGFloat(0.5)
    
    var boxSpring = SKPhysicsJointSpring()
    var movingBox : SKSpriteNode? = nil
    
    var isAnimating = false
    
    override init(size: CGSize) {
        super.init(size: size)
        springRay = CGFloat(self.frame.height*0.002)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func sceneDidLoad() {
        self.setupScene()
    }
    
    func setupScene() {
        drawNodes()
    }
    
    func drawNodes() {
        self.anchorPoint = CGPoint(x:0.0, y:1.0)

        //ADD Simulator
        let verticalOffset = Double(-self.frame.height*0.7)
        let squareSize = self.frame.height*0.3
        let wallSize = self.frame.width*0.02
        let offsetNode = Double(squareSize/2+5.0)
        originalSpringPosition = CGPoint(x: Double(self.frame.width/2), y: verticalOffset+offsetNode)
        
        //Achor point of spring
        let staticTexture = SKTexture(imageNamed: "block_vertical.png")
        let staticNode = SKSpriteNode(texture: staticTexture, size: CGSize(width: wallSize, height: squareSize*1.5))
        staticNode.name = "static"
        staticNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wallSize, height: squareSize))
        staticNode.physicsBody?.isDynamic = false
        staticNode.position = CGPoint(x: 0.0, y: verticalOffset+offsetNode)
        
        //Blue box interactable
        let boxTexture = SKTexture(imageNamed: "box1.png")
        let dynamicNode = SKSpriteNode(texture: boxTexture, size: CGSize(width: squareSize, height: squareSize))
        dynamicNode.zPosition = 4.0
        dynamicNode.name = "dynamic"
        dynamicNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: squareSize, height: squareSize))
        dynamicNode.physicsBody?.friction = 0.0
        dynamicNode.physicsBody?.angularDamping = 0.0
        dynamicNode.position = originalSpringPosition
        
        //Ground
        let blockTexture = SKTexture(imageNamed: "block_horizontal.png")
        let blockNode = SKSpriteNode(texture: blockTexture, size: CGSize(width: self.frame.width, height: wallSize))
        blockNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width*6, height: wallSize))
        blockNode.physicsBody?.isDynamic = false
        blockNode.physicsBody?.friction = 0.0
        blockNode.physicsBody?.angularDamping = 0.0
        blockNode.position = CGPoint(x: Double(self.frame.width/2), y: verticalOffset)
        
        //Spring physics
        let spring = SKPhysicsJointSpring.joint(withBodyA: staticNode.physicsBody!,
                                                bodyB: dynamicNode.physicsBody!,
                                                anchorA: staticNode.position,
                                                anchorB: dynamicNode.position)
        spring.frequency = 0.5 // frequencia do movimento
        spring.damping = 0.4 //rigidez da mola
        boxSpring = spring
        
        //Srping drawing
        let bezier = springView.createCurl(start: dynamicNode.position, end: staticNode.position, direction: .horizontal, repetions: springRepetions, width: springCurlWidth, ray : springRay)
        shape = SKShapeNode(path: bezier.cgPath)
        shape.name = "spring"
        shape.lineWidth = CGFloat(springWeight)
        shape.strokeColor = springColor
        
        //Add elements
        self.addChild(staticNode)
        self.addChild(dynamicNode)
        self.addChild(blockNode)
        self.addChild(shape)
        self.physicsWorld.add(spring)
    }
    
    func updateNodePositions() {
        self.removeAllChildren()
        drawNodes()
    }
    
    func didChangedWeight(_ value : Double) {
        // FIX Change only if box is not moving
        
        //Remove springs from world
        self.physicsWorld.remove(boxSpring)
        
        //Find the nodes
        let staticNode = self.childNode(withName: "static") as! SKSpriteNode
        let dynamicNode = self.childNode(withName: "dynamic") as! SKSpriteNode
        dynamicNode.position = originalSpringPosition

        
        //Add new springs with different parameters
        let spring = SKPhysicsJointSpring.joint(withBodyA: staticNode.physicsBody!,
                                                bodyB: dynamicNode.physicsBody!,
                                                anchorA: staticNode.position,
                                                anchorB: dynamicNode.position)
        spring.frequency = CGFloat(value/3.0)
        spring.damping = CGFloat(value/10.0) //5.0 is the max value of weight
        boxSpring = spring
        self.physicsWorld.add(spring)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        
        // Get the blocks nodes
        let dynamicSN = self.childNode(withName: "dynamic") as! SKSpriteNode
        if dynamicSN.position.x < self.frame.minX || dynamicSN.position.x > self.frame.maxX {
            movingBox = nil
        }
        if dynamicSN.position.x < self.frame.minX-100.0  || dynamicSN.position.x > self.frame.maxX+50.0  {
            dynamicSN.position = originalSpringPosition
        } else {
            let staticSN = self.childNode(withName: "static") as! SKSpriteNode
            //            let s = 1
            let spring = self.childNode(withName: "spring")
            spring!.removeFromParent()
            
            // Redraw spring
            let bezier = springView.createCurl(start: dynamicSN.position, end: staticSN.position, direction: .horizontal, repetions: springRepetions, width: springCurlWidth, ray: springRay)
            
            let shape = SKShapeNode.init(path: bezier.cgPath)
            shape.name = "spring"
            shape.lineWidth = CGFloat(springWeight)
            shape.strokeColor = springColor
            self.addChild(shape)
        }
    }
}

extension SpringMotionScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if location.x > 0 && location.x < self.frame.maxX {
                let nodes = self.nodes(at: location)
                
                if let box = nodes.first(where: {$0.name == "dynamic"}) {
                    movingBox = box as? SKSpriteNode
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.previousLocation(in: self)
            
            if location.x > 0 && location.x < self.frame.maxX {
                movingBox?.position = CGPoint(x: touch.location(in: self).x , y: (movingBox?.position.y)!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingBox = nil
    }
}
