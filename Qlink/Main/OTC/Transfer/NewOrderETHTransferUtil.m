//
//  NewOrderTransferUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/20.
//  Copyright © 2019 pan. All rights reserved.
//

#import "NewOrderETHTransferUtil.h"
#import "WalletCommonModel.h"
#import "ETHTransferConfirmView.h"
#import <ETHFramework/ETHFramework.h>
#import "ReportUtil.h"
#import "ETHAddressInfoModel.h"
#import "GlobalConstants.h"
#import "NSString+RemoveZero.h"
#import "WalletsViewController.h"
#import "QlinkTabbarViewController.h"
#import "ETHWalletManage.h"

@implementation NewOrderETHTransferUtil

#pragma mark - Transfer
+ (void)transferETH:(NSString *)tokenName amountStr:(NSString *)amountStr successB:(ETHTransferSuccessBlock)successB {
    // 判断当前钱包
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (!currentWalletM || currentWalletM.walletType != WalletTypeETH) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_switch_to_eth_wallet")];
        return;
    }
    
    // 判断NEO钱包的asset
    Token *asset = [kAppD.tabbarC.walletsVC getETHAsset:tokenName];
    if (!asset) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"current_wallet_have_not"),tokenName]];
        return;
    }
    
    // 检查平台地址
    NSString *serverAddress = [ETHWalletManage shareInstance].ethMainAddress;
    if ([serverAddress isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"server_address_is_empty")];
        return;
    }
    
    if (![NewOrderETHTransferUtil haveETHAssetNum]) {
        [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@ %@",kLang(@"wallet_have_not_balance_of"),@"ETH"]];
        return;
    }
    
    [NewOrderETHTransferUtil showETHTransferConfirmView:asset amountStr:amountStr to_address:serverAddress successB:successB];
}

+ (BOOL)haveETHAssetNum {
    __block BOOL haveEthAssetNum = NO;
    NSArray *sourceArr = [kAppD.tabbarC.walletsVC getETHSource];
    [sourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Token *model = obj;
        if ([model.tokenInfo.symbol isEqualToString:@"ETH"]) {
            NSString *ethNum = [model getTokenNum];
            if ([ethNum doubleValue] > 0) {
                haveEthAssetNum = YES;
            }
            *stop = YES;
        }
    }];
    return haveEthAssetNum;
}

+ (void)showETHTransferConfirmView:(Token *)token amountStr:(NSString *)amountStr to_address:(NSString *)to_address successB:(ETHTransferSuccessBlock)successB {
//    NSString *decimals = ETH_Decimals;
//    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
//    NSInteger gasLimit = 60000;
//    NSInteger gasPrice = 6;
//    NSNumber *ethFloatNum = @(gasPrice*gasLimit*[decimalsNum doubleValue]);
//
//    __block WalletCommonModel *transferETHM = nil;
//    // 判断是否有eth钱包
//    if ([TrustWalletManage.sharedInstance isHavaWallet]) {
//        // 判断是否有足够余额的eth钱包
//        NSNumber *enoughBalanceNum = @([ethFloatNum doubleValue]+[amountStr doubleValue]);
//        [[WalletCommonModel getAllWalletModel] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            WalletCommonModel *model = obj;
//            if (model.walletType==WalletTypeETH) {
//                if ([model.balance doubleValue] >= [enoughBalanceNum doubleValue]) {
//                    transferETHM = model;
//                    *stop = YES;
//                }
//            }
//        }];
//
//        if (transferETHM == nil) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"no_eth_wallet_of_enough_balance")];
//            return;
//        }
//    } else {
//        [kAppD.window makeToastDisappearWithText:kLang(@"no_eth_wallet")];
//        return;
//    }
//
//    NSString *gasCostETH = [[NSString stringWithFormat:@"%@",ethFloatNum] removeFloatAllZero];
//    NSString *fromAddress = transferETHM.address;
//    NSString *name = transferETHM.name;
//    NSString *toAddress = to_address;
//    NSString *amount = [NSString stringWithFormat:@"%@ ETH",amountStr];
//    NSString *gasfee = [NSString stringWithFormat:@"%@ ETH",gasCostETH];
//    ETHTransferConfirmView *view = [ETHTransferConfirmView getInstance];
//    [view configWithName:name sendFrom:fromAddress sendTo:toAddress amount:amount gasfee:gasfee];
//    kWeakSelf(self);
//    view.confirmBlock = ^{
//        [weakself sendTransfer:token amountStr:amountStr to_address:to_address gasLimit:gasLimit gasPrice:gasPrice successB:successB];
//    };
//    [view show];
    
    
    NSString *address = to_address;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",amountStr,token.tokenInfo.symbol];
    NSString *decimals = ETH_Decimals;
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSInteger gasLimit = 60000;
    NSInteger gasPrice = 6;
    NSNumber *ethFloatNum = @(gasPrice*gasLimit*[decimalsNum doubleValue]);
    NSString *gasCostETH = [[NSString stringWithFormat:@"%@",ethFloatNum] removeFloatAllZero];
    NSString *gasfee = [NSString stringWithFormat:@"%@ ETH",gasCostETH];
    ETHTransferConfirmView *view = [ETHTransferConfirmView getInstance];
    [view configWithAddress:address amount:amount gasfee:gasfee];
    view.confirmBlock = ^{
        [NewOrderETHTransferUtil sendTransfer:token amountStr:amountStr to_address:to_address gasLimit:gasLimit gasPrice:gasPrice successB:successB];
    };
    [view show];
}

+ (void)sendTransfer:(Token *)token amountStr:(NSString *)amountStr to_address:(NSString *)to_address gasLimit:(NSInteger)gasLimit gasPrice:(NSInteger)gasPrice successB:(ETHTransferSuccessBlock)successB {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSString *fromAddress = currentWalletM.address;
    NSString *contractAddress = token.tokenInfo.address;
    NSString *toAddress = to_address;
    NSString *name = token.tokenInfo.name;
    NSString *symbol = token.tokenInfo.symbol;
    NSString *amount = amountStr;
//    NSInteger gasLimit = [_gasLimitLab.text integerValue];
//    NSInteger gasPrice = _gasSlider.value;
    NSInteger decimals = [token.tokenInfo.decimals integerValue];
    NSString *value = @"";
    BOOL isCoin = [token.tokenInfo.symbol isEqualToString:@"ETH"]?YES:NO;
//    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    [TrustWalletManage.sharedInstance sendFromAddress:fromAddress contractAddress:contractAddress toAddress:toAddress name:name symbol:symbol amount:amount gasLimit:gasLimit gasPrice:gasPrice decimals:decimals value:value isCoin:isCoin :^(BOOL success, NSString *txId) {
        [kAppD.window hideToast];
        if (success) {
            [kAppD.window makeToastDisappearWithText:kLang(@"send_success")];
//            NSString *blockChain = @"ETH";
//            [ReportUtil requestWalletReportWalletRransferWithAddressFrom:fromAddress addressTo:toAddress blockChain:blockChain symbol:symbol amount:amount txid:txId?:@""]; // 上报钱包转账
            if (successB) {
                successB(fromAddress, txId);
            }
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"send_fail")];
        }
    }];
}

@end
