//
//  Prototype.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

protocol Prototype
{
    func clone() -> Product
}

class ConcreteProduct: Product, Prototype
{
    var name: String = "啤酒"
    
    func clone() -> Product
    {
        let p = ConcreteProduct()
        p.name = name
        return p
    }
}

class Client
{
    var prototype: Prototype!
    
    func operation() -> Product
    {
        return prototype.clone()
    }
}
