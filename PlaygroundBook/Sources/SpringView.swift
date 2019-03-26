//
//  DrawView.swift
//  wwdc-scholarship-2019
//
//  Created by Débora Oliveira on 18/03/19.
//  Copyright © 2019 Débora Oliveira. All rights reserved.
//

import UIKit

public class SpringView: UIView {
    
    var offset : CGFloat? = nil
    let RADS = Double.pi/180
    
    public enum Direction {
        case horizontal
        case vertical
    }
    
    public func createCurl(start: CGPoint, end: CGPoint, direction d : Direction , repetions r : Int, width : CGFloat = 100.0, weight : CGFloat = 5.0, ray : CGFloat = 0.5) -> UIBezierPath{
        
        let path = UIBezierPath()
        
        var origin = CGPoint(x: start.x , y: start.y)
        path.move(to: origin)
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        
        if d == .horizontal {
            let deltaX = end.x - start.x
            let eqProp = deltaX/CGFloat(r)
            let ampX = eqProp/72
            
            // Amplitude height
            let ampY: CGFloat = 50.0
            
            for _ in 0...r-1 {
                stride(from: 0.0, through: 360.0 , by: 5.0).enumerated().forEach { (i, angle) in
                    x = origin.x - CGFloat(cos(angle * RADS)) * width * 0.3  + CGFloat(i)*ampX
                    y = origin.y - CGFloat(sin(angle * RADS)) * ampY * ray
                    
                    guard let offset = self.offset else {
                        self.offset = origin.x - x
                        return
                    }
                    path.addLine(to: CGPoint(x: x+offset, y: y))
                }
                origin = CGPoint(x: x+offset!, y: y)
            }
        } else if d == .vertical {
            
            let deltaY = end.y - start.y
            let eqProp = deltaY/CGFloat(r)
            let ampY = eqProp/72
            
            // Amplitude height
            let ampX: CGFloat = 50.0
            
            for _ in 0...r-1 {
                stride(from: 0.0, through: 360.0 , by: 5.0).enumerated().forEach { (i, angle) in
                    x = origin.x - CGFloat(sin(angle * RADS)) * ampX * ray
                    y = origin.y - CGFloat(cos(angle * RADS)) * width * CGFloat(0.3)  + CGFloat(i)*ampY
                    
                    guard let offset = self.offset else {
                        self.offset = origin.y - y
                        return
                    }
                    path.addLine(to: CGPoint(x: x, y: y+offset))
                }
                origin = CGPoint(x: x, y: y+offset!)
            }
            
        }
        path.lineCapStyle = .round
        return path
    }
    
    func debugPoint(_ point: CGPoint, _ color: UIColor = UIColor.yellow) {
        let rec = UIView(frame: CGRect.init(origin: point, size: CGSize(width: 5.0, height: 5.0)))
        rec.backgroundColor = color
        self.addSubview(rec)
    }
}
