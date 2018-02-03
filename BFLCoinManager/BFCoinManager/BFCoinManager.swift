//
//  BFCoinManager.swift
//  BFLCoinManager
//
//  Created by jaeeun on 2018/01/30.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation
import PubNub

protocol BFLCoinManagerDataChanged : AnyObject {
    func coinDataChanged(_ context:BFContext)
}

final class BFLCoinManager {
    
    open private(set) var context         : BFContext
    
//    private var requestAPi                : BFCoinAPI
    open private(set) var realtimeApi     : BFCoinRealtimeAPI
    open private(set) var realtimeClient  : PubNub
    
    private var observers = Array<BFLCoinManagerDataChanged>()
    
    
    //var context : Dictionary?
    static let sharedManager: BFLCoinManager = BFLCoinManager()
    
    private init() {
        
        //setup realtime client
//        self.requestAPi = BFCoinAPI()
        self.realtimeClient = BFCoinRealtimeAPI.setupClient()
        self.realtimeApi = BFCoinRealtimeAPI(self.realtimeClient)
        self.context = BFContext()
    }
    
    //MARK: Observer
    open func addObserver(_ observer: BFLCoinManagerDataChanged) {
        for item in observers {
            if item === observer {
                return
            }
        }
        
        //登録する
        observers.append(observer)
    }
    
    open func removeObserver(_ observer: BFLCoinManagerDataChanged) {
        
        for (index, item) in observers.enumerated() {
            if item === observer {
                //解除する
                observers.remove(at: index)
                break
            }
        }
    }
    
    open func removeAllObserver() {
        observers.removeAll()
    }
    
    private func loadNotification(_ ctx: BFContext) {
        
        for observer in observers {
            //通知する
            observer.coinDataChanged(ctx)
        }
        
    }
    
    //MARK: Start
    func start() {
        
        self.keepAliveCountUp()
        
        //Request
        BFCoinAPI.requestMarkets { (markets) in
            self.context.markets = markets
            self.keepAliveCountDown()
        }
        
        waitKeepAlive()
        
        for market in self.context.markets {
            self.keepAliveCountUp()
            BFCoinAPI.requestBoard(market.productCode, completion: { (board) in
                self.keepAliveCountDown()
                
                self.context.boards.append(board)
                
            })
            
            self.keepAliveCountUp()
            BFCoinAPI.requestTicker(market.productCode, completion: { (ticker) in
                self.keepAliveCountDown()
                
                self.context.tickers.append(ticker)
                
            })
            
            self.keepAliveCountUp()
            BFCoinAPI.requestExecutions(market.productCode, before: nil, after: nil, count: nil, completion: { (executions) in
                self.keepAliveCountDown()
                
                if let productCode = market.productCode {
                    self.context.executions.append([productCode:executions])
                }
                
            })
 
            self.keepAliveCountUp()
            BFCoinAPI.requestBoardState(market.productCode, completion: { (boardState) in
                self.keepAliveCountDown()
                
                if let productCode = market.productCode {
                    self.context.boardStates.append([productCode:boardState])
                }
            })
            
            self.keepAliveCountUp()
            BFCoinAPI.requestHealth(nil, completion: { (health) in
                self.keepAliveCountDown()
                
                if let productCode = market.productCode {
                    self.context.healths.append([productCode:health])
                }
            })
        }
        
        waitKeepAlive()
        
        //1時間前チャット。データ量が多い。。
        BFCoinAPI.requestCharts(Date(timeIntervalSinceNow: -60*60*1), completion: {(chats) in
            
            self.context.chats = chats
        })
        
        loadNotification(self.context)
        
        
        //Regist realtime message
        
    }
    
    
    
    
    //MARK: Realtime
    func updateRealtime(_ message: PNMessageResult) {
        
    }
    
}

//MARK: ロック制御
extension BFLCoinManager {
    
    static private var keepAliveCount = 0
    
    fileprivate func keepAliveCountUp() {
        BFLCoinManager.keepAliveCount = BFLCoinManager.keepAliveCount + 1
        print("keepAliveCount: \(print(BFLCoinManager.keepAliveCount))")
    }
    
    fileprivate func keepAliveCountDown() {
        BFLCoinManager.keepAliveCount = BFLCoinManager.keepAliveCount - 1
        print("keepAliveCount: \(print(BFLCoinManager.keepAliveCount))")
    }
    
    fileprivate func waitKeepAlive() {
        let runLoop = RunLoop.current
        while BFLCoinManager.keepAliveCount > 0 &&
            runLoop.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1)) {
                // 0.1秒毎の処理なので、処理が止まらない
        }
    }
}

