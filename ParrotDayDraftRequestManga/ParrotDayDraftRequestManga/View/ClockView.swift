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
    @State var selection: Double = 0
    @State var isCallbackCalled = false
    let callback: (Nail) -> Void
    let clockSize: CGFloat = 200
    let needleLength: CGFloat = 80
    var options = ["Milena", "Luce", "Wendy", "Lizzie", "Yumi"]

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.cyan, lineWidth: 2)
                .frame(width: clockSize, height: clockSize)
            
            // Needle
            Rectangle()
                .fill(Color.cyan)
                .frame(width: 2, height: needleLength)
                .rotationEffect(Angle(degrees: -180 / Double(options.count) * selection))
                .animation(.easeInOut)
            
            // Center dot
            Circle()
                .fill(Color.cyan)
                .frame(width: 10, height: 10)
            
            // Hours
            let offset4Clock: Double = 78
            ForEach(0..<options.count, id: \.self) { index in
                Text(options[index])
                    .offset(x: sin(Double(index) * 2 * Double.pi / Double(options.count)) * offset4Clock, y: -cos(Double(index) * 2 * Double.pi / Double(options.count)) * offset4Clock)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    print("\(value.translation.width), \(value.translation.height)")
                    if isCallbackCalled {
                        isCallbackCalled = false
                    } else {
                        let nail: Nail
                        if value.translation.width > 50 {
                            if selection == 0 {
                                selection = Double(options.count - 1)
                            } else {
                                selection -= 1
                            }
                            self.selection -= 1
                            nail = .happy
                            callback(nail)
                        } else if value.translation.width < -50 {
                            if selection == Double(options.count - 1) {
                                selection = 0
                            } else {
                                self.selection += 1
                            }
                            nail = .sad
                            callback(nail)
                        }
                        isCallbackCalled = true
                    }
                }
        )
    }
}

#Preview {
    ClockView(callback: {_ in})
}
