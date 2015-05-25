//
//  KSError.m
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

#import "KSError.h"


@implementation KSError

+ (instancetype)errorWithDomain:(NSString *)errorDomain
                 code:(NSInteger)errorCode 
 localizedDescription:(NSString *)description
localizedRecoverySuggestion:(NSString *)recoverySuggestion
      underlyingError:(NSError *)underlyingError
{
    KSMutableError *result = [KSMutableError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    
    [result setObject:description forUserInfoKey:NSLocalizedDescriptionKey];
    [result setObject:recoverySuggestion forUserInfoKey:NSLocalizedRecoverySuggestionErrorKey];
    [result setObject:underlyingError forUserInfoKey:NSUnderlyingErrorKey];
    
    return result;
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code persistentStore:(NSPersistentStore *)store;
{
    NSParameterAssert(store);
    
    KSMutableError *result = [KSMutableError errorWithDomain:domain code:code URL:[store URL]];
    [result setObject:[NSArray arrayWithObject:store] forUserInfoKey:NSAffectedStoresErrorKey];
    return result;
}

@end
