#include "iostools.h"

#include <UIKit/UIKit.h>
#include <sys/utsname.h>

@interface QIOSApplicationDelegate
@end

@interface QIOSApplicationDelegate (ApplicationDelegate)
@end

@implementation QIOSApplicationDelegate (ApplicationDelegate)
@end

#ifdef POS_BUILD
static const QString scUpdateAppLink("itms-apps://itunes.apple.com/us/app/graft-mobile-point-of-sale/id1354423996");
#elif WALLET_BUILD
static const QString scUpdateAppLink("itms-apps://itunes.apple.com/us/app/graft-cryptopay-wallet/id1354423228");
#endif

IOSTools::IOSTools(QObject *parent)
    : AbstractDeviceTools(parent)
{
}

IOSTools::~IOSTools()
{
}

bool IOSTools::isSpecialTypeDevice() const
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
        NSString *model = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else

        struct utsname systemInfo;
        uname(&systemInfo);

        NSString *model = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
#endif
        mIsIphoneXTypeDevice = [model isEqualToString:@"iPhone10,3"] || [model isEqualToString:@"iPhone10,6"] || //iPhone X
                               [model isEqualToString:@"iPhone11,8"] || //iPhone XR
                               [model isEqualToString:@"iPhone11,2"] || //iPhone XS
                               [model isEqualToString:@"iPhone11,4"] || [model isEqualToString:@"iPhone11,6"]; //iPhone XS Max
    });
    if (mIsIphoneXTypeDevice)
    {
        mBottomNavigationBarHeight = 34;
        mStatusBarHeight = 44;
    }
    return mIsIphoneXTypeDevice;
}

double IOSTools::bottomNavigationBarHeight() const
{
    isSpecialTypeDevice();
    return mBottomNavigationBarHeight;
}

double IOSTools::statusBarHeight() const
{
    isSpecialTypeDevice();
    return mStatusBarHeight;
}

void IOSTools::checkAppVersion() const
{
    if (@available(iOS 6.0, *))
    {
        NSError* error = nil;
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString* appID = infoDictionary[@"CFBundleIdentifier"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
        NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (!error)
        {
            NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!error && [lookup[@"resultCount"] integerValue] == 1)
            {
                NSString* appStoreVersion = lookup[@"results"][0][@"version"];
                NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
                if (![appStoreVersion isEqualToString:currentVersion])
                {
                    emit updateNeeded(scUpdateAppLink, QString::fromNSString(appStoreVersion));
                    qDebug("Need to update [%s != %s]", [appStoreVersion UTF8String], [currentVersion UTF8String]);
                }
            }
        }
    }
}
