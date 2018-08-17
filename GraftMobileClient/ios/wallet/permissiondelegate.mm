#include "permissiondelegate.h"

#include <AVFoundation/AVFoundation.h>
#include <UIKit/UIKit.h>

bool PermissionDelegate::isCameraAuthorised()
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    return authStatus == AVAuthorizationStatusAuthorized;
}
