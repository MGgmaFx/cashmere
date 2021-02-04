//
//  CustomButtomStyle.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/14.
//

import SwiftUI

struct CustomButtomStyle: ButtonStyle {
    
    var color: Color

    func makeBody(configuration: Self.Configuration) -> some View {

      return configuration.label
        .frame(width: 240, height: 60, alignment: .center)
        .background(color)
        .cornerRadius(20)
        .foregroundColor(Color.white)
        .padding(.bottom, 20)
        .compositingGroup()
        .clipped()
    }
}
