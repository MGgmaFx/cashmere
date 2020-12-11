//
//  QRCodeView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/09.
//

import SwiftUI

struct QRCodeView: View {
    @Binding var room:Room
    @State var qrImage:UIImage?
    var _QRCodeMaker = QRCodeMaker()

    var body: some View {
        VStack {
            Spacer()
            Text("QRコードを読み込んでください")
                .font(.title)
                .foregroundColor(.orange)
            Spacer()
            Image(uiImage: self._QRCodeMaker.make(message: self.room.id)!)
            Spacer()
        }
    }
}
