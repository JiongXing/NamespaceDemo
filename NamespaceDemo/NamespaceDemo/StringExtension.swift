//
//  StringExtension.swift
//  NamespaceDemo
//
//  Created by JiongXing on 2017/5/9.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import Foundation

extension String: NamespaceWrappable {}

extension TypeWrapperProtocol where WrappedType == String {

    /// 把自身作为日志打印
    func log() {
        print(wrappedValue)
    }
}
