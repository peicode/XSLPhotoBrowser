//
//  XSLNameSpace.swift
//  XSLPhotoBrowser
//
//  Created by 廖佩志 on 2019/1/22.
//  Copyright © 2019 廖佩志. All rights reserved.
//

import Foundation
/// 类型协议
public protocol XSLTypeWrapperProtocol {
    associatedtype XSLWrappedType
    var xslWrappedValue: XSLWrappedType { get }
    init(value: XSLWrappedType)
}

public struct XSLNamespaceWrapper<T>: XSLTypeWrapperProtocol {
    public let xslWrappedValue: T
    public init(value: T) {
        self.xslWrappedValue = value
    }
}

/// 命名空间协议
public protocol XSLNamespaceWrappable {
    associatedtype XSLWrappedType
    var xsl: XSLWrappedType { get }
    static var xsl: XSLWrappedType.Type { get }
}

extension XSLNamespaceWrappable {
    public var xsl: XSLNamespaceWrapper<Self> {
        return XSLNamespaceWrapper(value: self)
    }

    public static var xsl: XSLNamespaceWrapper<Self>.Type {
        return XSLNamespaceWrapper.self
    }
}
