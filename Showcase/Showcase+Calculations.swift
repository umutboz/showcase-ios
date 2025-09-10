//
//  Showcase+Calculations.swift
//  Showcase
//

//

import Foundation
import UIKit

extension Showcase {
    
    
    /**
     This method sum one CGPoint and returns Bool?.

     - parameter center: CGPoint
     - returns: Bool?.

     # Notes: #
     1. Parameters must be **CGPoint** type

     # Example #
    ```
     if let sum = self.isInGutter(center: point) {
     
     }
     ```
    */
    func isInGutter(center: CGPoint) -> Bool? {
        guard let containerView = containerView else {
            print("containerView is null")
            return nil}
        return center.y < offsetThreshold || containerView.frame.height - center.y < offsetThreshold
    }
    
    /**
        This method sum one UIView and returns CGPoint?.

        - parameter target: UIView
        - returns: CGPoint?.

        # Notes: #
        1. Parameters must be **CGPoint** type

        # Example #
       ```
        if let sum = self.getOuterCircleCenterPoint(target: view) {
        
        }
        ```
       */
    func getOuterCircleCenterPoint(for target: UIView) -> CGPoint? {
        guard let instructionView = instructionView else {
            print("instructionView is null")
            return nil }
        
        
        guard let isInGutter = isInGutter(center: target.center) else { return nil }
        if isInGutter {
            return target.center
        }
        else {
            
            guard let targetView = targetView else {
                print("targetView is null")
                return nil}
            
            guard let containerView = containerView else {
                print("containerView is null")
                return nil}
            
          
            
            let targetRadius = max(target.frame.width, target.frame.height) / 2 + TARGET_PADDING
            let totalTextHeight = instructionView.frame.height
            
            let onTop = getTargetPosition(target: targetView, container: containerView) == .below
            
            let left = min(instructionView.frame.minX, target.frame.minX - targetRadius)
            let right = max(instructionView.frame.maxX, target.frame.maxX + targetRadius)
            guard let titleHeight = instructionView.primaryLabel?.frame.height else {
                print("titleHeight is null")
                return nil}
            let centerY = onTop ? target.center.y - TARGET_HOLDER_RADIUS - TARGET_PADDING - totalTextHeight + titleHeight
                : target.center.y + TARGET_HOLDER_RADIUS + TARGET_PADDING + titleHeight
            
            return CGPoint(x: (left + right) / 2, y: centerY)
            
        }
        
        
    }
    /**
           This method sum three CGPoint,CGRect,CGRect and returns CGFloat?.

           - parameter center: CGPoint
           - parameter center: CGRect
           - parameter center: CGRect
           - returns: CGFloat?.

           # Notes: #
           1. Parameters must be **CGFloat** type

           # Example #
          ```
           if let sum = self.getOuterCircleRadius(tcenter: CGPoint, textBounds: CGRect, targetBounds: CGRect) {
           
           }
           ```
          */
    func getOuterCircleRadius(center: CGPoint, textBounds: CGRect, targetBounds: CGRect) -> CGFloat {
        let targetCenterX = targetBounds.midX
        let targetCenterY = targetBounds.midY
        
        let expandedRadius = 1.1 * TARGET_HOLDER_RADIUS
        let expandedBounds = CGRect(x: targetCenterX, y: targetCenterY, width: 0, height: 0)
        expandedBounds.insetBy(dx: -expandedRadius, dy: -expandedRadius);
        
        let textRadius = maxDistance(from: center, to: textBounds)
        let targetRadius = maxDistance(from: center, to: expandedBounds)
        return max(textRadius, targetRadius) + 40
    }
    
    func maxDistance(from point: CGPoint, to rect: CGRect) -> CGFloat {
        let tl = distance(point, CGPoint(x: rect.minX, y: rect.minY))
        let tr = distance(point, CGPoint(x: rect.maxX, y: rect.minY))
        let bl = distance(point, CGPoint(x: rect.minX, y: rect.maxY))
        let br = distance(point, CGPoint(x: rect.maxX, y: rect.maxY))
        return max(tl, max(tr, max(bl, br)))
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}
