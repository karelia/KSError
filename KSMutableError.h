//
//  KSMutableError.h
//  Sandvox
//
//  Created by Mike on 26/03/2011.
//  Copyright 2011 Karelia Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KSMutableError : NSError
{
  @private
    NSMutableDictionary *_mutableUserInfo;
}

- (id)objectForUserInfoKey:(id)key; // slightly faster than -userInfo
- (void)setObject:(id)object forUserInfoKey:(id)key;

// Note you can only mutate user info; domain & code are fixed


#pragma mark Convenience
@property(nonatomic, copy) NSString *localizedDescription;


@end
