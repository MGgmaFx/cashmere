//
//  QRCodeMaker.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/09.
//

import UIKit


class QRCodeMaker: NSObject {
    // CIContext()は毎回生成すると遅いとの指摘があったのでこちらで一度生成したら使い回すようにする
    private let context = CIContext()

    func make(message:String) -> UIImage? {
        guard let data = message.data(using: .utf8) else { return nil }

        guard let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "H"]) else { return nil }
        
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        
        guard let ciImage = qr.outputImage?.transformed(by: sizeTransform) else { return nil }
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        let image = UIImage(cgImage: cgImage)
        
        return image
    }
}
