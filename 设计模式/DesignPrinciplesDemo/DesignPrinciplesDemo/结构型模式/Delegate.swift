//
//  Delegate.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

protocol Proxy //协议
{
    func charge()
}

class A //委托
{
    var delegate: Proxy?
    
    func askProxy()
    {
        delegate?.charge()
    }
}

class B: Proxy //代理
{
    func charge()
    {
        print("A委托B充值，B实现了代理方法charge")
    }
}
