//
//  VisaCard.swift
//  JudoKit
//
//  Created by Hamon Riazy on 03/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import Foundation

public class VisaCardView: UIView {
    
    public override func drawRect(rect: CGRect) {
        drawVisaCard()
    }
    
}

func drawVisaCard() {
    //// Color Declarations
    let fillColor = UIColor(red: 0.647, green: 0.647, blue: 0.647, alpha: 1.000)
    let fillColor3 = UIColor(red: 0.032, green: 0.268, blue: 0.546, alpha: 1.000)
    
    //// ic_card_visa.svg
    //// Group 2
    //// Group 3
    //// Group 4
    
    //// Group 5
    //// Group 6
    
    
    //// Group 7
    //// Bezier 5 Drawing
    let bezier5Path = UIBezierPath()
    bezier5Path.moveToPoint(CGPointMake(21.3, 23))
    bezier5Path.addLineToPoint(CGPointMake(23.8, 7.4))
    bezier5Path.addLineToPoint(CGPointMake(27.9, 7.4))
    bezier5Path.addLineToPoint(CGPointMake(25.3, 23))
    bezier5Path.addLineToPoint(CGPointMake(21.3, 23))
    bezier5Path.closePath()
    bezier5Path.miterLimit = 4;
    
    fillColor3.setFill()
    bezier5Path.fill()
    
    //// Group 8
    //// Bezier 6 Drawing
    let bezier6Path = UIBezierPath()
    bezier6Path.moveToPoint(CGPointMake(39.9, 7.8))
    bezier6Path.addCurveToPoint(CGPointMake(36.3, 7.1), controlPoint1: CGPointMake(39.1, 7.5), controlPoint2: CGPointMake(37.9, 7.1))
    bezier6Path.addCurveToPoint(CGPointMake(29.5, 12.2), controlPoint1: CGPointMake(32.3, 7.1), controlPoint2: CGPointMake(29.5, 9.2))
    bezier6Path.addCurveToPoint(CGPointMake(33, 16.4), controlPoint1: CGPointMake(29.5, 14.4), controlPoint2: CGPointMake(31.5, 15.7))
    bezier6Path.addCurveToPoint(CGPointMake(35.1, 18.3), controlPoint1: CGPointMake(34.6, 17.2), controlPoint2: CGPointMake(35.1, 17.6))
    bezier6Path.addCurveToPoint(CGPointMake(32.7, 19.8), controlPoint1: CGPointMake(35.1, 19.3), controlPoint2: CGPointMake(33.8, 19.8))
    bezier6Path.addCurveToPoint(CGPointMake(28.9, 19), controlPoint1: CGPointMake(31.1, 19.8), controlPoint2: CGPointMake(30.2, 19.6))
    bezier6Path.addLineToPoint(CGPointMake(28.4, 18.7))
    bezier6Path.addLineToPoint(CGPointMake(27.8, 22.2))
    bezier6Path.addCurveToPoint(CGPointMake(32.3, 23), controlPoint1: CGPointMake(28.7, 22.6), controlPoint2: CGPointMake(30.5, 23))
    bezier6Path.addCurveToPoint(CGPointMake(39.3, 17.7), controlPoint1: CGPointMake(36.5, 23), controlPoint2: CGPointMake(39.3, 20.9))
    bezier6Path.addCurveToPoint(CGPointMake(35.9, 13.5), controlPoint1: CGPointMake(39.3, 15.9), controlPoint2: CGPointMake(38.2, 14.6))
    bezier6Path.addCurveToPoint(CGPointMake(33.6, 11.6), controlPoint1: CGPointMake(34.5, 12.8), controlPoint2: CGPointMake(33.6, 12.3))
    bezier6Path.addCurveToPoint(CGPointMake(35.9, 10.3), controlPoint1: CGPointMake(33.6, 11), controlPoint2: CGPointMake(34.3, 10.3))
    bezier6Path.addCurveToPoint(CGPointMake(38.9, 10.9), controlPoint1: CGPointMake(37.2, 10.3), controlPoint2: CGPointMake(38.2, 10.6))
    bezier6Path.addLineToPoint(CGPointMake(39.3, 11.1))
    bezier6Path.addLineToPoint(CGPointMake(39.9, 7.8))
    bezier6Path.closePath()
    bezier6Path.miterLimit = 4;
    
    fillColor3.setFill()
    bezier6Path.fill()
    
    
    //// Bezier 7 Drawing
    let bezier7Path = UIBezierPath()
    bezier7Path.moveToPoint(CGPointMake(45.2, 17.5))
    bezier7Path.addCurveToPoint(CGPointMake(46.8, 13.2), controlPoint1: CGPointMake(45.5, 16.6), controlPoint2: CGPointMake(46.8, 13.2))
    bezier7Path.addCurveToPoint(CGPointMake(47.3, 11.7), controlPoint1: CGPointMake(46.8, 13.2), controlPoint2: CGPointMake(47.1, 12.3))
    bezier7Path.addLineToPoint(CGPointMake(47.6, 13))
    bezier7Path.addCurveToPoint(CGPointMake(48.5, 17.5), controlPoint1: CGPointMake(47.6, 13), controlPoint2: CGPointMake(48.4, 16.7))
    bezier7Path.addLineToPoint(CGPointMake(45.2, 17.5))
    bezier7Path.closePath()
    bezier7Path.moveToPoint(CGPointMake(50.2, 7.5))
    bezier7Path.addLineToPoint(CGPointMake(47.1, 7.5))
    bezier7Path.addCurveToPoint(CGPointMake(45, 8.8), controlPoint1: CGPointMake(46.1, 7.5), controlPoint2: CGPointMake(45.4, 7.8))
    bezier7Path.addLineToPoint(CGPointMake(39, 23))
    bezier7Path.addLineToPoint(CGPointMake(43.2, 23))
    bezier7Path.addCurveToPoint(CGPointMake(44, 20.7), controlPoint1: CGPointMake(43.2, 23), controlPoint2: CGPointMake(43.9, 21.1))
    bezier7Path.addCurveToPoint(CGPointMake(49.1, 20.7), controlPoint1: CGPointMake(44.5, 20.7), controlPoint2: CGPointMake(48.6, 20.7))
    bezier7Path.addCurveToPoint(CGPointMake(49.6, 23), controlPoint1: CGPointMake(49.2, 21.2), controlPoint2: CGPointMake(49.6, 23))
    bezier7Path.addLineToPoint(CGPointMake(53.3, 23))
    bezier7Path.addLineToPoint(CGPointMake(50.2, 7.5))
    bezier7Path.closePath()
    bezier7Path.miterLimit = 4;
    
    fillColor3.setFill()
    bezier7Path.fill()
    
    
    //// Bezier 8 Drawing
    let bezier8Path = UIBezierPath()
    bezier8Path.moveToPoint(CGPointMake(18, 7.5))
    bezier8Path.addLineToPoint(CGPointMake(14, 18.1))
    bezier8Path.addLineToPoint(CGPointMake(13.6, 15.9))
    bezier8Path.addCurveToPoint(CGPointMake(8, 9.4), controlPoint1: CGPointMake(12.9, 13.4), controlPoint2: CGPointMake(10.6, 10.7))
    bezier8Path.addLineToPoint(CGPointMake(11.6, 23))
    bezier8Path.addLineToPoint(CGPointMake(15.8, 23))
    bezier8Path.addLineToPoint(CGPointMake(22.1, 7.5))
    bezier8Path.addLineToPoint(CGPointMake(18, 7.5))
    bezier8Path.closePath()
    bezier8Path.miterLimit = 4;
    
    fillColor3.setFill()
    bezier8Path.fill()
    
    
    
    
    
    
    //// Bezier 10 Drawing
    let bezier10Path = UIBezierPath()
    bezier10Path.moveToPoint(CGPointMake(60.5, 15.3))
    bezier10Path.addCurveToPoint(CGPointMake(59.4, 14.2), controlPoint1: CGPointMake(59.9, 15.3), controlPoint2: CGPointMake(59.4, 14.8))
    bezier10Path.addLineToPoint(CGPointMake(59.4, 8.6))
    bezier10Path.addCurveToPoint(CGPointMake(60.5, 7.5), controlPoint1: CGPointMake(59.4, 8), controlPoint2: CGPointMake(59.9, 7.5))
    bezier10Path.addLineToPoint(CGPointMake(69.9, 7.5))
    bezier10Path.addCurveToPoint(CGPointMake(71, 8.6), controlPoint1: CGPointMake(70.5, 7.5), controlPoint2: CGPointMake(71, 8))
    bezier10Path.addLineToPoint(CGPointMake(71, 14.2))
    bezier10Path.addCurveToPoint(CGPointMake(69.9, 15.3), controlPoint1: CGPointMake(71, 14.8), controlPoint2: CGPointMake(70.5, 15.3))
    bezier10Path.addLineToPoint(CGPointMake(60.5, 15.3))
    bezier10Path.closePath()
    bezier10Path.moveToPoint(CGPointMake(60.5, 8))
    bezier10Path.addCurveToPoint(CGPointMake(60, 8.5), controlPoint1: CGPointMake(60.2, 8), controlPoint2: CGPointMake(60, 8.2))
    bezier10Path.addLineToPoint(CGPointMake(60, 14.1))
    bezier10Path.addCurveToPoint(CGPointMake(60.5, 14.6), controlPoint1: CGPointMake(60, 14.4), controlPoint2: CGPointMake(60.2, 14.6))
    bezier10Path.addLineToPoint(CGPointMake(69.9, 14.6))
    bezier10Path.addCurveToPoint(CGPointMake(70.4, 14.1), controlPoint1: CGPointMake(70.2, 14.6), controlPoint2: CGPointMake(70.4, 14.4))
    bezier10Path.addLineToPoint(CGPointMake(70.4, 8.6))
    bezier10Path.addCurveToPoint(CGPointMake(69.9, 8.1), controlPoint1: CGPointMake(70.4, 8.3), controlPoint2: CGPointMake(70.2, 8.1))
    bezier10Path.addLineToPoint(CGPointMake(60.5, 8.1))
    bezier10Path.addLineToPoint(CGPointMake(60.5, 8))
    bezier10Path.closePath()
    bezier10Path.miterLimit = 4;
    
    fillColor.setFill()
    bezier10Path.fill()
    
    
    //// Group 9
    //// Group 10
}