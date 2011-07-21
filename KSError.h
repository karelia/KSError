//
//  KSError.h
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


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

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL;

@end


#pragma mark -


@interface KSMutableError : KSError
{
  @private
    NSMutableDictionary *_mutableUserInfo;
}

- (id)objectForUserInfoKey:(NSString *)key; // slightly faster than -userInfo
- (void)setObject:(id)object forUserInfoKey:(NSString *)key;

// Note you can only mutate user info; domain & code are fixed


#pragma mark Convenience

@property(nonatomic, copy) NSString *localizedDescription;
- (void)setLocalizedDescriptionWithFormat:(NSString *)format, ...;

- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ...;


@end
