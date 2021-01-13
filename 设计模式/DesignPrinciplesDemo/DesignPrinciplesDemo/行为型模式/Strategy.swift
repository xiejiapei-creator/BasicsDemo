//
//  Strategy.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/26.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

// 接口
protocol ContextInterface
{
    func quickSort()
    func insertSort()
}

class SortContext: ContextInterface
{
    var quickStrategy: QuickSortStrategy?
    var insertStrategy: InsertSortStrategy?
    
    func quickSort()
    {
        quickStrategy?.sort()
    }
    
    func insertSort()
    {
        insertStrategy?.sort()
    }
}

// 排序策略
protocol Strategy
{
    func sort()
}

// 快排策略
class QuickSortStrategy: Strategy
{
    func sort()
    {
        print("快排策略")
    }
}

// 插排策略
class InsertSortStrategy: Strategy
{
    func sort()
    {
        print("插排策略")
    }
}



