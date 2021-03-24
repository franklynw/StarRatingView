//
//  StarRatingView.swift
//
//  Created by Franklyn Weber on 24/03/2021.
//

import SwiftUI


public struct StarRatingView: View {
    
    private let rating: CGFloat
    private let width: CGFloat?
    private let starWidth: CGFloat?
    
    // using the UIColors because they're brighter
    private var baseColor = Color(Self.defaultBaseColor)
    private var highlightedColor = Color(.yellow)
    private var outline: Outline?
    
    private static let defaultBaseColor = UIColor(white: 0.84, alpha: 1)
    
    private struct Outline {
        let color: Color
        let weight: Font.Weight?
    }
    
    
    public init(rating: CGFloat, width: CGFloat? = nil) {
        self.rating = rating
        self.width = width
        starWidth = width != nil ? width! / 25 * 4 : nil
    }
    
    public var body: some View {
        
        HStack {
            ForEach(Array(1...5), id: \.self) { index in
                ZStack {
                    greyStar
                    star(amountShown: CGFloat(index) > rating ? max(rating - CGFloat(index - 1), 0) : 1)
                    starOutline(amountShown: CGFloat(index) > rating ? max(rating - CGFloat(index - 1), 0) : 1)
                }
            }
        }
        .frame(width: width, height: starWidth)
    }
    
    @ViewBuilder
    private var greyStar: some View {
        
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(baseColor)
            .frame(width: starWidth, height: starWidth, alignment: .leading)
    }
    
    @ViewBuilder
    private func star(amountShown: CGFloat) -> some View {
        
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(highlightedColor)
            .frame(width: starWidth, height: starWidth, alignment: .leading)
            .mask(mask(amountShown: amountShown))
    }
    
    @ViewBuilder
    private func starOutline(amountShown: CGFloat) -> some View {
        
        Image(systemName: "star")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .font(Font.body.weight(outline?.weight ?? .light))
            .foregroundColor(outline?.color ?? highlightedColor)
            .frame(width: starWidth, height: starWidth, alignment: .leading)
            .mask(mask(amountShown: amountShown))
    }
    
    @ViewBuilder
    private func mask(amountShown: CGFloat) -> some View {
        
        if let starWidth = starWidth {
            Rectangle()
                .fill(Color.black)
                .frame(width: starWidth * amountShown, height: starWidth, alignment: .leading)
                .offset(x: ((1 - amountShown) * starWidth) / -2)
        } else {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.black)
                    .frame(width: geometry.size.width * amountShown, height: geometry.size.width, alignment: .leading)
            }
        }
    }
}


extension StarRatingView {
    
    public func baseColor(_ baseColor: Color) -> Self {
        var copy = self
        copy.baseColor = baseColor
        return copy
    }
    
    public func highlightedColor(_ highlightedColor: Color) -> Self {
        var copy = self
        copy.highlightedColor = highlightedColor
        return copy
    }
    
    public func outline(_ color: Color, weight: Font.Weight? = nil) -> Self {
        var copy = self
        copy.outline = Outline(color: color, weight: weight)
        return copy
    }
}
