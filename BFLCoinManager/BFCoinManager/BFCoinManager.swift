//
//  BFCoinManager.swift
//  BFLCoinManager
//
//  Created by jaeeun on 2018/01/30.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation
import PubNub

final class BFLCoinManager {
    
    var realtimeApi : BFCoinRealtimeAPI
    var realtimeClient : PubNub
    
    var context : Dictionary?
    static let sharedManager: BFLCoinManager = BFLCoinManager()
    
    private init() {
        
        //setup realtime client
        self.realtimeClient = BFCoinRealtimeAPI.setupClient()
        self.realtimeApi = BFCoinRealtimeAPI(self.realtimeClient)
    }
    
    func start() {
        
        //Request
        
        //Regist realtime message
        
    }
    
    
    //MARK: Realtime
    func updateRealtime(_ message: PNMessageResult) {
        
    }
}
