//
//  RuleExplanationView.swift
//  cashmere
//
//  Created by 志村豪気 on 2021/02/04.
//

import SwiftUI

struct RuleExplanationView: View {
    let imageName: String
    var body: some View {
        VStack {
            Image(imageName)
                    .resizable()
                    .frame(width: 250, height: 370, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct RuleExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        RuleExplanationView(imageName: "rule")
    }
}
