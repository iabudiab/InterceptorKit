//
//  NSInvocation+InterceptorKit.m
//  InterceptorKit
//
//  Created by Iska on 18/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import "NSInvocation+InterceptorKit.h"

@implementation NSInvocation (InterceptorKit)

- (id)argumentAtIndex:(NSInteger)index
{
	NSMethodSignature *signature = [self methodSignature];
	const char *argumentType = [signature getArgumentTypeAtIndex:index];
	switch (argumentType[0]) {
		case 'c':
		{
			char value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'i':
		{
			int value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 's':
		{
			short value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'l':
		{
			long value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'q':
		{
			long long value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'C':
		{
			unsigned char value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'I':
		{
			unsigned int value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'S':
		{
			unsigned short value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'L':
		{
			unsigned long value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'Q':
		{
			unsigned long long value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'f':
		{
			float value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'd':
		{
			double value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'B':
		{
			bool value;
			[self getArgument:&value atIndex:index];
			return @(value);
		}
		case 'v':
		{
			return nil;
		}
		case '*':
		{
			return nil;
		}
		case '@':
		{
			id value;
			[self getArgument:&value atIndex:index];
			return value;
		}
		case '#':
		{
			id value;
			[self getArgument:&value atIndex:index];
			return value;
		}
		case ':':
		{
			SEL value;
			[self getArgument:&value atIndex:index];
			return [NSValue valueWithBytes:value objCType:":"];
		}
		case '[':
		{
			return nil;
		}
		case '{':
		{
			NSUInteger size;
			NSGetSizeAndAlignment(argumentType, &size, NULL);
			NSMutableData *value = [NSMutableData dataWithLength:size];
			[self getArgument:[value mutableBytes] atIndex:index];
			return [NSValue valueWithBytes:[value bytes] objCType:argumentType];;
		}
		case '(':
		{
			return nil;
		}
		case 'b':
		{
			return nil;
		}
		case '^':
		{
			void *value = NULL;
			[self getArgument:&value atIndex:index];
			return [NSValue valueWithPointer:value];
		}
		case '?':
		{
			return nil;
		}
		default:
			return nil;
	}
}

- (NSMutableArray *)argumentsList
{
	NSMutableArray *array = [NSMutableArray array];
	NSMethodSignature *signature = [self methodSignature];

	for (int i = 2; i < signature.numberOfArguments; i++) {
		id arguemnt = [self argumentAtIndex:i];
		if (arguemnt) [array addObject:arguemnt];
	}

	return array;
}

- (void)setArguments:(NSArray *)arguments
{
	NSMethodSignature *signature = [self methodSignature];
	for (int index = 2; index < signature.numberOfArguments; index++) {
		id argument = [arguments objectAtIndex:index - 2];

		const char *argumentType = [signature getArgumentTypeAtIndex:index];
		switch (argumentType[0]) {
			case 'c':
			{
				char value = [argument charValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'i':
			{
				int value = [argument intValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 's':
			{
				short value = [argument shortValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'l':
			{
				long value = [argument longValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'q':
			{
				long long value = [argument longLongValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'C':
			{
				unsigned char value = [argument unsignedCharValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'I':
			{
				unsigned int value = [argument unsignedIntValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'S':
			{
				unsigned short value = [argument unsignedShortValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'L':
			{
				unsigned long value = [argument unsignedLongValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'Q':
			{
				unsigned long long value = [argument unsignedLongLongValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'f':
			{
				float value = [argument floatValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'd':
			{
				double value = [argument doubleValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'B':
			{
				bool value = [argument boolValue];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case 'v':
			{
				continue;
			}
			case '*':
			{
				continue;
			}
			case '@':
			{
				[self setArgument:&argument atIndex:index];
				continue;
			}
			case '#':
			{
				[self setArgument:&argument atIndex:index];
				continue;
			}
			case ':':
			{
				SEL value;
				[argument getValue:&value];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case '[':
			{
				continue;
			}
			case '{':
			{
				id value;
				[argument getValue:&value];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case '(':
			{
				continue;
			}
			case 'b':
			{
				continue;
			}
			case '^':
			{
				void *value = NULL;
				[argument getValue:&value];
				[self setArgument:&value atIndex:index];
				continue;
			}
			case '?':
			{
				continue;
			}
			default:
				continue;
		}
	}
}

@end
