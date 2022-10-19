//
//  UIImageView+.swift
//  PLREQ
//
//  Created by 이주화 on 2022/10/04.
//

import UIKit

extension UIImageView {
    // UIImageView에 URL로 이미지를 불러올 때 사용
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    // MatchMusicCell Image Gradient
    func addMusicCellGradient(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.lightGray.cgColor]
        gradient.locations = [0.6 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
