# BFLCoinManager
BitFlyerで提供したApiを利用したサンプルコードです。
Restful API, リアルタイムAPIを利用してデータを受信できます。

APIの情報はこちら

- BitFlyer

https://bitflyer.jp/ja-jp/api

- チャート用

https://www.cryptocompare.com/api/

## Setup

### CocoaPods

`podfile`に下記のライブラリを追加、インストールします。

```
  # Pods for BFLCoinManager

  pod 'Alamofire', '~> 4.5'
  pod 'PubNub', '~> 4'
```  

### コード追加

`AppDelegate.swift`に下記のコードを追加します。

```
import PubNub

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: Setup realtime Client
        self.client = BFLCoinManager.shared.realtimeClient
        self.client.addListener(self)
        
        BFLCoinManager.shared.start()
        
        return true
    }
}
```

### ファイル追加

`BFCoinManager`直下の`BFCoinManager`フォルダにあるソースをプロジェクトへ追加
        
## Usage

### ViewControllerにコードを追加

データイベントをObserverします。
```
override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Add Observer
        BFLCoinManager.shared.addObserver(self)
        
    }
```

Callbackメソッド追加します。
```
extension ViewController : BFLCoinManagerDataChanged {
    
    func coinDataDidLoad(_ context:BFContext) {
        print("context loaded!!")
        //print(context)
    }
    
    func coinDataChanged(channel: Channel, productCode: String, data: Any) {
        print("context changed!!")
    }
```
