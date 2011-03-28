//
//  KSError.m
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import "KSError.h"


@implementation KSError

+ (id)errorWithDomain:(NSString *)anErrorDomain code:(NSInteger)anErrorCode localizedDescription:(NSString *)aLocalizedDescription
{
	return [self errorWithDomain:anErrorDomain
                            code:anErrorCode
                        userInfo:[NSDictionary
                                  dictionaryWithObject:aLocalizedDescription
                                  forKey:NSLocalizedDescriptionKey]];
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ...;
{
	va_list argList;
	va_start(argList, format);
	NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	
	KSError *result = [self errorWithDomain:domain code:code localizedDescription:formatted];
    
    [formatted release];
    return result;
}

+ (id)errorWithDomain:(NSString *)errorDomain
                 code:(NSInteger)errorCode 
 localizedDescription:(NSString *)description
localizedRecoverySuggestion:(NSString *)recoverySuggestion
      underlyingError:(NSError *)underlyingError
{
    KSMutableError *result = [KSMutableError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    
    [result setObject:description forUserInfoKey:NSLocalizedDescriptionKey];
    [result setObject:recoverySuggestion forUserInfoKey:NSLocalizedRecoverySuggestionErrorKey];
    [result setObject:underlyingError forUserInfoKey:NSUnderlyingErrorKey];
    
    return result;
}

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
