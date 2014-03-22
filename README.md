# InterceptorKit

InterceptorKit is an Objective-C library for iOS and MacOSX, that facilitates the interception of method invocations. It is block-based, provides several different interception modes and has an easy API.

## Current version is 0.2

InterceptorKit is a work in progress.

## NSProxy Approach

The easier, hight level, approach involves wrapping the object instance whose selectors are to be intercepted in a NSProxy. The proxy is then used instead of the actual instance and performs the corresponding invocations.

InterceptoKit brings one such NSProxy subclass, the `IKInterceptor`, that can be used in three easy steps:

1. Create the interceptor with a given object instance
2. Define selectors that are to be intercepted
3. Assign the interceptor back to the actual instance (A cast is needed)

A simple example could look like this, given an instance of, let's say NSString:

```objective-c
NSString *path = @"~/BrainCookie/example.md"; // where example.md is a symlink to Desktop/example.md

IKInterceptor *interceptor = [[IKInterceptor alloc] initWithTarget:path];
[interceptor interceptSelector:@selector(stringByResolvingSymlinksInPath) withAction:^(id interceptedTarget, SEL interceptedSelector) {
	NSLog(@"Path: %@", path);
}];
path = (NSString *)interceptor; // This line is necesseray

path = [path stringByResolvingSymlinksInPath];
```

The output will be:

```text
Path: ~/BrainCookie/example.md
Path: /Users/BrainCookie/Desktop/example.md
```

Notice how the interceptor is assigned to the actual instance. This is necessary for the interception to work.

The default interception mode executes the block once before the actual invocation and once after it. InterceptorKit supports four different modes.

### Interception Modes

An interception for a given selector must specify an `IKInterceptionMode`, or a combination via a bitmask, beforehand.

When using the `interceptSelector:withAction:` method, the mode is set to `IKInterceptionModePreInvoke | IKInterceptionModePostInvoke` meaning that the action block will be executed before and after the actual selector.

All other API methods accept a mode-parameter, which defaults the bitmask to `IKInterceptionModePreInvoke` in case of an invalid combination.

Currently InterceptorKit defines the following modes:

> The following examples are a bit contrived but should serve the demonstration purpose pretty well.

* `IKInterceptionModePreInvoke` executes the action block before the actual method invocation

```objective-c
NSMutableString *someData = [NSMutableString stringWithString:@"InterceptorKit"];

IKInterceptor *interceptor = [[IKInterceptor alloc] initWithTarget:someData];
[interceptor interceptSelector:@selector(appendString:) withMode:IKInterceptionModePreInvoke andAction:^(id interceptedTarget, SEL interceptedSelector) {
	NSData *data = [interceptedTarget dataUsingEncoding: NSUTF8StringEncoding];
	NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
	[interceptedTarget replaceCharactersInRange:NSMakeRange(0, [interceptedTarget length]) withString:base64String];
}];
someData = (NSMutableString *)interceptor;
[someData appendString:@"Example"];
NSLog(@"%@", someData);
```

The output will be:

```text
SW50ZXJjZXB0b3JLaXQ=Example // "SW50ZXJjZXB0b3JLaXQ=" is "InterceptoKit" in base64
```

* `IKInterceptionModePostInvoke` executes the action block after the actual method invocation

```objective-c
NSMutableArray *sortableArray = [NSMutableArray arrayWithObjects:@(9), @(2), nil];
NSSortDescriptor *ascendingSort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
NSArray *sortDescriptors = @[ascendingSort];

IKInterceptor *interceptor = [[IKInterceptor alloc] initWithTarget:sortableArray];
[interceptor interceptSelector:@selector(addObject:) withMode:IKInterceptionModePostInvoke andAction:^(id interceptedTarget, SEL interceptedSelector) {
	[interceptedTarget sortUsingDescriptors:sortDescriptors];
}];
sortableArray = (NSMutableArray *)interceptor;

NSLog(@"Before: %@", sortableArray);
[sortableArray addObject:@(5)];
NSLog(@"After: %@", sortableArray);
```

The output will be:

```text
Before: ( 9, 2 )
After: ( 2, 5, 9 )
```

* `IKInterceptionModeConditional` executes the action block only if the condition block returns true

> A conditional interceptor always runs in pre-invoke mode if not specified otherwise

```objective-c
NSMutableArray *words = [NSMutableArray array];

IKInterceptor *interceptor = [[IKInterceptor alloc] initWithTarget:words];
[interceptor interceptSelector:@selector(addObject:) withMode:IKInterceptionModeConditional condition:^BOOL(id intercerptedTarget, SEL interceptedSelector) {
	return [intercerptedTarget count] >= 3;
} andAction:^(id interceptedTarget, SEL interceptedSelector) {
	[interceptedTarget removeObjectAtIndex:0];
}];
words = (NSMutableArray *)interceptor;

[words addObject:@"One"];
[words addObject:@"Two"];
[words addObject:@"Three"];
[words addObject:@"Four"];
NSLog(@"%@", words);
```

The output will be:

```text
( Two, Three, Four )
```

### Arguments Interception

InterceptorKit offers another kind of selector interception, wherein the action block gets the arguments of said selector passed in a mutable array. The arguemnts can be inspected and even changed/replaced.

The arguments in the passed array are sorted in regards to their ocurrence order in the intercepted selector. For exmaple the `NSMutableArray` selector `replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;` will result in the folowing arguments list:

```text
( NSValue, id, NSValue )
```

> To get the struct stored in a `NSValue` object refer to `getValue:(void *)buffer` method of `NSValue`

whereas the `insertString:(NSString *)aString atIndex:(NSUInteger)loc` of `NSMutableString` results in the following arguments list:

```text
( id, NSNumber )
```

The arguments, as seen in the examples above, are wrapped in suitable corresponding objects, i.e. primitive types are packed in `NSNumber` instances, selectors and structs are packed in `NSValue` instances, objects are of type `id`

Arguments interpretation and replacement are the task of the developer. InterceptorKit performs no sanity checks in case the arguments array is no longer valid.

An example is worth a thousand words, or so they say

```objective-c
NSMutableArray *objects = [NSMutableArray arrayWithObject:@"Interceptor"];

IKInterceptor *interceptor = [[IKInterceptor alloc] initWithTarget:objects];
[interceptor  interceptArguemntsForSelector:@selector(replaceObjectAtIndex:withObject:) withAction:^(id interceptedTarget, SEL interceptedSelector, NSMutableArray *argumentsList) {
	// First argument is NSUInteger, hence we have a NSNumber at the index 0
	NSUInteger indexArgument = [[argumentsList objectAtIndex:0] unsignedIntegerValue];
	// Second argument at index 1 is an object
	id objectArgument = [argumentsList objectAtIndex:1];
	// We can inspect the arguments
	if (![objectArgument isEqual:@"Kit"]) {
		// We can replace the second argument
		[argumentsList replaceObjectAtIndex:1 withObject:@"Kit"];
	}
	// And we can manipulate the target instance
	while ([interceptedTarget count] < indexArgument + 1) {
		[interceptedTarget addObject:[NSNull null]];
	}
}];
objects = (NSMutableArray *)interceptor;

// The original array has only one object, but we call replace with index 3, which usually
// throws an exception. Notice the replacement object: @"Library"
[objects replaceObjectAtIndex:3 withObject:@"Library"];
// The log doesn't lie, we have no "Library" here
NSLog(@"%@", objects);
```

The output will be:

```text
( Interceptor, "<null>", "<null>", Kit )

```

## IMP Injection

Work in progress.

## License

InterceptorKit is licensed under the [MIT Licence](LICENSE)
