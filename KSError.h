//
//  KSError.h
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KSError : NSError    // subclass so don't have to prefix method names

+ (id)errorWithDomain:(NSString *)anErrorDomain
                 code:(NSInteger)anErrorCode
 localizedDescription:(NSString *)aLocalizedDescription;

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


@end
