Features
========

KSError provides two broad areas of functionality:

## Error Handling ##

	-[NSError ks_isErrorOfDomain:code:]

Easily query if an error matches a given domain and code, or encapsulates an underlying error which does. Handy for checking low-level errors without having to dig through the stack yourself. Also slightly less verbose than checking the domain and code manually.

## Error Creation ##

When creating your own APIs, it is often helpful to construct custom error objects to pass back to callers. Out of the box, `NSError` is rather tedious for this.

`KSError` is a subclass of `NSError` providing a bunch of convenience methods for creating particular types of error.

`KSMutableError` is pretty much what it says on the tin (what you call a "can" weirdo Americans). Errors can be constructed piece by piece using friendly APIs:

	- (void)setObject:(id)object forUserInfoKey:(NSString *)key;
	- (void)setLocalizedDescriptionWithFormat:(NSString *)format, ...;
	- (void)addLocalizedRecoveryOption:(NSString *)option attempterBlock:(BOOL(^)())attempter;

Contact
=======

I'm Mike Abdullah, of [Karelia Software](http://karelia.com). [@mikeabdullah](http://twitter.com/mikeabdullah) on Twitter.

Questions about the code should be left as issues at https://github.com/karelia/KSError or message me on Twitter.

Dependencies
============

None beyond Foundation. Probably works back to OS X v10.3 (for the non-block-based APIs) if you were so inclined.

License
=======

Copyright © 2011 Karelia Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Alternatives
============

* For just the error recovery aspect, [RMErrorRecoveryAttempter](https://github.com/realmacsoftware/RMErrorRecoveryAttempter) offers similar functionality
* [ErrorKit](https://github.com/hectr/ErrorKit) provides roughly the same feature set, plus:
	* Logging and asserting of errors
	* Error presentation on iOS
	* More convenience methods for accessing `userInfo` keys
	* An error *builder* class rather than mutable `NSError` subclass
