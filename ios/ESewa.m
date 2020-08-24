//
//  ESewa.m
//  TestESewav2
//
//  Created by Aman Maharjan on 8/21/20.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(ESewa, NSObject)
RCT_EXTERN_METHOD(increment)
RCT_EXTERN_METHOD(getCount: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(
                  decrement: (RCTPromiseResolveBlock)resolve
                  rejector: (RCTPromiseRejectBlock)reject
                  )
RCT_EXTERN_METHOD(pay: (NSString)merchantId
                  extMerchantSecret: (NSString)merchantSecret
                  extProductId: (NSString)productId
                  extProductName: (NSString)productName
                  extProductAmount: (NSString)productAmount
                  extCallbackUrl: (NSString)callbackUrl
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejector: (RCTPromiseRejectBlock)reject
                  )
@end
