//
//  CatalogView.swift
//  ParrotDayDraftRequestManga
//
//  Created by Juan Manuel Moreno on 26/07/24.
//

import SwiftUI

enum Direction {
    case forward
    case back
}
struct CatalogView: View {
    let callback: (Direction) -> Void
    
    @Binding var manga: Manga?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                ForEach(deliverManga()) { item in
                    NavigationLink(destination: MangaView(mangaItem: item)) {
                        ZStack {
                            AsyncImage(url: URL(string: item.mainPicture!.replacingOccurrences(of: "\"", with: ""))) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 125)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .shadow(radius: 5)
                            } placeholder: {
                                ProgressView()
                                    .controlSize(.extraLarge)
                            } // Cuando acaba de cargar es como un Image
                            .background {
                                Color(white: 1)
                            }
                            CircularTextView(title: item.title!, radius: 78)
                        }
                        .background {
                            Color(white: 1)
                        }

                        FavoriteView(item: item)
                    }
                    .navigationTitle("Go")
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let direction: Direction
                    if value.translation.width > 50 {
                        direction = .back
                    } else {
                        direction = .forward
                    }
                    callback(direction)
                }
        )
    }
    
    func deliverManga() -> [Item] {
        if manga != nil && !manga!.items.isEmpty {
            return manga!.items
        } else {
            return [Item]()
        }
    }
}

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
//                        .foregroundColor(.red)
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
//#Preview {
//    CatalogView(callback: {_ in}, manga: Manga)
//}
