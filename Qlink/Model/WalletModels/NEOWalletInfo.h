//
//  WalletInfo.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface NEOWalletInfo : BBaseModel

@property (nonatomic ,strong) NSString *privateKey;
@property (nonatomic ,strong) NSString *publicKey;
//@property (nonatomic ,strong) NSString *scriptHash;
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *wif;

- (BOOL)saveToKeyChain;
+ (void)deleteAllWallet;
+ (NSArray *)getAllNEOWallet;
+ (NEOWalletInfo *)getNEOWalletWithAddress:(NSString *)address;
+ (NSString *)getNEOPrivateKeyWithAddress:(NSString *)address;
+ (NSString *)getNEOEncryptedKeyWithAddress:(NSString *)address;
+ (NSString *)getNEOPublickKeyWithAddress:(NSString *)address;
+ (BOOL)deleteNEOWalletWithAddress:(NSString *)address;

@end
