//
//  KSWErrorBuilder.m
//  KSWError
//
//  Created by Mike on 25/05/2015.
//  Copyright (c) 2015 Karelia. All rights reserved.
//

#import "KSWErrorBuilder.h"

#import "KSWBlockErrorRecoveryAttempter.h"


@implementation KSWErrorBuilder

+ (instancetype)builderWithUnderlyingError:(NSError *)error;
{
    KSWErrorBuilder *result = [[self alloc] initWithDomain:error.domain code:error.code userInfo:error.userInfo];
    [result.userInfo setObject:[error copy] forKey:NSUnderlyingErrorKey];
    return result;
}

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict {
    if (self = [super init]) {
        _domain = [domain copy];
        _code = code;
        _userInfo = [[NSMutableDictionary alloc] initWithDictionary:dict];
    }
    return self;
}

#pragma mark Creating the Error

- (NSError * __nonnull)error {
    return [NSError errorWithDomain:self.domain code:self.code userInfo:[self.userInfo copy]];
}

#pragma mark Convenience

- (NSString * __nonnull)localizedDescription {
    return self.userInfo[NSLocalizedDescriptionKey];
}
- (void)setLocalizedDescription:(NSString *)description;
{
    [self.userInfo setObject:description forKey:NSLocalizedDescriptionKey];
}

- (void)setLocalizedDescriptionWithFormat:(NSString *)format, ...;
{
    va_list argList;
    va_start(argList, format);
    NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    [self setLocalizedDescription:formatted];
    
}

- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ...;
{
    if (!format)
    {
        [self.userInfo setObject:nil forKey:NSLocalizedRecoverySuggestionErrorKey];
        return;
    }
    
    va_list argList;
    va_start(argList, format);
    NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    [self.userInfo setObject:formatted forKey:NSLocalizedRecoverySuggestionErrorKey];
    
}

- (void)setLocalizedRecoveryOptions:(NSArray *)options attempter:(NSObject *)recoveryAttempter;
{
    [self.userInfo setObject:options forKey:NSLocalizedRecoveryOptionsErrorKey];
    [self.userInfo setObject:recoveryAttempter forKey:NSRecoveryAttempterErrorKey];
}

- (void)addLocalizedRecoveryOption:(NSString *)option attempterBlock:(BOOL(^)())attempterBlock;
{
    NSArray *options = self.userInfo[NSLocalizedRecoveryOptionsErrorKey];
    NSUInteger optionIndex = [options count];
    options = (options ? [options arrayByAddingObject:option] : [NSArray arrayWithObject:option]);
    
    NSObject *attempter = self.userInfo[NSRecoveryAttempterErrorKey];
    
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
    KSWBlockErrorRecoveryAttempter *attempter = [[KSWBlockErrorRecoveryAttempter alloc] initWithAttempterBlock:block];
    [self setLocalizedRecoveryOptions:options attempter:attempter];
    
}

#pragma mark URL Errors

+ (instancetype)errorBuilderWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL {
    
    KSWErrorBuilder *result = [[self alloc] initWithDomain:domain code:code userInfo:nil];
    
    [result.userInfo setObject:URL forKey:NSURLErrorKey];
    
    if ([URL isFileURL]) [result.userInfo setObject:[URL path] forKey:NSFilePathErrorKey];
    
    if ([domain isEqualToString:NSURLErrorDomain])
    {
        [result.userInfo setObject:URL forKey:NSURLErrorFailingURLErrorKey];
        [result.userInfo setObject:[URL absoluteString] forKey:NSURLErrorFailingURLStringErrorKey];
    }
    
    return result;
}

#pragma mark Validation Errors

+ (instancetype)validationErrorBuilderWithCode:(NSInteger)code object:(id __nonnull)object key:(NSString * __nonnull)key value:(id __nonnull)value {
    
    KSWErrorBuilder *result = [[self alloc] initWithDomain:NSCocoaErrorDomain
                                                      code:code
                                                  userInfo:nil];
    
    [result.userInfo setObject:object forKey:NSValidationObjectErrorKey];
    [result.userInfo setObject:key forKey:NSValidationKeyErrorKey];
    [result.userInfo setObject:value forKey:NSValidationValueErrorKey];
    
    return result;
}

#pragma mark Quickly Constructing an Error

+ (NSError *)errorWithDomain:(NSString *)anErrorDomain code:(NSInteger)anErrorCode localizedDescription:(NSString *)aLocalizedDescription
{
    return [NSError errorWithDomain:anErrorDomain
                               code:anErrorCode
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:    // handle nil description to give empty dictionary
                                     aLocalizedDescription,
                                     NSLocalizedDescriptionKey,
                                     nil]];
}

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ...;
{
    va_list argList;
    va_start(argList, format);
    NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    NSError *result = [self errorWithDomain:domain code:code localizedDescription:formatted];
    
    return result;
}

@end
