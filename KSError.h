//
//  KSError.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KSError : NSError    // subclass so don't have to prefix method names

/**
 Creates and initializes a `KSError` object for a given domain and code with a given localized description, recovery suggestion and underlying error.
 
 @param domain The error domain—this can be one of the predefined `NSError` domains, or an arbitrary string describing a custom domain. `domain` must not be `nil`.
 @param code The error code for the error.
 @param description The localized description of the error.
 @param recoverySuggestion The localized recovery suggestion of the error. May be `nil`.
 @param underlyingError The underlying error if there is one. May be `nil`.
 @return A `KSError` object for `domain` with the specified error `code` and `-userInfo` dictionary filled in from `description`, `recoverySuggestion`, and `underlyingError`.
 */
+ (instancetype)errorWithDomain:(NSString *)domain
                 code:(NSInteger)code
 localizedDescription:(NSString *)description
localizedRecoverySuggestion:(NSString *)recoverySuggestion
      underlyingError:(NSError *)underlyingError __attribute((nonnull(1)));

/**
 Creates and initializes a `KSError` object pertaining to a given persistent store.
 
 @param domain The error domain—this can be one of the predefined `NSError` domains, or an arbitrary string describing a custom domain. `domain` must not be `nil`.
 @param code The error code for the error.
 @param store The persistent store affected by the error.
 @return A `KSError` object for `domain` with the specified error `code` and `-userInfo` filled in to include `store`.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code persistentStore:(NSPersistentStore *)store __attribute((nonnull(1,3)));

@end
