//
//  NamespaceProtocol.swift
//  NamespaceDemo
//
//  Created by JiongXing on 2017/5/9.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import UIKit

// MARK: - 协议定义

/// 类型协议
protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

struct NamespaceWrapper<T>: TypeWrapperProtocol {
    let wrappedValue: T
    init(value: T) {
        self.wrappedValue = value
    }
}

/// 命名空间协议
protocol NamespaceWrappable {
    associatedtype WrapperType
    var jx: WrapperType { get }
    static var jx: WrapperType.Type { get }
}

extension NamespaceWrappable {
    var jx: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var jx: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

// MARK: - 扩展类

extension UIColor: NamespaceWrappable {}

extension String: NamespaceWrappable {}
