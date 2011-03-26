//
//  KSMutableError.m
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import "KSMutableError.h"


@implementation KSMutableError

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict;
{
    self = [super initWithDomain:domain code:code userInfo:nil];
    _mutableUserInfo = [dict mutableCopy];
    return self;
}

- (NSDictionary *)userInfo;
{
    return [[_mutableUserInfo copy] autorelease];
}

- (id)objectForUserInfoKey:(id)key; // slightly faster than -userInfo
{
    return [_mutableUserInfo objectForKey:key];
}

- (void)setObject:(id)object forUserInfoKey:(id)key;
{
    [_mutableUserInfo setObject:object forKey:key];
}

@end
