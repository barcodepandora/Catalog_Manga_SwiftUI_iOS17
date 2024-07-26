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
    let callback: (Nail) -> Void
    let clockSize: CGFloat = 200
    let needleLength: CGFloat = 80
    var selection: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 2)
                .frame(width: clockSize, height: clockSize)
            
            // Needle
            Rectangle()
                .fill(Color.black)
                .frame(width: 2, height: needleLength)
                .rotationEffect(Angle(degrees: selection * 36))
                .animation(.easeInOut)
            
            // Center dot
            Circle()
                .fill(Color.black)
                .frame(width: 10, height: 10)
            
            // Option labels
            //                    ForEach(0..<options.count, id: \.self) { index in
            //                        Text(options[index])
            //                            .rotationEffect(Angle(degrees: Double(index) * 36))
            //                            .offset(y: clockSize / 2 - 20)
            //                    }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    print("\(value.translation.width), \(value.translation.height)")
                    //                            let angle = atan2(value.translation.width, value.translation.height) * 180 / .pi
                    let angle = 180
                    let nail: Nail
                    if value.translation.width > 50 {
                        nail = .happy
                    } else {
                        nail = .sad
                    }
                    callback(nail)
                }
        )
    }
}

#Preview {
    ClockView(callback: {_ in})
}
