//
//  KSError.m
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import "KSError.h"


@implementation KSError

@end


#pragma mark -


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

- (id)objectForUserInfoKey:(NSString *)key; // slightly faster than -userInfo
{
    return [_mutableUserInfo objectForKey:key];
}

- (void)setObject:(id)object forUserInfoKey:(NSString *)key;
{
    if (_mutableUserInfo)
    {
        [_mutableUserInfo setValue:object forKey:key];  // handle nil
    }
    else
    {
        _mutableUserInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:object, key, nil];
    }
}

#pragma mark Convenience

@dynamic localizedDescription;
- (void)setLocalizedDescription:(NSString *)description;
{
    [self setObject:description forUserInfoKey:NSLocalizedDescriptionKey];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    // Default probably does [self retain]. Must override because we're mutable
    return [[NSError alloc] initWithDomain:[self domain] code:[self code] userInfo:[self userInfo]];
}

@end
