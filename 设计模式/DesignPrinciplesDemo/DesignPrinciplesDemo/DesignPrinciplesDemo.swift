//
//  DesignPrinciplesDemo.swift
//  Demo
//
//  Created by 谢佳培 on 2020/8/25.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

import UIKit
import Foundation

//MARK: 单一职责原则
class OrderList: NSObject //订单列表
{
    var waitPayList: WaitPayList? //待支付
    var waitGoodsList: WaitGoodsList? //待收货
    var receivedGoodsList: ReceivedGoodsList? //已收货
}

class WaitPayList: NSObject
{
    
}

class WaitGoodsList: NSObject
{
    
}

class ReceivedGoodsList: NSObject
{
    
}

//MARK: 开闭原则

class PayHelper
{
    var processors: [Int: PayProcessor]?
    
    func pay(send: PaySendModel) -> Void
    {
        if send.type == 0
        {
            //支付宝支付
        }
        else if send.type == 1
        {
            //微信支付
        }
        
        guard let processors = processors else {return}
        guard let payProcessor: PayProcessor = processors[send.type] else {return}
        
        payProcessor.handle(send: send)//支付
    }
}

class PaySendModel
{
    var type: Int = 0
    var info: [String: AnyHashable]?
}

protocol PayProcessor
{
    func handle(send: PaySendModel)
}

class AliPayProcessor: PayProcessor
{
    func handle(send: PaySendModel)
    {
        
    }
}

class WeChatPayProcessor: PayProcessor
{
    func handle(send: PaySendModel)
    {
        
    }
}

//MARK: 里氏替换原则

class Car
{
    func run()
    {
        print("汽车跑起来了")
    }
}

class BaoMaCar: Car
{
    override func run()
    {
        super.run()
        
        print("当前行驶速度是80Km/h")
    }
    
    func showSpeed()
    {
        print("当前行驶速度是80Km/h")
    }
}

//MARK: 接口隔离原则

protocol CarProtocol
{
    func run()
    func showSpeed()
    func playMusic()
}

class MyCar: CarProtocol
{
    func run()
    {
        print("汽车跑起来了")
    }
    
    func showSpeed()
    {
        print("当前行驶速度是80Km/h")
    }
    
    func playMusic()
    {
        print("播放音乐")
    }
}

protocol ProfessionalCar //具备一般功能的车
{
    func run()
    func showSpeed()
}

protocol EntertainingCar //具备娱乐功能的车
{
    func run()
    func showSpeed()
    func playMusic()
}

class SangTaNaCar: ProfessionalCar //桑塔纳轿车
{
    func run()
    {
        print("汽车跑起来了")
    }
    
    func showSpeed()
    {
        print("当前行驶速度是80Km/h")
    }
}

class BMWCar: EntertainingCar //宝马轿车
{
    func run()
    {
        print("汽车跑起来了")
    }
    
    func showSpeed()
    {
        print("当前行驶速度是80Km/h")
    }
    
    func playMusic()
    {
        print("播放音乐")
    }
}

//MARK: 依赖倒置原则
 
class CarGas
{
    func refuel(_ gaso: Gasoline90)
    {
        print("加90号汽油")
    }
    
    func refuel(_ gaso: Gasoline93)
    {
        print("加93号汽油")
    }
    
    func refuel(_ gaso: Gasoline)
    {
        print("加\(gaso.name)汽油")
    }
}

protocol Gasoline
{
    var name: String { get }
}

class Gasoline90: Gasoline
{
    var name: String = "90号"
}

class Gasoline93: Gasoline
{
    var name: String = "93号"
}

//MARK: 迪米特法则

class Person //车主
{
    var car: GasolineCar?
    
    func refuel(_ gaso: GasolineSecond)
    {
        if gaso.isQuality == true //如果汽油质量过关，我们就给汽车加油
        {
            car?.refuel(gaso)
        }
    }
    
    func refuel(_ worker: WorkerInPetrolStation, _ gaso: GasolineSecond)
    {
        guard let car = car else {return}
        
        worker.refuel(car, gaso)
    }
}

class WorkerInPetrolStation //加油站工作人员
{
    func refuel(_ car: GasolineCar, _ gaso: GasolineSecond)
    {
        if gaso.isQuality == true //如果汽油质量过关，我们就给汽车加油
        {
            car.refuel(gaso)
        }
    }
}

class GasolineCar
{
    func refuel(_ gaso: GasolineSecond)
    {
        print("加\(gaso.name)汽油")
    }
}

protocol GasolineSecond
{
    var name: String { get }
    var isQuality: Bool { get }
}

class Gasoline90Second: GasolineSecond
{
    var name: String = "90号"
    var isQuality: Bool = false
}

class Gasoline93Second: GasolineSecond
{
    var name: String = "93号"
    var isQuality: Bool = true
}
