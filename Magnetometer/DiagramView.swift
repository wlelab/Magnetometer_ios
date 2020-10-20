//
//  DiagramView.swift
//  Magnetometer
//
//  Created by Wei-Cheng Ling on 2020/10/15.
//

import UIKit

class DiagramView: UIView {
    
    var dataArray = [MagnetometerData]()
    
    
    override func draw(_ rect: CGRect) {
        let width = frame.size.width
        let height = frame.size.height
        let y0 = height/2.0
        
        var maximum = 0.0
        for data in dataArray {
            maximum = max(maximum, abs(data.value))
        }
        
        
        // setup bezier path
        let bezierPath = UIBezierPath()

        guard let firstPoint = dataArray.first,
              let lastPoint = dataArray.last,
              maximum > 0 else
        {
            return
        }
        let scale = height / (CGFloat(maximum) * 2.0)
        let y = y0 + CGFloat(firstPoint.value) * scale
        bezierPath.move(to: CGPoint(x: 0, y: y))

        let totalTime = lastPoint.timestamp - firstPoint.timestamp
        if totalTime == 0 {
            return
        }
        
        for dataPoint in dataArray {
            let timeDiff = dataPoint.timestamp - firstPoint.timestamp
            let x = CGFloat(timeDiff / totalTime) * width
            let y = y0 + CGFloat(dataPoint.value) * scale
            bezierPath.addLine(to: CGPoint(x: x, y: y))
        }
        
        UIColor.orange.setStroke()
        bezierPath.lineWidth = 3
        bezierPath.stroke()
    }
    
    func addData(_ mData: MagnetometerData) {
        var newDataArray = [MagnetometerData]()
        
        for aData in self.dataArray {
            if (mData.timestamp - aData.timestamp) <= 6 {
                newDataArray.append(aData)
            }
        }
        
        newDataArray.append(mData)
        self.dataArray.removeAll()
        self.dataArray.append(contentsOf: newDataArray)
        
        setNeedsDisplay()
    }
    
}
