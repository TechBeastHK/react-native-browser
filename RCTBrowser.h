#import "RCTBridgeModule.h"
#import "RCTConvert.h"

#import "TOWebViewController.h"

@interface RCTBrowser : NSObject <RCTBridgeModule>

@property (nonatomic) TOWebViewController *browser;

@end
