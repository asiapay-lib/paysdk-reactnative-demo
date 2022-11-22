#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Asiapay, NSObject)

RCT_EXTERN_METHOD(setup: (NSString) environment withMId: (NSString) mId)
RCT_EXTERN_METHOD(alipayHK: (NSString)amount
                  withMId: (NSString) mId
                  withCurrency: (NSString)currency
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(alipayGlobal: (NSString)amount
                  withMId: (NSString) mId
                  withCurrency: (NSString)currency
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(octopus: (NSString)amount
                  withMId: (NSString) mId
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(wechat: (NSString)amount
                  withMId: (NSString) mId
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)    
// RCT_EXTERN_METHOD(creditCard: (NSString)amount
//                   withMerchantId: (NSString) merchantId
//                   withCurrency: (NSString)currency
//                   withMethod: (NSString)method
//                   withOrderRef: (NSString)orderRef
//                   withRemark:(NSString)remark
//                   withCardDetails: (NSDictionary)cardDetails
//                   withExtraData: (NSDictionary)extraData
//                   withPayType: (NSString)payType
//                   withResolve: (RCTPromiseResolveBlock)resolve
//                   withReject: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(creditCard:(NSString)amount
                  withMerchantId: (NSString) merchantId
                  withCurrency: (NSString)currency
                  withMethod:(NSString)method
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withCardDetails: (NSDictionary)cardDetails
                  withExtraData: (NSDictionary)extraData
                  withPayType: (NSString)payType
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(unionpay: (NSString)amount
                  withMId: (NSString)mId
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fps: (NSString)amount
                  withMId: (NSString) mId
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)    
RCT_EXTERN_METHOD(payme: (NSString)amount
                  withMId: (NSString) mId
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)    
RCT_EXTERN_METHOD(hostedcall: (NSString)amount
                  withMId: (NSString)mId
                  withCurrency: (NSString)currency
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)    
RCT_EXTERN_METHOD(applepay: (NSString)amount
                  withMId: (NSString)mId
                  withCurrency: (NSString)currency
                  withOrderRef: (NSString)orderRef
                  withRemark: (NSString)remark
                  withResolve: (RCTPromiseResolveBlock)resolve
                  withReject: (RCTPromiseRejectBlock)reject)                                                                                                                
                                

@end
