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
