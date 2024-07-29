//
//  Butler.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 28/07/24.
//

import Foundation

class MathButler {
    
    static let shared = MathButler()
    
    func calculateAngleInDegrees(numberOfAngles: Int, indexOfAngle: Int) -> Double {
        var angleInDegrees = (360 / numberOfAngles) * indexOfAngle
        return Double(angleInDegrees)
    }
    
    func doSin(numberOfAngles: Int, indexOfAngle: Int) -> Double {
        let angleInDegrees: Double = calculateAngleInDegrees(numberOfAngles: numberOfAngles, indexOfAngle: indexOfAngle)
        let angleInRadians = angleInDegrees * Double.pi / 180
        return sin(angleInRadians)
    }
    
    func doCos(numberOfAngles: Int, indexOfAngle: Int) -> Double {
        let angleInDegrees: Double = calculateAngleInDegrees(numberOfAngles: numberOfAngles, indexOfAngle: indexOfAngle)
        let angleInRadians = angleInDegrees * Double.pi / 180
        return cos(angleInRadians)
    }
}
