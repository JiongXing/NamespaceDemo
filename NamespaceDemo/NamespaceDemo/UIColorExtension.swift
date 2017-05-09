//
//  UIColorExtension.swift
//  NamespaceDemo
//
//  Created by JiongXing on 2017/5/9.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import UIKit

extension UIColor: NamespaceWrappable {}

extension TypeWrapperProtocol where WrappedType == UIColor {
    
    /// 用自身颜色生成UIImage
    var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(wrappedValue.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
