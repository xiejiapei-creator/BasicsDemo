//
//  FactoryMethod.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/25.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

protocol Creator// 生产
{
    func factoryMethod() -> IProduct
}

protocol IProduct// 产品
{
    var name: String { get }
}

class IConcreteProduct: IProduct// 实际产品
{
    var name: String = "啤酒"
}

class ConcreteCreator: Creator// 生产者
{
    func factoryMethod() -> IProduct
    {
        return IConcreteProduct()
    }
}
