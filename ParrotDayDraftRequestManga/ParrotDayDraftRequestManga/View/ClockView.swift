//
//  ClockView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/07/24.
//

import SwiftUI

enum Nail {
    case happy
    case sad
}

struct ClockView: View {
    @State var selection: Int = 0
    let callback: (Nail) -> Void
    let clockSize: CGFloat = 200
    let needle: CGFloat = 64
    var options = ["Milena", "Luce", "Wendy", "Lizzie", "Yumi"]

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.cyan, lineWidth: 2)
                .frame(width: clockSize, height: clockSize)
            
            // Needle
            Rectangle()
                .fill(Color.cyan)
                .frame(width: 2, height: needle)
                .rotationEffect(Angle(degrees: MathButler.shared.calculateAngleInDegrees(numberOfAngles: options.count, indexOfAngle: selection)))
                .animation(.easeInOut)
            
            // Center dot
            Circle()
                .fill(Color.cyan)
                .frame(width: 10, height: 10)
            
            // Hours
            let offset4Needle: Double = 78
            ForEach(0..<options.count, id: \.self) { index in
                Text(options[index])
                    .offset(x: MathButler.shared.doSin(numberOfAngles: options.count, indexOfAngle: index) * offset4Needle, y: -MathButler.shared.doCos(numberOfAngles: options.count, indexOfAngle: index) * offset4Needle)
            }
        }
        .gesture(
            DragGesture()
                .onEnded() { value in
                    print("\(value.translation.width), \(value.translation.height)")
                    let nail: Nail
                    if value.translation.width > 20 {
                        selection -= 1
                        nail = .happy
                        callback(nail)
                    } else if value.translation.width < -20 {
                        selection += 1
                        nail = .sad
                        callback(nail)
                    }
                }
        )
    }
}

#Preview {
    ClockView(callback: {_ in})
}
