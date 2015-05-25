//
//  NSError+KSWErrorAdditions.m
//  KSWError
//
//  Created by Mike on 25/05/2015.
//  Copyright (c) 2015 Karelia. All rights reserved.
//

#import "NSError+KSWErrorAdditions.h"


@implementation NSError (KSWErrorAdditions)

- (BOOL)ks_isErrorOfDomain:(NSString *)domain code:(NSInteger)code;
{
    return ([self ks_errorOfDomain:domain code:code] != nil);
}

- (NSError *)ks_errorOfDomain:(NSString *)domain code:(NSInteger)code;
{
    if ([[self domain] isEqualToString:domain] && [self code] == code)
    {
        return self;
    }
    
    // Carry on down to underlying errors then
    return [[[self userInfo] objectForKey:NSUnderlyingErrorKey] ks_errorOfDomain:domain code:code];
}

- (NSError *)ks_errorOfDomain:(NSString *)domain {
    if ([self.domain isEqualToString:domain]) return self;
    return [[self.userInfo objectForKey:NSUnderlyingErrorKey] ks_errorOfDomain:domain];
}

@end
