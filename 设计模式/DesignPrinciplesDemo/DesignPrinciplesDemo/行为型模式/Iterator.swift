//
//  Iterator.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

//MARK: 普通迭代器
 
/// 普通迭代器
class EnumIterator: NSObject
{
    private(set) lazy var allObjects = NSArray()
    private lazy var index = 0
    
    /// 初始化
    init(allObjects : NSArray)
    {
        super.init()
        self.allObjects = allObjects
    }
    
    /// 下个元素
    func nextObject() -> Any
    {
        if index >= allObjects.count
        {
            return NSNull()
        }
        let object = allObjects[index]
        index += 1
        return object
    }
}

//MARK: 堆栈迭代器

/// 堆栈迭代器
class StackIterator: NSObject
{
    private lazy var stack = NSMutableArray()
    
    ///压入新元素
    func push(object :Any)
    {
        stack.add(object)
    }
    
    ///弹出顶部元素
    func pop() -> Any
    {
        let object = readStackRear
        if empty()
        {
            stack.remove(object)
        }
        return object
    }
    
    /// 读取栈尾
    func readStackRear() -> Any {
        if empty()
        {
            return NSNull()
        }
        let object = stack.lastObject
        return object!
    }
    
    ///元素个数
    func count() -> Int
    {
        return stack.count
    }
    
    ///空栈
    func empty() -> Bool
    {
        return stack.count == 0
    }
}

//MARK: 队列迭代器

class QueueIterator: NSObject
{
    private lazy var quene = NSMutableArray()
    
    /// 入队
    func inQuene(object :Any)
    {
        quene.add(object)
    }
    
    /// 出队
    func outQuene() -> Any
    {
        let object = readQueneHead()
        if empty() == false
        {
            quene.remove(object)
        }
        return object
    }
    
    /// 读取队首
    func readQueneHead()  -> Any
    {
        if empty()
        {
            return NSNull()
        }
        let object = quene.firstObject
        return object!
    }
    
    /// 元素个数
    func count() -> Int
    {
        return quene.count
    }
    
    /// 空队
    func empty() -> Bool
    {
        return quene.count == 0
    }
}
