//
//  Template.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit

class AbstractClass
{
    func templateMethod()
    {
        print("执行当前逻辑...")
        
        //推迟留给子类处理逻辑...
        primitiveOperation1()
        primitiveOperation2()
    }
    
    func primitiveOperation1()
    {
        assert(false, "此方法需要继承")
    }
    
    func primitiveOperation2()
    {
        assert(false, "此方法需要继承")
    }
}

class ConcreteClass: AbstractClass
{
    override func primitiveOperation1()
    {
        print("执行operation1逻辑")
    }
    
    override func primitiveOperation2()
    {
        print("执行operation2逻辑")
    }
}

class TemplateClient
{
    var operationC: AbstractClass?
    
    func operation()
    {
        //执行模版方法
        operationC?.templateMethod()
    }
}


