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


@interface NSError (KSError)

/**
 Queries if the receiver or an underlying error is of a specific domain and code.
 
 @return `YES` if the receiver or an underlying error that matches `domain` and `code`.
 */
- (BOOL)ks_isErrorOfDomain:(NSString *)domain code:(NSInteger)code __attribute((nonnull(1)));

/**
 Queries if the receiver or an underlying error is of a specific domain and code.
 
 Useful for locating an underlying error for pulling further information out it.
 
 @return The receiver or an underlying error that matches `domain` and `code`. `nil` if no match is found.
 */
- (NSError *)ks_errorOfDomain:(NSString *)domain code:(NSInteger)code __attribute((nonnull(1)));

/**
 Searches for an error (from the receiver and its underlying error(s)) matching `domain`.
 */
- (NSError *)ks_errorOfDomain:(NSString *)domain __attribute((nonnull));

@end


#pragma mark -


@interface KSError : NSError    // subclass so don't have to prefix method names

/**
 Creates and initializes a `KSError` object for a given domain and code with a given localized description.
 
 @param domain The error domain—this can be one of the predefined `NSError` domains, or an arbitrary string describing a custom domain. `domain` must not be `nil`.
 @param code The error code for the error.
 @param description The localized description of the error.
 @return A `KSError` object for `domain` with the specified error `code` and `-localizedDescription` of `description`.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description __attribute((nonnull(1)));

/**
 Creates and initializes a `KSError` object for a given domain and code with a given localized description.
 
 @param domain The error domain—this can be one of the predefined `NSError` domains, or an arbitrary string describing a custom domain. `domain` must not be `nil`.
 @param code The error code for the error.
 @param format The localized description of the error in printf format.
 @return A `KSError` object for `domain` with the specified error `code` and `-localizedDescription` built from `format, ...`.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(3, 4) __attribute((nonnull(1)));

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
 Creates and initializes a `KSError` object for a validation error.
 
 Most validation error codes are found in `CoreDataErrors.h`, but there's a few
 in `FoundationErrors.h` too.
 
 @param code A Cocoa error code, generally between `NSValidationErrorMinimum` and `NSValidationErrorMaximum`.
 @param object The object being validated.
 @param key The key (or key path) being validated.
 @param value The value that was found to be invalid.
 @param format The localized description of the error in printf format.
 @return A `KSError` object for `NSCocoaErrorDomain` with the specified error `code` and `-userInfo` dictionary built from `object`, `key`, and `format, ...`.
 */
+ (instancetype)validationErrorWithCode:(NSInteger)code
                       object:(id)object
                          key:(NSString *)key
                        value:(id)value
   localizedDescriptionFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(5, 6);

/**
 Creates and initializes a `KSError` object pertaining to a given persistent store.
 
 @param domain The error domain—this can be one of the predefined `NSError` domains, or an arbitrary string describing a custom domain. `domain` must not be `nil`.
 @param code The error code for the error.
 @param store The persistent store affected by the error.
 @return A `KSError` object for `domain` with the specified error `code` and `-userInfo` filled in to include `store`.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code persistentStore:(NSPersistentStore *)store __attribute((nonnull(1,3)));

/**
 Creates and initializes a `KSError` object pertaining to a given URL.
 
 URL error codes generally come from `NSURLError.h` or `FoundationErrors.h`.
 
 @param domain The error domain, generally `NSCocoaErrorDomain` or `NSURLErrorDomain`. `domain` must not be `nil`.
 @param code The error code for the error.
 @param URL The URL involved in the error.
 @return A `KSError` object for `domain` with the specified error `code` and `-userInfo` filled in to include `store`.
 */
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL __attribute((nonnull(1)));

@end


#pragma mark -


@interface KSMutableError : KSError
{
  @private
    NSMutableDictionary *_mutableUserInfo;
}

/**
 Creates and initializes a `KSError` object based off an existing error.
 
 Since `NSError` objects are immutable, this is a good starting point for
 creating a new error that adds to — or customizes — an existing error.
 
 @param error The original error that will become the underlying error of the new error. Must not be `nil`.
 @return A `KSError` object matching `error` with the important difference that `error` is now the underlying error.
 */
+ (instancetype)errorWithUnderlyingError:(NSError *)error __attribute((nonnull(1)));

/**
 Retrieves the value corresponding to `key` in the receiver's `-userInfo` dictionary.
 
 Slightly faster than calling `-userInfo` as avoids copying the internal mutable
 dictionary.
 
 @param key The key to look up. Must not be `nil`.
 @result The object corresponding to `key` in the receiver's `-userInfo`.
 */
- (id)objectForUserInfoKey:(NSString *)key __attribute((nonnull(1)));

/**
 Adds a given key-value pair to the reciever's `-userInfo` dictionary.
 
 @param object An object to add to `-userInfo`. If `nil`, any existing value for `key` is removed.
 @param key The key in `-userInfo` to be adjusted. May not be `nil`.
 */
- (void)setObject:(id)object forUserInfoKey:(NSString *)key __attribute((nonnull(2)));

// Note you can only mutate user info; domain & code are fixed


#pragma mark Convenience

/**
 Provides a setter method for storing localized description.
 */
@property(nonatomic, copy) NSString *localizedDescription;

/**
 Sets the localized description built from a format string.
 
 @param format The localized description of the error in printf format.
 */
- (void)setLocalizedDescriptionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 Sets the localized recovery suggestion built from a format string.
 
 @param format The localized recovery suggestion of the error in printf format.
 */
- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 Sets the recovery options and attempter in one fell swoop.
 
 @param options An array of localized strings, one for each recovery option. Must contain at least one object.
 @param recoveryAttempter An object that implements the `NSErrorRecoveryAttempting` informal protocol. Must not be `nil`.
 */
- (void)setLocalizedRecoveryOptions:(NSArray *)options attempter:(NSObject *)recoveryAttempter __attribute((nonnull(1,2)));

#if NS_BLOCKS_AVAILABLE

/**
 Adds a recovery option with corresponding block to perform it.
 
 Your recovery block should return a `BOOL` to indicate if recovery was
 successful. Avoid strongly referencing the receiver within the block as that
 will most likely create a retain cycle.
 
 @param option The localized recovery option. Must not be `nil`.
 @param attempter A block that attempts recovery from the error. May be `nil` to handle things like "Cancel" buttons.
 */
- (void)addLocalizedRecoveryOption:(NSString *)option attempterBlock:(BOOL(^)())attempter __attribute((nonnull(1)));

/**
 Sets the recovery options with a corresponding block to perform them.
 
 Your recovery block should return a `BOOL` to indicate if recovery was
 successful.
 
 Avoid strongly referencing the receiver within the block as that
 will most likely create a retain cycle. Instead, use `error` that is passed
 into the block.
 
 @param options An array of localized strings, one for each recovery option. Must contain at least one object.
 @param attempter A block that attempts recovery from the error. Must not be `nil`.
 */
- (void)setLocalizedRecoveryOptions:(NSArray *)options
                     attempterBlock:(BOOL(^)(NSError *error, NSUInteger recoveryOptionIndex))attempter __attribute((nonnull(1,2)));

#endif

@end
