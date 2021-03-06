#import "ObjectTesting.h"
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSObject.h>

static BOOL freed;
@interface Test : NSObject @end
@implementation Test
- (void)dealloc
{
	freed = YES;
	[super dealloc];
}
@end

int main()
{
  NSAutoreleasePool   *arp = [NSAutoreleasePool new];
  NSObject *o = [NSObject new];
  unsigned i;

  for (i = 0; i < 1000; i++)
  {
    [[o retain] autorelease];
  }
  NSUInteger totalCount = [arp autoreleaseCount];
  PASS(totalCount == 1000, "Autorelease count is correct");
  PASS([NSAutoreleasePool autoreleaseCountForObject: o] == 1000,
       "Autorelease count for object is correct");
  PASS(freed == NO, "Object not prematurely freed");
  [arp release]; 
  arp = [NSAutoreleasePool new];
  [o release];
  PASS(freed == NO, "Object freed by autoreleasing");
  [arp release]; 
  return 0;
}
