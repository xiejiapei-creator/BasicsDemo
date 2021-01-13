//
//  Visitor.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

class VisitorClient: NSObject
{
    func begin()
    {
        let visit1 = VisitorA()
        let visit2 = VisitorB()
        
        let element1 = VisitElementA()
        let element2 = VisitElementA()
        let element3 = VisitElementA()
        
        let element4 = VisitElementB()
        let element5 = VisitElementB()
        
        let array = [element1,element2,element3,element4,element5]
        for element in array
        {
            let number = arc4random()
            if number%2 == 0
            {
                element.acceptVisit(visit: visit1)
            }
            else
            {
                element.acceptVisit(visit: visit2)
            }
        }
    }
}

class Visitor: NSObject
{
    /// 访问元素A
    func visitA(element :VisitElementA)
    {
        
    }
    /// 访问元素B
    func visitB(element :VisitElementB)
    {
        
    }
}

class VisitorA: Visitor
{
    override func visitA(element: VisitElementA)
    {
        NSLog("No1 Visit1 %@", element)
        /// 用 element 做某些操作
    }
    
    override func visitB(element: VisitElementB)
    {
        NSLog("No1 Visit2 %@", element)
        /// 用 element 做某些操作
    }
}

class VisitorB: Visitor
{
    override func visitA(element: VisitElementA)
    {
        NSLog("No2 Visit1 %@", element)
        /// 用 element 做某些操作
    }
    
    override func visitB(element: VisitElementB)
    {
        NSLog("No2 Visit2 %@", element)
        /// 用 element 做某些操作
    }
}

class VisitElement: NSObject
{
    func acceptVisit(visit :Visitor)
    {
    }
}

class VisitElementA: VisitElement
{
    override func acceptVisit(visit :Visitor)
    {
        visit.visitA(element: self)
    }
}

class VisitElementB: VisitElement
{
    override func acceptVisit(visit :Visitor)
    {
        visit.visitB(element: self)
    }
}
