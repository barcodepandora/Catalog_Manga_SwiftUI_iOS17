//
//  ClockView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/07/24.
//

import SwiftUI

struct ClockView: View {
    @State var selection: Int = 0
    let callback: (Int) -> Void
    let clockSize: CGFloat = 108
    let needle: CGFloat = 49
    var options: [String] = []
    

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
            let offset4Needle: Double = 38
            ForEach(0..<options.count, id: \.self) { index in
                Text(options[index])
                    .font(.system(size: 8))
                    .offset(x: MathButler.shared.doSin(numberOfAngles: options.count, indexOfAngle: index) * offset4Needle, y: -MathButler.shared.doCos(numberOfAngles: options.count, indexOfAngle: index) * offset4Needle)
            }
        }
#if !os(tvOS)
        .gesture(
            DragGesture()
                .onEnded() { value in
                    print("\(value.translation.width), \(value.translation.height)")
                    if value.translation.width > 20 {
                        selection -= 1
                        callback(selection)
                    } else if value.translation.width < -20 {
                        selection += 1
                        callback(selection)
                    }
                }
        )
#endif
    }
}

#Preview {
    ClockView(callback: {_ in})
}
