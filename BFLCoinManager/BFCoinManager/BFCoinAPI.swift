//
//  BFCoinAPI.swift
//  BFCoinAPI
//
//  Created by jaeeun on 2018/01/30.
//  Copyright © 2018年 leejaeeun. All rights reserved.
//

import Foundation
import Alamofire

/*
 API制限
 HTTP API は、以下のとおり呼出回数を制限いたします。
 Private API は 1 分間に約 200 回を上限とします。
 IP アドレスごとに 1 分間に約 500 回を上限とします。
 注文数量が 0.01 以下の注文を大量に発注するユーザーは、一時的に、発注できる注文数が 1 分間に約 10 回までに制限されることがあります。
 システムに負荷をかける目的での発注を繰り返していると当社が判断した場合は、API の使用が制限されることがあります。ご了承ください。
 */

final class BFCoinAPI {
    
    // ホスト名
    private static let Host = "https://api.bitflyer.jp/v1"
    
    // 共通ヘッダー
    static let CommonHeaders:HTTPHeaders = [
        "Authorization": "",
        "Version": Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String,
        "Accept": "application/json"
    ]
    
     //リクエスト処理の生成
    private class func createRequest(url:String, parameters: Parameters? = nil) -> Alamofire.DataRequest {
    
        return Alamofire.request("\(Host)\(url)",
                    method:.get,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: BFCoinAPI.CommonHeaders).validate()
        
//        return Alamofire.request("\(Host)\(url)",
//            method:.get,
//            parameters: parameters,
//            encoding: JSONEncoding.default,
//            headers: BFCoinAPI.CommonHeaders).validate()
    }
    
    //マーケットの一覧
    static func requestMarkets() -> Void {
        
        self.createRequest(url: "/markets", parameters: nil).responseJSON { response in
            
            if let JSON = response.result.value {
                print("Success with response")
                print(JSON)
            }else{
                print("Error with response")
            }
        }
    }
    
    //板情報
    static func requestBoard(_ productCode: String?) -> Void {
        
        let parameters = (productCode == nil) ? nil : ["product_code":productCode as Any]
        
        self.createRequest(url: "/board", parameters: parameters).responseJSON { response in
            
            if let JSON = response.result.value {
                print("Success with response")
                print(JSON)
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //Ticker
    static func requestTicker(_ productCode: String?) -> Void {
        
        let parameters = (productCode == nil) ? nil : ["product_code":productCode as Any]
        
        self.createRequest(url: "/ticker", parameters: parameters).responseJSON { response in
            
            if let JSON = response.result.value {
                print("Success with response")
                print(JSON)
            }else{
                print("Error with response")
            }
        }
        
    }
    
     //約定履歴
    static func requestExecutions(_ productCode: String?, before: String?, after: String?, count: Int?) -> Void {
        
        let parameters = (productCode == nil) ? nil : ["product_code":productCode as Any]
        
        /*
         count: 結果の個数を指定します。省略した場合の値は 100 です。
         before: このパラメータに指定した値より小さい id を持つデータを取得します。
         after: このパラメータに指定した値より大きい id を持つデータを取得します。
         */
        self.createRequest(url: "/executions", parameters: parameters).responseJSON { response in
            
            if let JSON = response.result.value {
                print("Success with response")
                print(JSON)
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //板の状態
    static func requestBoardState(_ productCode: String?) -> Void {
        
        let parameters = (productCode == nil) ? nil : ["product_code":productCode as Any]
        
        self.createRequest(url: "/getboardstate", parameters: parameters).responseJSON { response in
            
            if let JSON = response.result.value {
                print("Success with response")
                print(JSON)
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //取引所の状態
    static func requestHealth(_ productCode: String?) -> Void {
        
        let parameters = (productCode == nil) ? nil : ["product_code":productCode as Any]
        
        self.createRequest(url: "/gethealth", parameters: parameters).responseJSON { response in
            
            if let JSON = response.result.value {
                print("Success with response")
                print(JSON)
            }else{
                print("Error with response")
            }
        }
        
    }
    
    //取引所の状態
    static func requestCharts(_ fromDate: Date?) -> Void {
        
        var dateString : String? = nil
        
        if let chartDate = fromDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateString = dateFormatter.string(from: chartDate)
        }
        
        let parameters = (dateString == nil) ? nil : ["from_date":dateString as Any]
        
        self.createRequest(url: "/getchats", parameters: parameters).responseJSON { response in
            
            if let JSON = response.result.value {
                print("Success with response")
                print(JSON)
            }else{
                print("Error with response")
            }
        }
        
    }
}
