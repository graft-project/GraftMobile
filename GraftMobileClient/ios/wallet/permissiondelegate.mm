#include "permissiondelegate.h"

#include <AVFoundation/AVFoundation.h>
#include <UIKit/UIKit.h>

bool PermissionDelegate::isCameraAuthorised()
{
    NSString *mediaType = AVMediaTypeVideo;
    return [AVCaptureDevice authorizationStatusForMediaType:mediaType] == AVAuthorizationStatusAuthorized;
}
