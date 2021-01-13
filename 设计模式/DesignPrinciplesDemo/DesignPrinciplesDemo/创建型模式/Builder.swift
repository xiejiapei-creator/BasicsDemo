//
//  Builder.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/25.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

//MARK: protocol

protocol Builder// 建筑工
{
    func createProduct() -> BuilderProduct
}

protocol BuilderProduct //建筑
{
    var name: String { get }
}

//MARK: class

class BeijingSiheyuanProduct: BuilderProduct //北京四合院
{
    var name: String = "北京四合院"
}

class ConcreteBuilder: Builder //建筑工
{
    func createProduct() -> BuilderProduct
    {
        return BeijingSiheyuanProduct()
    }
}

class Director //建筑师
{
    var builder: ConcreteBuilder?
    
    func construct() //指导生产
    {
        guard let product = builder?.createProduct() else {return}
        print("修建房屋：" + product.name)
    }
}


