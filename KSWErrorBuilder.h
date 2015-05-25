//
//  KSWErrorBuilder.h
//  KSWError
//
//  Created by Mike on 25/05/2015.
//  Copyright (c) 2015 Karelia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


NS_ASSUME_NONNULL_BEGIN

@interface KSWErrorBuilder : NSObject

#pragma mark Creating an Error Builder

/**
 Creates and initializes a `KSWErrorBuilder` object based off an existing error.
 
 Since `NSError` objects are immutable, this is a good starting point for creating a new error that
 adds to — or customizes — an existing error.
 
 @param error The original error that will become the underlying error of the new error.
 
 @return A `KSWErrorBuilder` object matching `error` with the important difference that `error` is
 now the underlying error.
 */
+ (instancetype)builderWithUnderlyingError:(NSError *)error;

/**
 @param If you pass `nil` the builder will automatically create an empty user info dictionary for
 you.
 */
- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(nullable NSDictionary *)dict NS_DESIGNATED_INITIALIZER;


#pragma mark Core Error Properties

@property(nonatomic, readonly, copy) NSString *domain;

@property(nonatomic, readonly) NSInteger code;

/**
 Clients can directly mutate `userInfo`, or use the convenience methods when suits.
 */
@property(nonatomic, readonly, strong) NSMutableDictionary *userInfo;


#pragma mark Creating the Error

/**
 Constructs an error from all the information in the receiver
 */
@property(nonatomic, readonly, copy) NSError *error;


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

@property(nonatomic, copy, nullable) NSString *localizedRecoverySuggestion;

/**
 Sets the localized recovery suggestion built from a format string.
 
 @param format The localized recovery suggestion of the error in printf format.
 */
- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);


#pragma mark Recovery Options and Attempter
/**
 Sets the recovery options and attempter in one fell swoop.
 
 @param options An array of localized strings, one for each recovery option. Must contain at least one object.
 @param recoveryAttempter An object that implements the `NSErrorRecoveryAttempting` informal protocol. Must not be `nil`.
 */
- (void)setLocalizedRecoveryOptions:(NSArray *)options attempter:(NSObject *)recoveryAttempter;

/**
 Adds a recovery option with corresponding block to perform it.
 
 Your recovery block should return a `BOOL` to indicate if recovery was
 successful. Avoid strongly referencing the receiver within the block as that
 will most likely create a retain cycle.
 
 @param option The localized recovery option. Must not be `nil`.
 @param attempter A block that attempts recovery from the error. May be `nil` to handle things like "Cancel" buttons.
 */
- (void)addLocalizedRecoveryOption:(NSString *)option attempterBlock:(nullable BOOL(^)())attempter;

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
                     attempterBlock:(BOOL(^)(NSError *error, NSUInteger recoveryOptionIndex))attempter;


#pragma mark URL Errors

/**
 Creates and initializes a `KSError` object pertaining to a given URL.
 
 URL error codes generally come from `NSURLError.h` or `FoundationErrors.h`.
 
 @param domain The error domain, generally `NSCocoaErrorDomain` or `NSURLErrorDomain`.
 @param code The error code for the error.
 @param URL The URL involved in the error.
 @return A `KSWErrorBuilder` object with the various URL-related info keys filled in
 */
+ (instancetype)errorBuilderWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL;


#pragma mark Validation Errors

/**
 Creates and initializes a `KSWErrorBuilder` object for a validation error.
 
 Most validation error codes are found in `CoreDataErrors.h`, but there's a few
 in `FoundationErrors.h` too.
 
 @param code A Cocoa error code, generally between `NSValidationErrorMinimum` and `NSValidationErrorMaximum`.
 @param object The object being validated.
 @param key The key (or key path) being validated.
 @param value The value that was found to be invalid.
 @param format The localized description of the error in printf format.
 @return A `KSError` object for `NSCocoaErrorDomain` with the specified error `code` and `-userInfo` dictionary built from `object`, `key`, and `format, ...`.
 */
+ (instancetype)validationErrorBuilderWithCode:(NSInteger)code
                                        object:(id)object
                                           key:(NSString *)key
                                         value:(id)value;


#pragma mark Quickly Constructing an Error

/**
 Creates and initializes a `KSError` object for a given domain and code with a given localized description.
 
 @param domain The error domain—this can be one of the predefined `NSError` domains, or an arbitrary string describing a custom domain. `domain` must not be `nil`.
 @param code The error code for the error.
 @param description The localized description of the error.
 @return A `KSError` object for `domain` with the specified error `code` and `-localizedDescription` of `description`.
 */
+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description;

/**
 Creates and initializes a `KSError` object for a given domain and code with a given localized description.
 
 @param domain The error domain—this can be one of the predefined `NSError` domains, or an arbitrary string describing a custom domain. `domain` must not be `nil`.
 @param code The error code for the error.
 @param format The localized description of the error in printf format.
 @return A `KSError` object for `domain` with the specified error `code` and `-localizedDescription` built from `format, ...`.
 */
+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(3, 4);


@end

NS_ASSUME_NONNULL_END
