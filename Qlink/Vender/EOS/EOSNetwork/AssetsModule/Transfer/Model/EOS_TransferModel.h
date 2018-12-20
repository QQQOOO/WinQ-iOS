//
//  TransferModel.h
//  pocketEOS
//
//  Created by oraclechain on 29/03/2018.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOS_TransferModel : NSObject
@property(nonatomic, copy) NSString *account_name;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *coin;
@property(nonatomic , copy) NSString *memo;
@end
