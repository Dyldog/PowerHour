//
//  UIView+Extensions.swift
//  PowerHour2
//
//  Created by Dylan Elliott on 25/9/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

extension UIView {
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        let path = path
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func mask(withPercentage: CGFloat, angle: CGFloat, inverse: Bool = false) {
        let rectAngle : CGFloat = angle
        let desiredRectSizeRatio : CGFloat = withPercentage
        
        let angularHeightDiff : CGFloat = tan(rectAngle) * self.frame.width / 2.0
        let realTotalHeight : CGFloat = self.frame.height + 2 * angularHeightDiff
        let viewAndAngularHeightRatio : CGFloat = realTotalHeight / self.frame.height
        
        let realRectSizeRatio : CGFloat = desiredRectSizeRatio * viewAndAngularHeightRatio - (viewAndAngularHeightRatio - 1)  / 2.0
        let rectSizeRatio : CGFloat = realRectSizeRatio
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0,y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height * rectSizeRatio - angularHeightDiff))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height * rectSizeRatio + angularHeightDiff))
        path.close()
        
        self.mask(withPath: path, inverse: inverse)
    }

}


