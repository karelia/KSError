//
//  KSError.m
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright © 2011 Karelia Software
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "KSError.h"

@implementation NSError (KSError)

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


#pragma mark -


@implementation KSError

+ (instancetype)errorWithDomain:(NSString *)anErrorDomain code:(NSInteger)anErrorCode localizedDescription:(NSString *)aLocalizedDescription
{
	return [self errorWithDomain:anErrorDomain
                            code:anErrorCode
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:    // handle nil description to give empty dictionary
                                  aLocalizedDescription,
                                  NSLocalizedDescriptionKey,
                                  nil]];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ...;
{
	va_list argList;
	va_start(argList, format);
	NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	
	KSError *result = [self errorWithDomain:domain code:code localizedDescription:formatted];
    
#if !__has_feature(objc_arc)
    [formatted release];
#endif
	
    return result;
}

+ (instancetype)errorWithDomain:(NSString *)errorDomain
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

+ (instancetype)validationErrorWithCode:(NSInteger)code
                       object:(id)object
                          key:(NSString *)key
                        value:(id)value
   localizedDescriptionFormat:(NSString *)format, ...;
{
    NSString *formatted = nil;
    if (format)
    {
        va_list argList;
        va_start(argList, format);
        formatted = [[NSString alloc] initWithFormat:format arguments:argList];
        va_end(argList);
    }
	
	KSMutableError *result = [KSMutableError errorWithDomain:NSCocoaErrorDomain
                                                        code:code
                                        localizedDescription:formatted];

#if !__has_feature(objc_arc)
    [formatted release];
#endif
    
    [result setObject:object forUserInfoKey:NSValidationObjectErrorKey];
    [result setObject:key forUserInfoKey:NSValidationKeyErrorKey];
    [result setObject:value forUserInfoKey:NSValidationValueErrorKey];
    
    return result;
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code persistentStore:(NSPersistentStore *)store;
{
    NSParameterAssert(store);
    
    KSMutableError *result = [KSMutableError errorWithDomain:domain code:code URL:[store URL]];
    [result setObject:[NSArray arrayWithObject:store] forUserInfoKey:NSAffectedStoresErrorKey];
    return result;
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL;
{
    KSMutableError *result = [KSMutableError errorWithDomain:domain code:code userInfo:nil];
    
    [result setObject:URL forUserInfoKey:NSURLErrorKey];
    
    if ([URL isFileURL]) [result setObject:[URL path] forUserInfoKey:NSFilePathErrorKey];
    
    if ([domain isEqualToString:NSURLErrorDomain])
    {
#if defined MAC_OS_X_VERSION_10_6 && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
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


@interface KSBlockErrorRecoveryAttempter : NSObject
{
  @private
    BOOL    (^_block)(NSError *error, NSUInteger optionIndex);
}

- (id)initWithAttempterBlock:(BOOL(^)(NSError *error, NSUInteger optionIndex))block;

@end


@implementation KSMutableError

+ (instancetype)errorWithUnderlyingError:(NSError *)error;
{
    KSMutableError *result = [self errorWithDomain:[error domain] code:[error code] userInfo:[error userInfo]];
    [result setObject:error forUserInfoKey:NSUnderlyingErrorKey];
    return result;
}

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict;
{
    self = [super initWithDomain:domain code:code userInfo:nil];
    _mutableUserInfo = [dict mutableCopy];
    return self;
}

- (NSDictionary *)userInfo;
{
#if __has_feature(objc_arc)
	return [_mutableUserInfo copy];
#else
    return [[_mutableUserInfo copy] autorelease];
#endif
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
    
#if !__has_feature(objc_arc)
    [formatted release];
#endif
}

- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ...;
{
    if (!format)
    {
        [self setObject:nil forUserInfoKey:NSLocalizedRecoverySuggestionErrorKey];
        return;
    }
    
    va_list argList;
	va_start(argList, format);
	NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	
	[self setObject:formatted forUserInfoKey:NSLocalizedRecoverySuggestionErrorKey];
    
#if !__has_feature(objc_arc)
    [formatted release];
#endif
}

- (void)setLocalizedRecoveryOptions:(NSArray *)options attempter:(NSObject *)recoveryAttempter;
{
    [self setObject:options forUserInfoKey:NSLocalizedRecoveryOptionsErrorKey];
    [self setObject:recoveryAttempter forUserInfoKey:NSRecoveryAttempterErrorKey];
}

#if NS_BLOCKS_AVAILABLE

- (void)addLocalizedRecoveryOption:(NSString *)option attempterBlock:(BOOL(^)())attempterBlock;
{
    NSArray *options = [self localizedRecoveryOptions];
    NSUInteger optionIndex = [options count];
    options = (options ? [options arrayByAddingObject:option] : [NSArray arrayWithObject:option]);
    
    NSObject *attempter = [self recoveryAttempter];
    
    [self setLocalizedRecoveryOptions:options attempterBlock:^BOOL(NSError *error, NSUInteger recoveryOptionIndex) {
        
        if (recoveryOptionIndex == optionIndex)
        {
            return (attempterBlock ? attempterBlock() : NO);
        }
        else
        {
            return [attempter attemptRecoveryFromError:error optionIndex:recoveryOptionIndex];
        }
    }];
}

- (void)setLocalizedRecoveryOptions:(NSArray *)options
                     attempterBlock:(BOOL(^)(NSError *error, NSUInteger recoveryOptionIndex))block;
{
    KSBlockErrorRecoveryAttempter *attempter = [[KSBlockErrorRecoveryAttempter alloc] initWithAttempterBlock:block];
    [self setLocalizedRecoveryOptions:options attempter:attempter];
	
#if !__has_feature(objc_arc)
    [attempter release];
#endif
}

#endif

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    // Default probably does [self retain]. Must override because we're mutable
    return [[NSError alloc] initWithDomain:[self domain] code:[self code] userInfo:[self userInfo]];
}

@end


@implementation KSBlockErrorRecoveryAttempter

- (id)initWithAttempterBlock:(BOOL(^)(NSError *error, NSUInteger optionIndex))block;
{
    if (self = [self init])
    {
        _block = [block copy];
    }
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_block release];
    [super dealloc];
}
#endif

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex;
{
    return _block(error, recoveryOptionIndex);
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo;
{
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
