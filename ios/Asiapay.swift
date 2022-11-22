//import Material
 import AP_PaySDK
 import PassKit
 import StoreKit

@objc(Asiapay)
class Asiapay: NSObject, PaySDKDelegate {
    var environment: EnvType = EnvType.SANDBOX
    var merchantId: String = ""
    var paySDK = PaySDK.shared
    var currentResolve: RCTPromiseResolveBlock?
    var currentReject: RCTPromiseRejectBlock?
    var arrCapability = [PKMerchantCapability]()
    var arrNetwork :[PKPaymentNetwork] = []
    var extraDataa: [String : Any]?
    var resultPage = ""

    var showCloseButton = false
    var showToolbar = false
    var closeAlertMessagePrompt = "Do you really want to close this page ?"
    
    @objc(setup:withMId:)
    func setup(environment: String, mId: String) -> Void {
        if (environment == "Production") {
            self.environment = EnvType.PRODUCTION
        }
        self.merchantId = mId
        self.paySDK.delegate = self
        print("init paysdk \(environment) \(self.merchantId)")
        if #available(iOS 10.1, *) {
            arrNetwork.append(.JCB)
            arrCapability = [.capability3DS]
        } else {
            // Fallback on earlier versions
        }
    }

//   MARK:- Alipay HNK
    @objc(alipayHK:withMId:withCurrency:withOrderRef:withRemark:withResolve:withReject:)
    func alipayHK(withMId: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        extraDataa = ["redirect": "30",
                     "deeplink":"3"]
        makePayment(merchantID: withMId, channelType: PayChannel.WEBVIEW, method: "ALIPAYHKONL", amount: amount, currency: currency, orderRef: orderRef, remark: remark, resolve: resolve, reject: reject,extraData:extraDataa)
    }

//   MARK:- Alipay Global
    @objc(alipayGlobal:withMId:withCurrency:withOrderRef:withRemark:withResolve:withReject:)
    func alipayGlobal(withMId: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        makePayment(merchantID: withMId, channelType: PayChannel.WEBVIEW, method: "ALIPAYHKONL", amount: amount, currency: currency, orderRef: orderRef, remark: remark, resolve: resolve, reject: reject,extraData:extraDataa)
   
    }

   //   MARK:- Octopus
    @objc(octopus:withMId:withOrderRef:withRemark:withResolve:withReject:)
    func octopus(withMId: String,amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        extraDataa = ["eVoucher": "T",
                     "eVClassCode": "0001"]
        
        octopusPayment(merchantID: withMId, channelType: PayChannel.DIRECT, method: "OCTOPUS", amount: "11", currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }

    //   MARK:- Credit Card
    @objc(creditCard:withMerchantId:withCurrency:withMethod:withOrderRef:withRemark:withCardDetails:withExtraData:withPayType:withResolve:withReject:)

       func creditCard(withMerchantId: String, amount: String, currency: String, method: String, orderRef: String, remark: String, cardDetails: [String: String]?, extraData: [String: Any], payType: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

           var card: CardDetails? = nil

           if (cardDetails != nil) {

               card = CardDetails(cardHolderName: "First Last",cardNo: "4111111111110071",expMonth: "07",expYear: "2030",securityCode: "123")

           }
        
        creditMakePayment(merchantID: withMerchantId, channelType: PayChannel.DIRECT, method: "VISA", amount: amount, currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject, extraData: extraData, cardDetails: card)
      
       }
    
    //   MARK:- Wechat
    @objc(wechat:withMId:withOrderRef:withRemark:withResolve:withReject:)
    func wechat(withMId: String,amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        extraDataa = ["wechatUniversalLink": "https://paydollarmobileapp/",
                     "deeplink":"3"]
        
        makePayment(merchantID: withMId, channelType: PayChannel.WEBVIEW, method: "WECHATONL", amount: "0.01", currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject,extraData:extraDataa)
    }
    
    //   MARK:- unionpay
    @objc(unionpay:withMId:withOrderRef:withRemark:withResolve:withReject:)
    func unionpay(withMId: String,amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        extraDataa = ["redirect": "30",
                     "deeplink":"3"]
        unionPayMethod(merchantID: withMId, channelType: PayChannel.WEBVIEW, method: "ALL", amount: amount, currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject,extraData:extraDataa!)
    }

    //   MARK:- Payme
    @objc(payme:withMId:withOrderRef:withRemark:withResolve:withReject:)
    func payme(withMId: String,amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        extraDataa = ["deeplink":"3"]

        paymeMethod(merchantID: withMId, channelType: PayChannel.WEBVIEW, method: "PayMe", amount: "1.81", currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject,extraData:extraDataa!)
    }

//   MARK:- Fps
    @objc(fps:withMId:withOrderRef:withRemark:withResolve:withReject:)
    func fps(withMId: String,amount: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        FPSMethod(merchantID: withMId, channelType: PayChannel.DIRECT, method: "FPS", amount: amount, currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }
    
    //   MARK:- Hostedcall
    @objc(hostedcall:withMId:withCurrency:withOrderRef:withRemark:withResolve:withReject:)
    func hostedcall(withMId: String,amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        resultPage = "T"                //"T" for memberPay
        extraDataa = ["eVoucher": "T",
                     "eVClassCode": "0001","deeplink":"3","redirect": "30"]
        extraDataa = ["":""]
        hostedMethod(merchantID: withMId, channelType: PayChannel.WEBVIEW, method: "ALL", amount: "0.1", currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }

       //   MARK:- Apple Pay
    @objc(applepay:withMId:withCurrency:withOrderRef:withRemark:withResolve:withReject:)
    func applepay(withMId: String,amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {

        applePayMethod(merchantID: withMId, channelType: PayChannel.DIRECT, method: "APPLEPAY", amount: "1", currency: "HKD", orderRef: orderRef, remark: remark, resolve: resolve, reject: reject)
    }
    
    
    
 //   MARK:- Alipay Payment Method
    
    func makePayment(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any]? = ["": ""], payType: payType = payType.NORMAL_PAYMENT) -> Void {
       
        print("Pay \(method), order ref \(orderRef)")
        self.currentResolve = resolve
        self.currentReject = reject
        
        merchantId = "88146271"
        showCloseButton = true
        
        if #available(iOS 10.1, *) {
            paySDK.paymentDetails = PayData(channelType: channelType,
                                            envType: self.environment,//.SANDBOX,
                                            amount: amount,
                                            payGate: PayGate.PAYDOLLAR,
                                            currCode: getCurrencyCode(currencyCode: currency),
                                            payType: payType,
                                            orderRef: orderRef,
                                            payMethod: method,
                                            lang: Language.ENGLISH,
                                            merchantId: merchantID,
                                            remark: remark,
                                            payRef: "",
                                            resultpage: resultPage,
                                            showCloseButton: showCloseButton,
                                            showToolbar: showToolbar,
                                            webViewClosePrompt: closeAlertMessagePrompt,
                                            extraData: extraData, merchantCapabilitiesData: [.capability3DS], supportedNetworksData: [.amex,.JCB])
        } else {
            // Fallback on earlier versions
        }
        
        paySDK.process()

    }

    //   MARK:- Octopus Payment Method

    func octopusPayment(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any]? = ["": ""], payType: payType = payType.NORMAL_PAYMENT) -> Void {
        
        if #available(iOS 10.1, *) {
            paySDK.paymentDetails = PayData(channelType: .DIRECT,
                                            envType: self.environment,
                                            amount: amount,
                                            payGate: PayGate.PAYDOLLAR,
                                            currCode: getCurrencyCode(currencyCode: currency),
                                            payType: payType,
                                            orderRef: orderRef,
                                            payMethod: method,
                                            lang: Language.ENGLISH,
                                            merchantId: merchantID,
                                            remark: remark,
                                            payRef: "",
                                            resultpage: resultPage,
                                            showCloseButton: showCloseButton,
                                            showToolbar: showToolbar,
                                            webViewClosePrompt: closeAlertMessagePrompt,
                                            extraData: extraData, merchantCapabilitiesData: [.capability3DS], supportedNetworksData: [.amex,.JCB])
        } else {
            // Fallback on earlier versions
        }
        
        paySDK.paymentDetails.callBackParam = CallBackParam(successUrl :
                                                                //                                                                "xxx://abc//success",
                                                                "AppSwift://paysdk/payment/status?payref=10893335&orderref=1654651517783",
                                                            cancelUrl : "AppSwift://cancel",
                                                            errorUrl: "AppSwift://error",
                                                            failUrl : "AppSwift://fail")

        paySDK.process()
        
    }
 
    //   MARK:- Credit Payment Method
       
       func
       creditMakePayment(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any] = ["": ""], payType: payType = payType.NORMAL_PAYMENT, cardDetails: CardDetails? = nil) -> Void {
          
        if #available(iOS 10.1, *) {
            paySDK.paymentDetails = PayData(channelType: channelType,
                                            envType: self.environment,
                                            amount: amount,
                                            payGate: PayGate.PAYDOLLAR,
                                            currCode: getCurrencyCode(currencyCode: currency),
                                            payType: payType,
                                            orderRef: orderRef,
                                            payMethod: method,
                                            lang: Language.ENGLISH,
                                            merchantId: merchantID,
                                            remark: remark,
                                            payRef: "",
                                            resultpage: "F",
                                            showCloseButton: showCloseButton,
                                            showToolbar: showToolbar,
                                            webViewClosePrompt: closeAlertMessagePrompt,
                                            extraData: nil, merchantCapabilitiesData: [.capability3DS], supportedNetworksData: [.amex,.JCB])
        } else {
            // Fallback on earlier versions
        }
        paySDK.paymentDetails.cardDetails = cardDetails
        paySDK.process()
        
       }

    //   MARK:- Union Payment Method
       
    func
       unionPayMethod(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any] = ["": ""], payType: payType = payType.NORMAL_PAYMENT) -> Void {
          
           print("Pay \(method), order ref \(orderRef)")
           self.currentResolve = resolve
           self.currentReject = reject
        
           if #available(iOS 10.1, *) {
               paySDK.paymentDetails = PayData(channelType: channelType,
                                               envType: self.environment,
                                               amount: amount,
                                               payGate: PayGate.PAYDOLLAR,
                                               currCode: getCurrencyCode(currencyCode: currency),
                                               payType: payType,
                                               orderRef: orderRef,
                                               payMethod: method,
                                               lang: Language.ENGLISH,
                                               merchantId: merchantID,
                                               remark: remark,
                                               payRef: "",
                                               resultpage: "F",showCloseButton: true, showToolbar:true,webViewClosePrompt:"",
                                               extraData: extraData, merchantCapabilitiesData: [.capability3DS], supportedNetworksData:[.JCB])
           } else {
               // Fallback on earlier versions
           }

           paySDK.process()
       }
    
    
    //   MARK:- FPS Payment Method
       
    func FPSMethod(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, payType: payType = payType.NORMAL_PAYMENT) -> Void {
          
        if #available(iOS 10.1, *) {
            paySDK.paymentDetails = PayData(channelType: channelType,
                                            envType: self.environment,
                                            amount: amount,
                                            payGate: PayGate.PAYDOLLAR,
                                            currCode: getCurrencyCode(currencyCode: currency),
                                            payType: payType,
                                            orderRef: orderRef,
                                            payMethod: method,
                                            lang: Language.ENGLISH,
                                            merchantId: merchantID,
                                            remark: remark,
                                            payRef: "",
                                            resultpage: "F",
                                            showCloseButton: showCloseButton,
                                            showToolbar: showToolbar,
                                            webViewClosePrompt: closeAlertMessagePrompt,
                                            extraData: ["fpsQueryUrl" : "https://fps.paydollar.com/api/fpsQrUrl?encrypted="], merchantCapabilitiesData: [.capability3DS], supportedNetworksData: [.amex,.JCB])
        } else {
            // Fallback on earlier versions
        }
        
        paySDK.process()
    
    }
    
    //   MARK:- Payme Payment Method

    func paymeMethod(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any] = ["": ""], payType: payType = payType.NORMAL_PAYMENT) -> Void {

        if #available(iOS 10.1, *) {
            paySDK.paymentDetails = PayData(channelType: channelType,
                                            envType: self.environment, //.SANDBOX,
                                            amount: amount,//"0.81",//"0.77 fail",
                                            payGate: PayGate.PAYDOLLAR,//PayGate.PAYDOLLAR,
                                            currCode: getCurrencyCode(currencyCode: currency),//CurrencyCode.MYR,
                                            payType: payType,
                                            orderRef: orderRef,
                                            payMethod: method,
                                            lang: Language.ENGLISH,
                                            merchantId: merchantID,
                                            remark: remark,
                                            payRef: "",
                                            resultpage: "F",
                                            showCloseButton: showCloseButton,
                                            showToolbar: showToolbar,
                                            webViewClosePrompt: closeAlertMessagePrompt,
                                            extraData: extraData, merchantCapabilitiesData: [.capability3DS], supportedNetworksData: [.amex,.JCB])
        } else {
            // Fallback on earlier versions
        }
 
    paySDK.paymentDetails.callBackParam = CallBackParam(successUrl : "AppSwift://success",
                                                        cancelUrl : "AppSwift://cancel",
                                                        errorUrl: "AppSwift://error",
                                                        failUrl : "AppSwift://fail")
    
    paySDK.paymentDetails.cardDetails = CardDetails(cardHolderName: "First Last",
                                                    cardNo: "4444333322221111",
                                                    expMonth: "12",
                                                    expYear: "2022",
                                                    securityCode: "124")
    
    paySDK.process()
        
    }
    
    //   MARK:- Hosted Payment Method

    func hostedMethod(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any] = ["": ""], payType: payType = payType.NORMAL_PAYMENT) -> Void {

        if #available(iOS 10.1, *) {
            paySDK.paymentDetails = PayData(channelType: channelType,
                                            envType: self.environment,
                                            amount :amount,
                                            payGate: PayGate.PAYDOLLAR,
                                            currCode: getCurrencyCode(currencyCode: currency),
                                            payType: payType,
                                            orderRef: "2018102409220001",
                                            payMethod: method,
                                            lang: Language.CHINESE_TRADITIONAL,
                                            merchantId: merchantID,
                                            remark: "",
                                            payRef: "",
                                            resultpage: "F",
                                            showCloseButton: true,
                                            showToolbar: true,
                                            webViewClosePrompt: "Do you want to close?",
                                            extraData :[:], merchantCapabilitiesData: [.capability3DS], supportedNetworksData: [.amex,.JCB])
        } else {
            // Fallback on earlier versions
        }
    paySDK.paymentDetails.presentController = PresentViewController(presentViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
    paySDK.process()
        
    }
    
    //   MARK:- Apple Pay Method

    func applePayMethod(merchantID: String,channelType: PayChannel, method: String, amount: String, currency: String, orderRef: String, remark: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock, extraData: [String : Any] = ["": ""], payType: payType = payType.NORMAL_PAYMENT) -> Void {
      
        if #available(iOS 10.1, *) {
            paySDK.paymentDetails = PayData(channelType: channelType,
                                            envType: self.environment,
                                            amount: amount,
                                            payGate: PayGate.PAYDOLLAR,
                                            currCode: getCurrencyCode(currencyCode: currency),
                                            payType: payType,
                                            orderRef: orderRef,
                                            payMethod: method,
                                            lang: Language.ENGLISH,
                                            merchantId: merchantID,
                                            remark: remark,
                                            payRef: "",
                                            resultpage: resultPage,
                                            showCloseButton: showCloseButton,
                                            showToolbar: showToolbar,
                                            webViewClosePrompt: closeAlertMessagePrompt,
                                            extraData: ["apple_countryCode" : "US",
                                                        "apple_currencyCode" : "USD",
                                                        "apple_billingContactEmail" : "abc@gmail.com",
                                                        "apple_billingContactPhone" : "1234567890",
                                                        "apple_billingContactGivenName" : "ABC",
                                                        "apple_billingContactFamilyName" : "XYZ",
                                                        "apple_requiredBillingAddressFields" : "",
                                                        "apple_merchant_name" : "AsiaPay",
                                                        "apple_merchantId" : "merchant.com.asiapay.applepay.test"], merchantCapabilitiesData: [.capability3DS, .capabilityCredit, .capabilityDebit, .capabilityEMV], supportedNetworksData: [.amex,.JCB])
        } else {
            // Fallback on earlier versions
        }
        paySDK.process()
      
        }


    //   MARK:- Result Method

    func paymentResult(result: PayResult) {

        print("amount \(result.amount ?? "")\nsuccessCode \(result.successCode ?? "")     \nmaskedCardNo \(result.maskedCardNo ?? "")\nauthId \(result.authId ?? "")\ncardHolder \(result.cardHolder ?? "")\ncurrencyCode \(result.currencyCode ?? "")\nerrMsg \(result.errMsg ?? "")\nord \(result.ord ?? "")\npayRef \(result.payRef ?? "")\nprc \(result.prc ?? "")\nsrc \(result.src ?? "")\ntransactionTime \(result.transactionTime ?? "")\ndescriptionStr \(result.descriptionStr ?? "")\nRef \(result.ref ?? "")")
        
    }
    
    //   MARK:- Get Currency Method
    
    func getCurrencyCode(currencyCode: String) -> CurrencyCode {
        let payCurrencyCode: CurrencyCode;

        switch currencyCode {
        case "HKD":
            payCurrencyCode = CurrencyCode.HKD
        case "USD":
            payCurrencyCode = CurrencyCode.USD
        case "SGD":
            payCurrencyCode = CurrencyCode.SGD
        case "RMB":
            payCurrencyCode = CurrencyCode.RMB
        case "CNY":
            payCurrencyCode = CurrencyCode.CNY
        case "YEN":
            payCurrencyCode = CurrencyCode.YEN
        case "JPY":
            payCurrencyCode = CurrencyCode.JPY
        case "TWD":
            payCurrencyCode = CurrencyCode.TWD
        case "AUD":
            payCurrencyCode = CurrencyCode.AUD
        case "EUR":
            payCurrencyCode = CurrencyCode.EUR
        case "GBP":
            payCurrencyCode = CurrencyCode.GBP
        case "CAD":
            payCurrencyCode = CurrencyCode.CAD
        case "MOP":
            payCurrencyCode = CurrencyCode.MOP
        case "PHP":
            payCurrencyCode = CurrencyCode.PHP
        case "THB":
            payCurrencyCode = CurrencyCode.THB
        case "IDR":
            payCurrencyCode = CurrencyCode.IDR
        case "BND":
            payCurrencyCode = CurrencyCode.BND
        case "MYR":
            payCurrencyCode = CurrencyCode.MYR
        case "BRL":
            payCurrencyCode = CurrencyCode.BRL
        case "INR":
            payCurrencyCode = CurrencyCode.INR
        case "TRY":
            payCurrencyCode = CurrencyCode.TRY
        case "ZAR":
            payCurrencyCode = CurrencyCode.ZAR
        case "VND":
            payCurrencyCode = CurrencyCode.VND
        case "LKR":
            payCurrencyCode = CurrencyCode.LKR
        case "KWD":
            payCurrencyCode = CurrencyCode.KWD
        case "NZD":
            payCurrencyCode = CurrencyCode.NZD
        default:
            payCurrencyCode = CurrencyCode.HKD
        }

        return payCurrencyCode
    }

    
    func showProgress() {

    }
    func hideProgress() {

    }
    
    //   MARK:- Get Currency Method

    func getPayType(payTypeStr: String) -> payType {
        if (payTypeStr == "N") {
            return payType.NORMAL_PAYMENT
        }
        return payType.HOLD_PAYMENT
    }

    //   MARK:- Query Result details

    func transQueryResults(result: TransQueryResults) {
        print(result)
    }

    //   MARK:- Method details

    func payMethodOptions(method: PaymentOptionsDetail) {
        print(method)
    }

    //   MARK:- Dictionary to Json conversion

    func toJson(result: PayResult) -> String {
        let dic = [
            "amount":result.amount,
            "successCode":result.successCode,
            "maskedCardNo":result.maskedCardNo,
            "authId":result.authId,
            "cardHolder":result.cardHolder,
            "currencyCode":result.currencyCode,
            "errMsg":result.errMsg,
            "ord":result.ord,
            "payRef":result.payRef,
            "prc":result.prc,
            "ref":result.ref,
            "src":result.src,
            "transactionTime":result.transactionTime,
            "descriptionStr":result.descriptionStr
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)!
        return jsonStr
    }

    //   MARK:- Json to Dictionary conversion

    func toDict(result: PayResult) -> [String: String?] {
        return [
            "amount":result.amount,
            "successCode":result.successCode,
            "maskedCardNo":result.maskedCardNo,
            "authId":result.authId,
            "cardHolder":result.cardHolder,
            "currencyCode":result.currencyCode,
            "errMsg":result.errMsg,
            "ord":result.ord,
            "payRef":result.payRef,
            "prc":result.prc,
            "ref":result.ref,
            "src":result.src,
            "transactionTime":result.transactionTime,
            "descriptionStr":result.descriptionStr
        ]
    }
}
