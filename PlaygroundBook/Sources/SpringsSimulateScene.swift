//
//  SpringsSimulateScene.swift
//  Book_Sources
//
//  Created by Débora Oliveira on 21/03/19.
//

import UIKit
import SpriteKit

class SpringsSimulateScene: SKScene {
    var springView = SpringView()
    var shape : SKShapeNode!
    
    public var springWeight = 3.0
    public var springRepetions = 5
    public var springCurlWidth = CGFloat(60.0)
    public var springColor = UIColor.black
    public var springRay = CGFloat(0.5)
    
    var sceneNumber = 1
    var allSprings : [SKPhysicsJointSpring] = []
    var movingBox : SKSpriteNode? = nil
    
    var isAnimating = false
    
    override init(size: CGSize) {
        super.init(size: size)
        springRay = CGFloat(self.frame.height*0.001)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func sceneDidLoad() {
        self.setupScene()
    }
    
    func updateNodePositions() {
        self.removeAllChildren()
        drawNodes()
    }
    
    func drawNodes() {
        self.anchorPoint = CGPoint(x:0.0, y:1.0)
        
        //Add simulator
        for s in 1...3 {
            let verticalOffset = Double(-self.frame.height*0.03)
            let squareSize = self.frame.height*0.15
            let wallSize = self.frame.width*0.02
            
            //Achor point of spring
            let staticTexture = SKTexture(imageNamed: "block_vertical.png")
            let staticNode = SKSpriteNode(texture: staticTexture, size: CGSize(width: wallSize, height: squareSize*1.5))
            
            staticNode.name = "static\(s)"
            staticNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wallSize, height: squareSize))
            let offsetNode = Double(squareSize/2+5.0)
            staticNode.physicsBody?.isDynamic = false
            staticNode.position = CGPoint(x: 0.0, y: verticalOffset*Double(s*10)+offsetNode)
            //Blue box interactable
            let boxTexture = SKTexture(imageNamed: "box\(s).png")
            let dynamicNode = SKSpriteNode(texture: boxTexture, size: CGSize(width: squareSize, height: squareSize))
            dynamicNode.zPosition = CGFloat(4*s)
            dynamicNode.name = "dynamic\(s)"
            dynamicNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: squareSize, height: squareSize))
            dynamicNode.physicsBody?.friction = 0.0
            dynamicNode.physicsBody?.angularDamping = 0.0
            dynamicNode.position = CGPoint(x: Double(self.frame.width*0.5), y: verticalOffset*Double(s*10)+30)
            //Ground
            let blockTexture = SKTexture(imageNamed: "block_horizontal.png")
            let blockNode = SKSpriteNode(texture: blockTexture, size: CGSize(width: self.frame.width, height: wallSize))
            blockNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width*6, height: wallSize))
            blockNode.physicsBody?.isDynamic = false
            blockNode.physicsBody?.friction = 0.0
            blockNode.physicsBody?.angularDamping = 0.0
            blockNode.position = CGPoint(x: Double(self.frame.width/2), y: verticalOffset*Double(s*10))
            
            //Spring physics
            let spring = SKPhysicsJointSpring.joint(withBodyA: staticNode.physicsBody!,
                                                    bodyB: dynamicNode.physicsBody!,
                                                    anchorA: staticNode.position,
                                                    anchorB: dynamicNode.position)
            spring.frequency = 0.5 // frequencia do movimento
            spring.damping = 0.4 //rigidez da mola
            allSprings.append(spring)
            
            //Srping drawing
            let bezier = springView.createCurl(start: dynamicNode.position, end: staticNode.position, direction: .horizontal, repetions: springRepetions, width: springCurlWidth, ray : springRay)
            shape = SKShapeNode(path: bezier.cgPath)
            shape.name = "spring\(s)"
            shape.lineWidth = CGFloat(springWeight)
            shape.strokeColor = springColor
            
            //Add elements
            self.addChild(staticNode)
            self.addChild(dynamicNode)
            self.addChild(blockNode)
            self.addChild(shape)
            self.physicsWorld.add(spring)
        }
    }
    
    func setupScene() {
        drawNodes()
        
        //Initial animations
        playAnimations()
    }
    
    func playAnimations() {
        if !isAnimating {
            isAnimating = true
            afterStopMoving()
            
            let dynamicSN1 = self.childNode(withName: "dynamic2") as! SKSpriteNode
            let dynamicSN2 = self.childNode(withName: "dynamic3") as! SKSpriteNode
            
            let move1 = SKAction.moveBy(x: self.frame.width, y: 0.0, duration: 1)
            dynamicSN1.run(move1)
            let move2 = SKAction.moveBy(x: -self.frame.width, y: 0.0, duration: 1)
            dynamicSN2.run(move2)
        }
    }
    
    func afterStopMoving() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.isAnimating = false
            timer.invalidate()
        }
    }
    
    override public func update(_ currentTime: TimeInterval) {
        
        //Redraw block if it's out of screen
        for s in 1...3 {
            // Get the blocks nodes
            let dynamicSN = self.childNode(withName: "dynamic\(s)") as! SKSpriteNode
            
            if dynamicSN.position.x < self.frame.minX || dynamicSN.position.x > self.frame.maxX {
                movingBox = nil
            }
        }
        for s in 1...3 {
            // Get the blocks nodes
            let dynamicSN = self.childNode(withName: "dynamic\(s)") as! SKSpriteNode
            let staticSN = self.childNode(withName: "static\(s)") as! SKSpriteNode
            //            let s = 1
            let spring = self.childNode(withName: "spring\(s)")
            spring!.removeFromParent()
            
            
            // Redraw spring
            let bezier = springView.createCurl(start: dynamicSN.position, end: staticSN.position, direction: .horizontal, repetions: springRepetions, width: springCurlWidth, ray: springRay)
            
            let shape = SKShapeNode.init(path: bezier.cgPath)
            shape.name = "spring\(s)"
            shape.lineWidth = CGFloat(springWeight)
            shape.strokeColor = springColor
            self.addChild(shape)
        }
    }
}


extension SpringsSimulateScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if location.x > 0 && location.x < self.frame.maxX {
                let nodes = self.nodes(at: location)
                
                if let box = nodes.first(where: {$0.name == "dynamic1" || $0.name == "dynamic2" || $0.name == "dynamic3"}) {
                    movingBox = box as? SKSpriteNode
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.previousLocation(in: self)
            
            print("\n\(location.x)")
            // FIX = arrasta até fora da tela
            if location.x > 0 && location.x < self.frame.maxX {
                movingBox?.position = CGPoint(x: touch.location(in: self).x , y: (movingBox?.position.y)!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingBox = nil
    }
}
