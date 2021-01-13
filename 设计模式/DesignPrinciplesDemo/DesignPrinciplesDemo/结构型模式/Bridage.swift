//
//  Bridage.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

protocol AbstractInsect
{
    func bloomImp()
}

class Butterfly: AbstractInsect
{
    func bloomImp()
    {
        print("蝴蝶来了")
    }
}

class Bee: AbstractInsect
{
    func bloomImp()
    {
        print("蜜蜂来了")
    }
}

protocol AbstractFlower
{
    var insect: AbstractInsect? { get }
    
    func bloom()
}

class QianniuHua: AbstractFlower
{
    var insect: AbstractInsect?
    
    func bloom()
    {
        print("牵牛花开了")
        insect?.bloomImp()
    }
}

class MudanHua: AbstractFlower
{
    var insect: AbstractInsect?
    
    func bloom()
    {
        print("牡丹花开了")
        insect?.bloomImp()
    }
}

class Bridage
{
    func bridage()
    {
        let qianniu = QianniuHua.init()
        qianniu.insect = Bee.init()
        qianniu.bloom()

        let mudan = MudanHua.init()
        mudan.insect = Butterfly.init()
        mudan.bloom()
    }
}



