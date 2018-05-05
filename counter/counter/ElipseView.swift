//
//  ElipseView.swift
//  counter
//
//  Created by hortune on 2018/4/11.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit

@IBDesignable
class ElipseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var fillColor: UIColor = UIColor.black {
        didSet{
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var strokeWidth: CGFloat = 0
    @IBInspectable var strokeColor: UIColor = UIColor.clear

    
    override func draw(_ rect: CGRect){
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else{return}
        
        context.saveGState()
        
        defer{
            context.restoreGState()
        }
        let rectangle = bounds.insetBy(dx: strokeWidth, dy: strokeWidth)
        
        
        
        
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(strokeWidth)
        
        context.addEllipse(in: rectangle)
        context.drawPath(using: .fillStroke)
    }

}
