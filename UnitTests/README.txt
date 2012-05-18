------------------------------------------------------------------------
Useful syntax for GHUnit testing (Example)
------------------------------------------------------------------------

- (BOOL)shouldRunOnMainThread {
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
  // Also an async test that calls back on the main thread, you'll probably want to return YES.
  return NO;
}

- (void)setUpClass {
  // Run at start of all tests in the class
}

- (void)tearDownClass {
  // Run at end of all tests in the class
}

- (void)setUp {
  // Run before each test method
}

- (void)tearDown {
  // Run after each test method
}   

- (void)testFoo {       
  NSString *a = @"foo";
  GHTestLog(@"I can log to the GHUnit test console: %@", a);

  // Assert a is not NULL, with no custom error description
  GHAssertNotNULL(a, nil);

  // Assert equal objects, add custom error description
  NSString *b = @"bar";
  GHAssertEqualObjects(a, b, @"A custom error message. a should be equal to: %@.", b);
}

- (void)testBar {
  // Another test
}

------------------------------------------------------------------------
For Asynchronous Testing (Example)
------------------------------------------------------------------------

@interface ExampleAsyncTest : GHAsyncTestCase { }
@end

@implementation ExampleAsyncTest

- (void)testURLConnection {

  // Call prepare to setup the asynchronous action.
  // This helps in cases where the action is synchronous and the
  // action occurs before the wait is actually called.
  [self prepare];

  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]http://www.google.com"]];
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];

  // Wait until notify called for timeout (seconds); If notify is not called with kGHUnitWaitStatusSuccess then
  // we will throw an error.
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];

  [connection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  // Notify of success, specifying the method where wait is called.
  // This prevents stray notifies from affecting other tests.
  [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testURLConnection)];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  // Notify of connection failure
  [self notify:kGHUnitWaitStatusFailure forSelector:@selector(testURLConnection)];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  GHTestLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
} 

------------------------------------------------------------------------
Macros
------------------------------------------------------------------------

GHAssertNoErr(a1, description, ...)
GHAssertErr(a1, a2, description, ...)
GHAssertNotNULL(a1, description, ...)
GHAssertNULL(a1, description, ...)
GHAssertNotEquals(a1, a2, description, ...)
GHAssertNotEqualObjects(a1, a2, desc, ...)
GHAssertOperation(a1, a2, op, description, ...)
GHAssertGreaterThan(a1, a2, description, ...)
GHAssertGreaterThanOrEqual(a1, a2, description, ...)
GHAssertLessThan(a1, a2, description, ...)
GHAssertLessThanOrEqual(a1, a2, description, ...)
GHAssertEqualStrings(a1, a2, description, ...)
GHAssertNotEqualStrings(a1, a2, description, ...)
GHAssertEqualCStrings(a1, a2, description, ...)
GHAssertNotEqualCStrings(a1, a2, description, ...)
GHAssertEqualObjects(a1, a2, description, ...)
GHAssertEquals(a1, a2, description, ...)
GHAbsoluteDifference(left,right) (MAX(left,right)-MIN(left,right))
GHAssertEqualsWithAccuracy(a1, a2, accuracy, description, ...)
GHFail(description, ...)
GHAssertNil(a1, description, ...)
GHAssertNotNil(a1, description, ...)
GHAssertTrue(expr, description, ...)
GHAssertTrueNoThrow(expr, description, ...)
GHAssertFalse(expr, description, ...)
GHAssertFalseNoThrow(expr, description, ...)
GHAssertThrows(expr, description, ...)
GHAssertThrowsSpecific(expr, specificException, description, ...)
GHAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
GHAssertNoThrow(expr, description, ...)
GHAssertNoThrowSpecific(expr, specificException, description, ...)
GHAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)