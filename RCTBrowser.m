#import "RCTBrowser.h"

#import "TOWebViewController.h"

@implementation RCTBrowser

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(presentUrl:(NSString *)url withOptions:(NSDictionary *)options) {

    if ([[options objectForKey:@"deleteAllCookies"] isEqual: @(YES)]) {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:url];

    [options enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"showLoadingBar"]) {
            webVC.showLoadingBar = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"showUrlWhileLoading"]) {
            webVC.showUrlWhileLoading = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"loadingBarTintColor"]) {
            webVC.loadingBarTintColor = [RCTConvert UIColor:obj];
        } else if ([key isEqualToString:@"navigationButtonsHidden"]) {
            webVC.navigationButtonsHidden = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"showActionButton"]) {
            webVC.showActionButton = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"showDoneButton"]) {
            webVC.showDoneButton = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"doneButtonTitle"]) {
            webVC.doneButtonTitle = (NSString*)obj;
        } else if ([key isEqualToString:@"showPageTitles"]) {
            webVC.showPageTitles = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"disableContextualPopupMenu"]) {
            webVC.disableContextualPopupMenu = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"hideWebViewBoundaries"]) {
            webVC.hideWebViewBoundaries = ([obj isEqual: @(YES)]);
        } else if ([key isEqualToString:@"modalCompletionHandler"]) {
            // TODO: turn this into a callback
        } else if ([key isEqualToString:@"shouldStartLoadRequestHandler"]) {
            // TODO: turn this into a callback
        } else if ([key isEqualToString:@"buttonTintColor"]) {
            webVC.buttonTintColor = [RCTConvert UIColor:obj];
        } else if ([key isEqualToString:@"buttonBevelOpacity"]) {
            // TODO: NOT YET IMPLEMENTED
        }
    }];

    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];

    [options enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
            if ([key isEqualToString:@"barTintColor"]) {
                UIColor *color = [RCTConvert UIColor:obj];

                nav.navigationBar.barTintColor = color;
                nav.toolbar.barTintColor = color;
            } else if ([key isEqualToString:@"titleTintColor"]) {
               UIColor *color = [RCTConvert UIColor:obj];

               nav.navigationBar.tintColor = color;
               nav.toolbar.tintColor = color;

               [nav.navigationBar setTitleTextAttributes:
                  @{NSForegroundColorAttributeName:color}];
           }
        }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [rootVC presentViewController:nav animated:YES completion: nil];
    });
    
    self.browser = webVC;
}

RCT_EXPORT_METHOD(close) {
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

@end
