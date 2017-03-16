//
//  DrawSignatureView.swift
//  WDMeeting
//
//  Created by Baskaran T on 07/03/17.
//  Copyright © 2017 Baskaran T. All rights reserved.
//

import UIKit


@IBDesignable

public class DrawSignatureView: UIView{
    
    
    weak var delegate: SignatureDelegate?
    
    // Mark: - Public properties
    // Draw
    @IBInspectable public var strokeWidth: CGFloat = 2.0 {
        didSet {
            self.path.lineWidth = strokeWidth
        }
    }
    
    // signature color is black
    @IBInspectable public var strokeColor: UIColor = .black{
        didSet {
            self.strokeColor.setStroke()
        }
    }

    // Blackground View color is white
    @IBInspectable public var signatureBackgroundColor: UIColor = .white{
        didSet {
            self.backgroundColor = signatureBackgroundColor
        }
    }
    
   // signature 
    public var doesContainSignature: Bool {
        get {
            if self.path.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
    
    // Mark: - Private Properties
    private var path = UIBezierPath()
    private var points = [CGPoint](repeating: CGPoint(), count:5)
    private var controlPoint = 0
    
    // Mark: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        self.backgroundColor = self.signatureBackgroundColor
        self.path.lineWidth = self.strokeWidth
        self.path.lineJoinStyle = CGLineJoin.round
    }
    
   
    
    // Mark: - Draw
    override public func draw(_ rect: CGRect) {
        self.strokeColor.setStroke()
        self.path.stroke()
    }
    
    // Mark: - Touch Handling Function
    // Touch Began
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            self.controlPoint = 0
            self.points[0] = touchPoint
        }
        
        if let delegate = self.delegate {
            delegate.startDraw()
        }
    }
    
    // Touch Moved
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first{
            let touchPoint = firstTouch.location(in: self)
            self.controlPoint += 1
            self.points[self.controlPoint]  = touchPoint
            if (self.controlPoint == 4){
                self.points[3] = CGPoint(x: (self.points[2].x + self.points[4].x)/2.0,
                                         y: (self.points[2].y + self.points[4].y)/2.0)
                self.path.move(to: self.points[0])
                self.path.addCurve(to: self.points[3], controlPoint1:self.points[1],
                                   controlPoint2:self.points[2])
                
                self.setNeedsDisplay()
                self.points[0] = self.points[3]
                self.points[1] = self.points[4]
                self.controlPoint = 1
            }
            self.setNeedsDisplay()
        }
    }
    
    // Touch End
    override public func touchesEnded(_ touches: Set <UITouch>, with event: UIEvent?) {
        if self.controlPoint == 0 {
            let touchPoint = self.points[0]
            self.path.move(to: CGPoint(x: touchPoint.x-1.0,y: touchPoint.y))
            self.path.addLine(to: CGPoint(x: touchPoint.x+1.0,y: touchPoint.y))
            self.setNeedsDisplay()
        } else {
            self.controlPoint = 0
        }
        
        if let delegate = self.delegate {
            delegate.finishDraw()
        }
    }
    
    // Mark: - Method for interacting with Signature View
    
    // clear the signature View
    public func clear(){
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    // save the signature as an UIImage
    public func getSignature(scale:CGFloat = 1) -> UIImage? {
        if !doesContainSignature { return nil }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        self.path.stroke()
        let signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return signature
    }
    
    // save the signature (cropped of outside white space) as a UIImage
    public func getCroppedSignature(scale:CGFloat = 1) -> UIImage? {
        guard let fullRender = getSignature(scale:scale) else { return nil }
        let bounds = self.scale(path.bounds.insetBy(dx: -strokeWidth/2,
                                                    dy: -strokeWidth/2), byFactor: scale)
        guard let imageRef = fullRender.cgImage?.cropping(to: bounds)
            else { return nil }
        return UIImage(cgImage: imageRef)
    }
    
    public func scale(_ rect : CGRect, byFactor factor:CGFloat) -> CGRect {
        var scaledRect = rect
        scaledRect.origin.x *= factor
        scaledRect.origin.y *= factor
        scaledRect.size.width *= factor
        scaledRect.size.height *= factor
        return scaledRect
    }
}

protocol SignatureDelegate: class {
    func startDraw()
    func finishDraw()
}
