//
//  Ticker.swift
//  BFLCoinManager
//
//  Created by jaeeun on 2018/01/31.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation

/*
 {"product_code": "BTC_JPY",
 "timestamp": "2015-07-08T02:50:59.97",
 "tick_id": 3579,
 "best_bid": 30000,
 "best_ask": 36640,
 "best_bid_size": 0.1,
 "best_ask_size": 5,
 "total_bid_depth": 15.13,
 "total_ask_depth": 20,
 "ltp": 31690,
 "volume": 16819.26,
 "volume_by_product": 6819.26}
 */
struct Ticker {
    var productCode     :String
    var timestamp       :Date
    var tickId          :UInt64
    var bestBid         :Int
    var bestAsk         :Int
    var bestBidSize     :Double
    var bestAskSize     :Double
    var totalBidDepth   :Double
    var totalAskDepth   :Double
    var ltp             :Int
    var volume          :Double
    var volumeByProduct :Double
}
