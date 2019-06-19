//
//  QLCWalletManage.h
//  Qlink
//
//  Created by Jelly Foo on 2019/5/23.
//  Copyright © 2019 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLCWalletManage : NSObject

+ (instancetype)shareInstance;
- (BOOL)createWallet;
- (BOOL)importWalletWithSeed:(NSString *)seed;
- (BOOL)importWalletWithMnemonic:(NSString *)mnemonic;
- (BOOL)walletSeedIsValid:(NSString *)seed;
- (NSString *)exportMnemonicWithSeed:(NSString *)seed;
- (NSString *)walletAddress;
- (NSString *)walletPrivateKeyStr;
- (NSString *)walletPublicKeyStr;
- (NSString *)walletSeed;
- (BOOL)walletAddressIsValid:(NSString *)address;
- (BOOL)switchWalletWithSeed:(NSString *)seed;
- (void)sendAssetWithTokenName:(NSString *)tokenName to:(NSString *)to amount:(NSUInteger)amount sender:(nullable NSString *)sender receiver:(nullable NSString *)receiver message:(nullable NSString *)message successHandler:(void(^_Nonnull)(NSString * _Nullable responseObj))successHandler failureHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString *_Nullable message))failureHandler;
- (void)receive_accountsPending:(NSString *)address;

@end