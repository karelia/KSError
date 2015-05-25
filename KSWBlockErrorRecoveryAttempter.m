//
//  KSWBlockErrorRecoveryAttempter.m
//  KSWError
//
//  Created by Mike on 25/05/2015.
//  Copyright (c) 2015 Karelia. All rights reserved.
//

#import "KSWBlockErrorRecoveryAttempter.h"

@implementation KSWBlockErrorRecoveryAttempter {
    BOOL    (^_block)(NSError *error, NSUInteger optionIndex);
}

- (id)initWithAttempterBlock:(BOOL(^)(NSError *error, NSUInteger optionIndex))block {
    if (self = [self init]) {
        _block = [block copy];
    }
    return self;
}

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex {
    return _block(error, recoveryOptionIndex);
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo {
    
    BOOL result = [self attemptRecoveryFromError:error optionIndex:recoveryOptionIndex];
    
    if (delegate)
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [delegate methodSignatureForSelector:didRecoverSelector]];
        
        [invocation setTarget:delegate];
        [invocation setSelector:didRecoverSelector];
        [invocation setArgument:&result atIndex:2];
        [invocation setArgument:&contextInfo atIndex:3];
    }
}

@end
