//
//  AbilityView.swift
//  testfortest
//
//  Created by Rex Peng on 2019/5/31.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

class AbilityView: UIView {
    
    var pointCount = 5
    var viewCount = 7
    
    private var points: [CGPoint] = []
    private var angles: [CGFloat] = []
    private var halfWidth: CGFloat!
    private var halfHeight: CGFloat!
    private var radius: CGFloat!
    private var _center: CGPoint!
    private var values: [CGFloat] = []
    private var valuesName: [String] = []
    
    var strokeColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    var pointColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    var fillColor: UIColor = UIColor.red.withAlphaComponent(0.3) {
        didSet {
            setNeedsDisplay()
        }
    }
    var textFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            setNeedsDisplay()
        }
    }
    var textColor: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()

    }
    
    init(frame: CGRect, pointCount: Int=5, valuesName: [String] = [], values: [CGFloat] = []) {
        super.init(frame: frame)

        self.pointCount = pointCount
        self.valuesName = valuesName
        self.values = values
        commonInit()
    }
    
    func commonInit() {
        halfWidth = frame.width * 0.5
        halfHeight = frame.height * 0.5
        radius = min(halfWidth, halfHeight)
        _center = CGPoint(x: halfWidth, y: halfHeight)
        
        let avgAngle: CGFloat = 360.0 / CGFloat(pointCount)
        for i in 0..<pointCount {
            let angle = CGFloat(i) * avgAngle
            angles.append(angle)
        }
        
        for i in 0..<pointCount {
            let point = getAnglePoint(angle: angles[i], center: _center, radius: radius)
            points.append(point)
        }
        //self.clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        print("draw")
        layer.sublayers = nil
        
        let path = UIBezierPath()
        
        for i in 0..<pointCount {
            path.move(to: _center)
            path.addLine(to: points[i])
        }
        
        let centerLayer = CAShapeLayer()
        centerLayer.fillColor = UIColor.clear.cgColor
        centerLayer.path = path.cgPath
        centerLayer.strokeColor = strokeColor.cgColor
        centerLayer.lineWidth = 1.0
        self.layer.addSublayer(centerLayer)


        let dX = rect.width / (CGFloat(viewCount) * 2.0)
        let dY = rect.height / (CGFloat(viewCount) * 2.0)
        
        for i in 0..<viewCount {
            let aFrame = CGRect(x: 0, y: 0, width: rect.width-CGFloat(i)*dX*2, height: rect.height-CGFloat(i)*dY*2)
            //print(aFrame)
            let ohalfWidth = aFrame.width * 0.5
            let ohalfHeight = aFrame.height * 0.5
            
            let oradius = min(ohalfWidth, ohalfHeight)
            let ocenter = CGPoint(x: ohalfWidth, y: ohalfHeight)
            
            var oPoints:[CGPoint] = []
            for r in 0..<pointCount {
                let point = getAnglePoint(angle: angles[r], center: ocenter, radius: oradius)
                oPoints.append(point)
            }
            //print(oPoints)
            
            let opath = UIBezierPath()
            opath.move(to: oPoints[0])
            for l in 1...pointCount {
                opath.addLine(to: oPoints[l%pointCount])
            }

            let subLayer = CAShapeLayer()
            subLayer.frame = aFrame
            subLayer.fillColor = UIColor.clear.cgColor
            subLayer.path = opath.cgPath
            subLayer.strokeColor = strokeColor.cgColor
            subLayer.lineWidth = 1.0
            subLayer.position = _center
            
            self.layer.addSublayer(subLayer)
        }
        
        setValues(values: self.values)
    }
    
    
    private func getTextSize(string: String, font: UIFont) -> CGSize {
        let normalText:NSString = string as NSString
        
        let stringSize = normalText.boundingRect(with: .zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        return stringSize
    }
    
    private func setAnglePoint(point: CGPoint) {
        let pointPath = UIBezierPath(arcCenter: point, radius: 3, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let pointLayer = CAShapeLayer()
        pointLayer.path = pointPath.cgPath
        pointLayer.fillColor = pointColor.cgColor
        self.layer.addSublayer(pointLayer)
    }
    
    private func getAnglePoint(angle: CGFloat, center: CGPoint, radius: CGFloat) -> CGPoint {
        var mAngle = angle - 90.0
        if mAngle > 180.0 {
            mAngle = mAngle - 360.0
        }
        mAngle = mAngle * CGFloat.pi / 180.0
        let x = round((center.x + radius * cos(mAngle)) * 100) / 100
        let y = round((center.y + radius * sin(mAngle)) * 100) / 100
        return CGPoint(x: x, y: y)
    }
    
    func setValues(values:[CGFloat]) {
        guard values.count > 0 else { return }
        
        self.values = values
        var vPoints: [CGPoint] = angles.map {
            return getAnglePoint(angle: $0, center: _center, radius: 0)
        }
        
        for i in 0..<angles.count {
            if i < values.count {
                let point = getAnglePoint(angle: angles[i], center: _center, radius: radius*values[i])
                setAnglePoint(point: point)
                vPoints[i] = point
            } else {
                setAnglePoint(point: vPoints[i])
            }
        }
        
        let areaPath = UIBezierPath()
        areaPath.move(to: vPoints[0])
        for i in 1...vPoints.count {
            areaPath.addLine(to: vPoints[i%vPoints.count])
        }
        let areaLayer = CAShapeLayer()
        areaLayer.fillColor = fillColor.cgColor
        areaLayer.path = areaPath.cgPath
        self.layer.addSublayer(areaLayer)
        
        setNeedsDisplay()
        
        setValuesName(strings: self.valuesName)
    }
    
    func setValuesName(strings: [String]) {
        self.valuesName = strings

        guard strings.count > 0 && values.count > 0 else { return }
        
        
        let font = textFont
        for i in 0..<points.count {
            var string: String
            if i < strings.count {
                string = "\(strings[i])[\(Int(values[i]*100))]"
            } else {
                //string = String(format: "Item %d", i)
                break
            }
            let textSize = getTextSize(string: string, font: font)
            let textCenter = CGPoint(x: textSize.width * 0.5 , y: textSize.height * 0.5)
            let point = points[i]
            var x: CGFloat = 0
            var y: CGFloat = 0
            //print(point)
            
            
            if point.x > _center.x && point.y < _center.y {
                x = point.x + textCenter.x + 4
                y = point.y
            } else if point.x > _center.x && point.y > _center.y {
                x = point.x + textCenter.x + 4
                y = point.y + textCenter.y
            } else if point.x < _center.x && point.y > _center.y {
                x = point.x - textCenter.x
                y = point.y + textCenter.y
            } else if point.x < _center.x && point.y < _center.y {
                x = point.x - textCenter.x - 4
                y = point.y - textCenter.y
            } else if point.x == _center.x {
                x = point.x
                if point.y < _center.y {
                    y = point.y - textCenter.y - 4
                } else {
                    y = point.y + textCenter.y + 4
                }
            } else if point.y == _center.y {
                y = point.y
                if point.x > _center.x {
                    x = point.x + textCenter.x + 4
                } else {
                    x = point.x - textCenter.x - 4
                }
            }
            
            let nameAttrString = NSMutableAttributedString(string: strings[i])
            nameAttrString.addAttributes([NSAttributedString.Key.foregroundColor: textColor.cgColor], range: NSRange(location: 0, length: nameAttrString.length))
            let valueAttrString = NSMutableAttributedString(string: "[\(Int(values[i]*100))]")
            valueAttrString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red.cgColor], range: NSRange(location: 0, length: valueAttrString.length))
            
            nameAttrString.append(valueAttrString)
            nameAttrString.addAttributes([NSAttributedString.Key.font: textFont], range: NSRange(location: 0, length: nameAttrString.length))
            //print("x=\(x),y=\(y)")
            let text = CATextLayer()
            text.frame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
            //text.font = font.fontName as CFString
            //text.fontSize = font.pointSize
            //text.foregroundColor = textColor.cgColor
            text.string = nameAttrString//string
            //text.isWrapped = true
            text.position = CGPoint(x: x, y: y)
            
            self.layer.addSublayer(text)
        }
        
        setNeedsDisplay()
    }

}
