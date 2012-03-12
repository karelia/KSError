//
//  KSError.h
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011-2012 Karelia Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSError (KSError)

// Returns YES if the receiver or one of its underlying erros matches the domain and code
- (BOOL)ks_isErrorOfDomain:(NSString *)domain code:(NSInteger)code;

// Lower-level version of the above so you can pick out the specific error and work with it
- (NSError *)ks_errorOfDomain:(NSString *)domain code:(NSInteger)code;

@end


#pragma mark -


@interface KSError : NSError    // subclass so don't have to prefix method names

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ...;

+ (id)errorWithDomain:(NSString *)errorDomain
                 code:(NSInteger)errorCode 
 localizedDescription:(NSString *)description
localizedRecoverySuggestion:(NSString *)recoverySuggestion
      underlyingError:(NSError *)underlyingError;

+ (id)validationErrorWithCode:(NSInteger)code
                       object:(id)object
                          key:(NSString *)key
                        value:(id)value
   localizedDescriptionFormat:(NSString *)format, ...;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code persistentStore:(NSPersistentStore *)store;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL;

@end


#pragma mark -


@interface KSMutableError : KSError
{
  @private
    NSMutableDictionary *_mutableUserInfo;
}

+ (id)errorWithUnderlyingError:(NSError *)error;    // handy to recycle existing error's domain and code, ready for further info

- (id)objectForUserInfoKey:(NSString *)key; // slightly faster than -userInfo
- (void)setObject:(id)object forUserInfoKey:(NSString *)key;

// Note you can only mutate user info; domain & code are fixed


#pragma mark Convenience

@property(nonatomic, copy) NSString *localizedDescription;
- (void)setLocalizedDescriptionWithFormat:(NSString *)format, ...;

- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ...;

// Recovery attempter should implement the NSErrorRecoveryAttempting informal protocol
- (void)setLocalizedRecoveryOptions:(NSArray *)options attempter:(NSObject *)recoveryAttempter;

#if NS_BLOCKS_AVAILABLE

- (void)addLocalizedRecoveryOption:(NSString *)option attempterBlock:(BOOL(^)())attempter;

// DON'T reference the error in your attempter block as that leads to a retain cycle. Instead, work with the error object as passed to the block
- (void)setLocalizedRecoveryOptions:(NSArray *)options
                     attempterBlock:(BOOL(^)(NSError *error, NSUInteger recoveryOptionIndex))attempter;

#endif

@end
