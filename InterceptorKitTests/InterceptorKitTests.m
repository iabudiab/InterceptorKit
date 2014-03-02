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

- (void)testPreInvokeInterceptor
{
	NSMutableString *testString = [NSMutableString stringWithString:@"InterceptorKit"];
	NSInteger length = [testString length];

    NSMutableString *interceptor = (NSMutableString *)[[IKProxy alloc] initWithTarget:testString];

	__block NSInteger count = 0;

	[(IKProxy *)interceptor interceptSelector:@selector(appendFormat:)
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

    NSMutableString *interceptor = (NSMutableString *)[[IKProxy alloc] initWithTarget:testString];

	__block NSInteger count = 0;

	[(IKProxy *)interceptor interceptSelector:@selector(appendFormat:)
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

    NSMutableString *interceptor = (NSMutableString *)[[IKProxy alloc] initWithTarget:testString];

	__block NSInteger count = 0;

	[(IKProxy *)interceptor interceptSelector:@selector(appendFormat:)
									 withMode:IKInterceptionModePreInvoke | IKInterceptionModePostInvoke
									andAction:^(id interceptedTarget, SEL interceptedSelector) {
										count++;
									}];

	for (int i = 0; i < 5; i++) {
		[interceptor appendFormat:@"%d", i];
	}

	XCTAssertTrue(count == 10, @"Interceptor should have been called 10 times");
}


@end
