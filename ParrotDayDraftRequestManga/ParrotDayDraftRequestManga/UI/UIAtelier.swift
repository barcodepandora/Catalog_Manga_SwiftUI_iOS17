//
//  UIAtelier.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 25/08/24.
//

import Foundation
import SwiftUI

struct CircularTextView: View {
    @State var letterWidths: [Int:Double] = [:]
    
    @State var title: String
    
    var lettersOffset: [(offset: Int, element: Character)] {
        return Array(title.enumerated())
    }
    var radius: Double
    
    var body: some View {
        ZStack {
            ForEach(lettersOffset, id: \.offset) { index, letter in // Mark 1
                VStack {
                    Text(String(letter))
//                        .font(.system(size: 13, design: .monospaced))
                        .font(.system(size: 13))
                        .foregroundColor(.blue)
                        .kerning(1)
                        .background(LetterWidthSize()) // Mark 2
                        .onPreferenceChange(WidthLetterPreferenceKey.self, perform: { width in  // Mark 2
                            letterWidths[index] = width
                        })
                    Spacer() // Mark 1
                }
                .rotationEffect(fetchAngle(at: index)) // Mark 3
            }
        }
        .frame(width: 150, height: 150)
        .rotationEffect(.degrees(302))
    }
    
    func fetchAngle(at letterPosition: Int) -> Angle {
        let times2pi: (Double) -> Double = { $0 * 2 * .pi }
        
        let circumference = times2pi(radius)
                        
        let finalAngle = times2pi(letterWidths.filter{$0.key <= letterPosition}.map(\.value).reduce(0, +) / circumference)
        
        return .radians(finalAngle)
    }
}

struct WidthLetterPreferenceKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

struct LetterWidthSize: View {
    var body: some View {
        GeometryReader { geometry in // using this to get the width of EACH letter
            Color
                .clear
                .preference(key: WidthLetterPreferenceKey.self,
                            value: geometry.size.width)
        }
    }
}

struct AsyncPicture: View {
    
    var urlImage: String
    var pictureWidth: CGFloat
    var pictureHeight: CGFloat
    
    init(urlImage: String, pictureWidth: CGFloat, pictureHeight: CGFloat) {
        self.urlImage = urlImage
        self.pictureWidth = pictureWidth
        self.pictureHeight = pictureHeight
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: urlImage.replacingOccurrences(of: "\"", with: ""))) { image in
                // Display the loaded image
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: pictureWidth, height: pictureHeight, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image("MacWatch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 81, height: 81)
                    .animation(.easeInOut)
            }
        }
        .background(Color.clear)
    }
}
