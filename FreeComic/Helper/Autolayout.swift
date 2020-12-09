//
//  Autolayout.swift
//  SPA
//
//  Created by Trần Đô on 6/8/16.
//  Copyright © 2016 Do tran. All rights reserved.
//

import UIKit

class Autolayout: NSObject {
    
    static let shareInstance = Autolayout()
    
    func setWidth(view: UIView, SIZE: CGFloat){
        let viewsDic = ["view":view]
        let metricsDic = ["size":SIZE]
        let retConstraint:Array = NSLayoutConstraint.constraints(withVisualFormat: "H:[view(size)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metricsDic, views: viewsDic)
        view.addConstraints(retConstraint)
    }
    func setHeight(view: UIView, SIZE: CGFloat){
        let viewsDic = ["view":view]
        let metricsDic = ["size":SIZE]
        let retConstraint:Array = NSLayoutConstraint.constraints(withVisualFormat: "V:[view(size)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metricsDic, views: viewsDic)
        view.addConstraints(retConstraint)
    }
    func centerX(viewCon view1: AnyObject, viewCha view2: AnyObject?) -> NSLayoutConstraint{
        
        let centerXConstraint:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        return centerXConstraint
    }
    func centerY(viewCon view1: AnyObject, viewCha view2: AnyObject?) -> NSLayoutConstraint{
        
        let centerYConstraint:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        return centerYConstraint
    }
    func paddingTopInside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        
        let paddingTop:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: pixel)
        return paddingTop
    }
    func paddingBottomInside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        let paddingBottom:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: pixel)
        return paddingBottom
    }
    func paddingLeftInside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        
        let paddingLeft:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: pixel)
        return paddingLeft
    }
    func paddingRightInside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        
        let paddingLeft:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: pixel)
        return paddingLeft
    }
    func paddingBottomOutside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        
        let paddingTop:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: pixel)
        return paddingTop
    }
    func paddingTopOutside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        
        let paddingBottom:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: pixel)
        return paddingBottom
    }
    func paddingLeftOutside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        let paddingLeft:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: pixel)
        return paddingLeft
    }
    func paddingRightOutside(viewCon view1: AnyObject, viewCha view2: AnyObject?, pixel:CGFloat) -> NSLayoutConstraint{
        
        let paddingLeft:NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: pixel)
        return paddingLeft
    }
}
extension UIView{
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for index in views.enumerated() {
            let key = "v\(index.offset)"
            viewsDictionary[key] = index.element
            index.element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
