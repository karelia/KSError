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

+ (instancetype)errorWithDomain:(NSString *)anErrorDomain code:(NSInteger)anErrorCode localizedDescription:(NSString *)aLocalizedDescription
{
	return [self errorWithDomain:anErrorDomain
                            code:anErrorCode
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:    // handle nil description to give empty dictionary
                                  aLocalizedDescription,
                                  NSLocalizedDescriptionKey,
                                  nil]];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ...;
{
	va_list argList;
	va_start(argList, format);
	NSString *formatted = [[NSString alloc] initWithFormat:format arguments:argList];
	va_end(argList);
	
	KSError *result = [self errorWithDomain:domain code:code localizedDescription:formatted];
    
#if !__has_feature(objc_arc)
    [formatted release];
#endif
	
    return result;
}

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

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code URL:(NSURL *)URL;
{
    KSMutableError *result = [KSMutableError errorWithDomain:domain code:code userInfo:nil];
    
    [result setObject:URL forUserInfoKey:NSURLErrorKey];
    
    if ([URL isFileURL]) [result setObject:[URL path] forUserInfoKey:NSFilePathErrorKey];
    
    if ([domain isEqualToString:NSURLErrorDomain])
    {
#if defined MAC_OS_X_VERSION_10_6 && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6
        [result setObject:URL forUserInfoKey:NSURLErrorFailingURLErrorKey];
        [result setObject:[URL absoluteString] forUserInfoKey:NSURLErrorFailingURLStringErrorKey];
#else
        [result setObject:[URL absoluteString] forUserInfoKey:NSErrorFailingURLStringKey];
#endif
    }
    
    return result;
}

@end
