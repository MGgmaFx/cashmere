//
//  QRCodeView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/09.
//

import SwiftUI

struct QRCodeView: View {
    @EnvironmentObject var room: Room
    @State var qrImage:UIImage?
    var _QRCodeMaker = QRCodeMaker()

    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: self._QRCodeMaker.make(message: room.id)!)
            Spacer()
            Text("QRコードを読み込んでください")
                .foregroundColor(.orange)
            Spacer()
        }
    }
}
