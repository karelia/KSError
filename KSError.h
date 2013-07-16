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

// Returns YES if the receiver or one of its underlying erros matches the domain and code
- (BOOL)ks_isErrorOfDomain:(NSString *)domain code:(NSInteger)code;

// Lower-level version of the above so you can pick out the specific error and work with it
- (NSError *)ks_errorOfDomain:(NSString *)domain code:(NSInteger)code;

@end


#pragma mark -


@interface KSError : NSError    // subclass so don't have to prefix method names

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description;

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(3, 4);

+ (instancetype)errorWithDomain:(NSString *)errorDomain
                 code:(NSInteger)errorCode 
 localizedDescription:(NSString *)description
localizedRecoverySuggestion:(NSString *)recoverySuggestion
      underlyingError:(NSError *)underlyingError;

+ (instancetype)validationErrorWithCode:(NSInteger)code
                       object:(id)object
                          key:(NSString *)key
                        value:(id)value
   localizedDescriptionFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(5, 6);

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code persistentStore:(NSPersistentStore *)store;

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL;

@end


#pragma mark -


@interface KSMutableError : KSError
{
  @private
    NSMutableDictionary *_mutableUserInfo;
}

+ (instancetype)errorWithUnderlyingError:(NSError *)error;    // handy to recycle existing error's domain and code, ready for further info

- (id)objectForUserInfoKey:(NSString *)key; // slightly faster than -userInfo
- (void)setObject:(id)object forUserInfoKey:(NSString *)key;

// Note you can only mutate user info; domain & code are fixed


#pragma mark Convenience

@property(nonatomic, copy) NSString *localizedDescription;
- (void)setLocalizedDescriptionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)setLocalizedRecoverySuggestionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

// Recovery attempter should implement the NSErrorRecoveryAttempting informal protocol
- (void)setLocalizedRecoveryOptions:(NSArray *)options attempter:(NSObject *)recoveryAttempter;

#if NS_BLOCKS_AVAILABLE

- (void)addLocalizedRecoveryOption:(NSString *)option attempterBlock:(BOOL(^)())attempter;

// DON'T reference the error in your attempter block as that leads to a retain cycle. Instead, work with the error object as passed to the block
- (void)setLocalizedRecoveryOptions:(NSArray *)options
                     attempterBlock:(BOOL(^)(NSError *error, NSUInteger recoveryOptionIndex))attempter;

#endif

@end
