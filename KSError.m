//
//  KSError.m
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import "KSError.h"

@implementation NSError (KSError)

- (BOOL)ks_isErrorOfDomain:(NSString *)domain code:(NSInteger)code;
{
    if ([[self domain] isEqualToString:domain] && [self code] == code)
    {
        return YES;
    }
    
    // Carry on down to underlying errors then
    return [[[self userInfo] objectForKey:NSUnderlyingErrorKey] ks_isErrorOfDomain:domain code:code];
}

@end


#pragma mark -


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

+ (id)validationErrorWithCode:(NSInteger)code
                       object:(id)object
                          key:(NSString *)key
                        value:(id)value
   localizedDescriptionFormat:(NSString *)format, ...;
{
    va_list argList;
	va_start(argList, format);
	NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	
	KSMutableError *result = [KSMutableError errorWithDomain:NSCocoaErrorDomain
                                                        code:code
                                        localizedDescription:formatted];
    [formatted release];
    
    [result setObject:object forUserInfoKey:NSValidationObjectErrorKey];
    [result setObject:key forUserInfoKey:NSValidationKeyErrorKey];
    [result setObject:value forUserInfoKey:NSValidationValueErrorKey];
    
    return result;
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code persistentStore:(NSPersistentStore *)store;
{
    NSParameterAssert(store);
    
    KSMutableError *result = [KSMutableError errorWithDomain:domain code:code URL:[store URL]];
    [result setObject:[NSArray arrayWithObject:store] forUserInfoKey:NSAffectedStoresErrorKey];
    return result;
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL;
{
    KSMutableError *result = [KSMutableError errorWithDomain:domain code:code userInfo:nil];
    
    [result setObject:URL forUserInfoKey:NSURLErrorKey];
    
    if ([URL isFileURL]) [result setObject:[URL path] forUserInfoKey:NSFilePathErrorKey];
    
    if ([domain isEqualToString:NSURLErrorDomain])
    {
#if defined MAC_OS_X_VERSION_10_6 && MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_6
        [result setObject:URL forUserInfoKey:NSURLErrorFailingURLErrorKey];
        [result setObject:[URL absoluteString] forUserInfoKey:NSURLErrorFailingURLStringErrorKey];
#else
        [result setObject:[URL absoluteString] forUserInfoKey:NSErrorFailingURLStringKey];
#endif
    }
    
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

- (void)setLocalizedDescriptionWithFormat:(NSString *)format, ...;
{
    va_list argList;
	va_start(argList, format);
	NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	
	[self setLocalizedDescription:formatted];
    
    [formatted release];
}

- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ...;
{
    va_list argList;
	va_start(argList, format);
	NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	
	[self setObject:formatted forUserInfoKey:NSLocalizedRecoverySuggestionErrorKey];
    
    [formatted release];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    // Default probably does [self retain]. Must override because we're mutable
    return [[NSError alloc] initWithDomain:[self domain] code:[self code] userInfo:[self userInfo]];
}

@end
