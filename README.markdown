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

Contact
=======

I'm Mike Abdullah, of [Karelia Software](http://karelia.com). [@mikeabdullah](http://twitter.com/mikeabdullah) on Twitter.

Questions about the code should be left as issues at https://github.com/karelia/KSError or message me on Twitter.

Dependencies
============

None beyond Foundation. Probably works back to OS X v10.3 if you were so inclined

License
=======

Standard BSD, yada yada yada…