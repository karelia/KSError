//
//  NSError+KSWErrorAdditions.h
//  KSWError
//
//  Created by Mike on 25/05/2015.
//  Copyright (c) 2015 Karelia. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSError (KSWErrorAdditions)

/**
 Queries if the receiver or an underlying error is of a specific domain and code.
 
 @return `YES` if the receiver or an underlying error that matches `domain` and `code`.
 */
- (BOOL)ks_isErrorOfDomain:(NSString *)domain code:(NSInteger)code;

/**
 Queries if the receiver or an underlying error is of a specific domain and code.
 
 Useful for locating an underlying error for pulling further information out it.
 
 @return The receiver or an underlying error that matches `domain` and `code`. `nil` if no match is found.
 */
- (NSError *)ks_errorOfDomain:(NSString *)domain code:(NSInteger)code;

/**
 Searches for an error (from the receiver and its underlying error(s)) matching `domain`.
 */
- (NSError *)ks_errorOfDomain:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END
