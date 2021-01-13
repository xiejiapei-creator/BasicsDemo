//
//  State.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit

protocol State
{
    func handle()
}

class ConcreteStateA: State
{
    func handle()
    {
        print("状态A")
    }
}

class ConcreteStateB: State
{
    func handle()
    {
        print("状态B")
    }
}

class Context
{
    var state: State?
    
    func request()
    {
        state?.handle()
    }
}
