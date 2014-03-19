//
//  InterceptorKitTests.m
//  InterceptorKitTests
//
//  Created by Iska on 02/03/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InterceptorKit.h"

@interface InterceptorKitTests : XCTestCase
{
	NSInteger _testInteger;
	NSDictionary *_testDictionary;
	NSRange _testRange;
}

@end

@implementation InterceptorKitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)argumentsTestSelectorWithInteger:(NSInteger)integer dictionary:(NSDictionary *)dictionary andStruct:(NSRange)range
{
	_testInteger = integer;
	_testDictionary = dictionary;
	_testRange = range;
}

- (void)testPreInvokeInterceptor
{
	NSMutableString *testString = [NSMutableString stringWithString:@"InterceptorKit"];
	NSInteger length = [testString length];

    NSMutableString *interceptor = (NSMutableString *)[[IKInterceptor alloc] initWithTarget:testString];

	__block NSInteger count = 0;

	[(IKInterceptor *)interceptor interceptSelector:@selector(appendFormat:)
									 withMode:IKInterceptionModePreInvoke
									andAction:^(id interceptedTarget, SEL interceptedSelector) {
										count++;
										XCTAssertTrue([testString length] < length + count,
													  @"PreInvoke Interceptor should have been called beffore appendForamt");
									}];

	for (int i = 0; i < 5; i++) {
		[interceptor appendFormat:@"%d", i];
	}

	XCTAssertTrue(count == 5, @"Interceptor should have been called 5 times");
}

- (void)testPostInvokeInterceptor
{
	NSMutableString *testString = [NSMutableString stringWithString:@"InterceptorKit"];
	NSInteger length = [testString length];

    NSMutableString *interceptor = (NSMutableString *)[[IKInterceptor alloc] initWithTarget:testString];

	__block NSInteger count = 0;

	[(IKInterceptor *)interceptor interceptSelector:@selector(appendFormat:)
									 withMode:IKInterceptionModePostInvoke
									andAction:^(id interceptedTarget, SEL interceptedSelector) {
										count++;
										XCTAssertTrue([testString length] == length + count,
													  @"PreInvoke Interceptor should have been called after appendForamt");
									}];

	for (int i = 0; i < 5; i++) {
		[interceptor appendFormat:@"%d", i];
	}

	XCTAssertTrue(count == 5, @"Interceptor should have been called 5 times");
}

- (void)testPreAndPostInvokeInterceptor
{
	NSMutableString *testString = [NSMutableString stringWithString:@"InterceptorKit"];

    NSMutableString *interceptor = (NSMutableString *)[[IKInterceptor alloc] initWithTarget:testString];

	__block NSInteger count = 0;

	[(IKInterceptor *)interceptor interceptSelector:@selector(appendFormat:)
									 withMode:IKInterceptionModePreInvoke | IKInterceptionModePostInvoke
									andAction:^(id interceptedTarget, SEL interceptedSelector) {
										count++;
									}];

	for (int i = 0; i < 5; i++) {
		[interceptor appendFormat:@"%d", i];
	}

	XCTAssertTrue(count == 10, @"Interceptor should have been called 10 times");
}

- (void)testConditionalInterceptor
{
	NSMutableString *testString = [NSMutableString stringWithString:@"InterceptorKit"];

	NSMutableString *interceptor = (NSMutableString *)[[IKInterceptor alloc] initWithTarget:testString];

	__block NSInteger count = 0;

	[(IKInterceptor *)interceptor interceptSelector:@selector(appendFormat:)
									 withMode:IKInterceptionModeConditional
									condition:^BOOL(id interceptedTarget, SEL interceptedSelector) {
										return count < 3;
									}
									andAction:^(id interceptedTarget, SEL interceptedSelector) {
										count++;
									}];

	for (int i = 0; i < 5; i++) {
		[interceptor appendFormat:@"%d", i];
	}

	XCTAssertTrue(count == 3, @"Interceptor's action should have been run 3 times");
}

- (void)testArgumentsInterceptor
{
	InterceptorKitTests *interceptor = (InterceptorKitTests *)[[IKInterceptor alloc] initWithTarget:self];

	[(IKInterceptor *)interceptor  interceptArguemntsForSelector:@selector(argumentsTestSelectorWithInteger:dictionary:andStruct:)
													  withAction:^(id interceptedTarget, SEL interceptedSelector, NSMutableArray *argumentsList) {
														  [argumentsList replaceObjectAtIndex:0 withObject:@(100)];
														  [argumentsList replaceObjectAtIndex:1 withObject:@{ @"key" : @"obj2" }];
														  [argumentsList replaceObjectAtIndex:2 withObject:[NSValue valueWithRange:NSMakeRange(0, 100)]];
													  }];

	[interceptor argumentsTestSelectorWithInteger:42 dictionary:@{ @"key" : @"obj1" } andStruct:NSMakeRange(3, 9)];

	XCTAssertTrue(_testInteger == 100, @"Integer argument should be [100]");
	XCTAssertEqualObjects(_testDictionary, @{ @"key" : @"obj2" }, @"Dictionary object for key should be [obj2]");
	XCTAssertTrue(_testRange.location == 0 && _testRange.length == 100, @"Range argument should be [0, 100]");
}

@end
