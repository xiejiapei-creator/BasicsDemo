//
//  AbstractFactoryDemo.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/25.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

class ChengDuCity//成都市
{
    //有两个啤酒厂
    var abstractFactory1: AbstractFactory?
    var abstractFactory2: AbstractFactory?
}

//MARK: AbstractFactory

protocol AbstractFactory//抽象工厂
{
    //生产两种产品
    func createProductA() -> Product
    func createProductB() -> Product
}

//MARK: Product

protocol Product
{
    //产品名称
    var name: String { get }
}

class BearProduct: Product
{
    //啤酒产品
    var name: String = "啤酒"
}

//MARK: ConcreteFactory

class ConcreteFactory1: AbstractFactory //啤酒工厂1
{
    //生产产品A
    func createProductA() -> Product
    {
        return BearProduct()
    }
    
    //生产产品B
    func createProductB() -> Product
    {
        return BearProduct()
    }
}

class ConcreteFactory2: AbstractFactory //啤酒工厂2
{
    //生产产品A
    func createProductA() -> Product
    {
        return BearProduct()
    }
    
    //生产产品B
    func createProductB() -> Product
    {
        return BearProduct()
    }
}
