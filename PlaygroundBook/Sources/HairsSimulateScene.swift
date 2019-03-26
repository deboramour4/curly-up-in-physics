//
//  SpringsSimulateScene.swift
//  Book_Sources
//
//  Created by Débora Oliveira on 21/03/19.
//

import UIKit
import SpriteKit

class HairsSimulateScene: SKScene {
    var springView = SpringView()
    var shape : SKShapeNode!
    var originalSpringPosition : CGPoint!
    
    public var springWeight = 2.0
    public var springRepetions = 2
    public var springCurlWidth = CGFloat(0.0)
    public var springColor = UIColor.orange
    public var springRay = CGFloat(0.5)
    
    var boxSpring = SKPhysicsJointSpring()
    var movingBox : SKSpriteNode? = nil
    
    var isAnimating = false
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func sceneDidLoad() {
        self.setupScene()
    }
    
    func setupScene() {
        //Draw Nodes
        drawNodes()
        
        //Initial animations
        playAnimations()
    }
    
    func updateNodePositions() {
        self.removeAllChildren()
        drawNodes()
    }
    func drawNodes() {
        springCurlWidth = CGFloat(100.0)/CGFloat(springRepetions)
        originalSpringPosition = CGPoint(x: Double(self.frame.width/2), y: Double(-self.frame.height*0.6))
        
        self.anchorPoint = CGPoint(x:0.0, y:1.0)
        
        //ADD Simulator
        let squareSize = self.frame.height*0.1
        let wallSize = self.frame.width*0.02
        
        //Achor point of spring
        let blockTexture = SKTexture(imageNamed: "block_horizontal.png")
        let staticNode = SKSpriteNode(texture: blockTexture, size: CGSize(width: squareSize, height: wallSize))
        staticNode.name = "static"
        staticNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: squareSize, height: wallSize))
        staticNode.physicsBody?.isDynamic = false
        staticNode.position = CGPoint(x: self.frame.width/2, y: 0.0)
        //Blue box interactable
        let dynamicNode = SKSpriteNode(color: .clear, size: CGSize(width: squareSize*3, height: squareSize*3))
        dynamicNode.name = "dynamic"
        dynamicNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: squareSize*3, height: squareSize*3))
        dynamicNode.physicsBody?.friction = 0.0
        dynamicNode.physicsBody?.angularDamping = 0.0
        dynamicNode.position = originalSpringPosition
        dynamicNode.physicsBody?.mass = 1.0 //?
        
        //Spring physics
        let spring = SKPhysicsJointSpring.joint(withBodyA: staticNode.physicsBody!,
                                                bodyB: dynamicNode.physicsBody!,
                                                anchorA: staticNode.position,
                                                anchorB: originalSpringPosition)
        spring.frequency = 0.5 // frequencia do movimento
        spring.damping = 0.4 //rigidez da mola
        boxSpring = spring
        
        //String drawing
        let bezier = springView.createCurl(start: originalSpringPosition, end: staticNode.position, direction: .vertical, repetions: springRepetions, width: springCurlWidth, ray : springRay)
        shape = SKShapeNode(path: bezier.cgPath)
        shape.name = "spring"
        shape.lineWidth = CGFloat(springWeight)
        shape.lineCap = .round
        shape.strokeColor = springColor
        
        //Add elements
        self.addChild(staticNode)
        self.addChild(dynamicNode)
        self.addChild(shape)
        self.physicsWorld.add(spring)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
    }
    
    func playAnimations() {
        if !isAnimating {
            isAnimating = true
            afterStopMoving()
            
            let dynamicSN = self.childNode(withName: "dynamic") as! SKSpriteNode
            
            let move = SKAction.moveBy(x: 0.0, y: self.frame.height, duration: 1)
            dynamicSN.run(move)
            
        }
    }
    
    func afterStopMoving() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.isAnimating = false
            timer.invalidate()
        }
    }
    
    func didClickedInHair(_ hair : (String, Double, Int,CGFloat, Bool)) {
        // FIX Change only if box is not moving
        //Reset spring values
        springWeight = hair.1
        springRepetions = hair.2
        springRay = hair.3
        
        //Find the nodes
        let staticNode = self.childNode(withName: "static") as! SKSpriteNode
        let dynamicNode = self.childNode(withName: "dynamic") as! SKSpriteNode
        dynamicNode.position = originalSpringPosition
        
        //Remove springs from world and add new one
        self.physicsWorld.remove(boxSpring)
        
        let spring = SKPhysicsJointSpring.joint(withBodyA: staticNode.physicsBody!,
                                                bodyB: dynamicNode.physicsBody!,
                                                anchorA: staticNode.position,
                                                anchorB: originalSpringPosition)
        spring.frequency = CGFloat(springWeight/3.0)
        spring.damping = CGFloat(springWeight/10.0) //5.0 is the max value of weight
        
        boxSpring = spring
        self.physicsWorld.add(spring)
        
        redrawStringPath()
        
    }
    
    func redrawStringPath() {
        // Get the blocks nodes
        let staticSN = self.childNode(withName: "static") as! SKSpriteNode
        let dynamicSN = self.childNode(withName: "dynamic") as! SKSpriteNode
        
        let spring = self.childNode(withName: "spring")
        spring!.removeFromParent()
        
        // Redraw spring
        let bezier = springView.createCurl(start: dynamicSN.position, end: staticSN.position, direction: .vertical, repetions: springRepetions, width: springCurlWidth, ray: springRay)
        
        let shape = SKShapeNode.init(path: bezier.cgPath)
        shape.name = "spring"
        shape.lineWidth = CGFloat(springWeight)
        shape.lineCap = .round
        shape.strokeColor = springColor
        self.addChild(shape)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        redrawStringPath()
    }
}


extension HairsSimulateScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if location.y > self.frame.minY || location.y < self.frame.maxY  {
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
            
            if location.y > self.frame.minY || location.y < self.frame.maxY {
                movingBox?.position = CGPoint(x: (movingBox?.position.x)!, y: touch.location(in: self).y)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingBox = nil
    }
}
