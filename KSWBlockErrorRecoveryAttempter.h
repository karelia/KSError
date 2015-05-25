//
//  KSWBlockErrorRecoveryAttempter.h
//  KSWError
//
//  Created by Mike on 25/05/2015.
//  Copyright (c) 2015 Karelia. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface KSWBlockErrorRecoveryAttempter : NSObject

- (id)initWithAttempterBlock:(BOOL(^)(NSError *error, NSUInteger optionIndex))block;

@end

NS_ASSUME_NONNULL_END
