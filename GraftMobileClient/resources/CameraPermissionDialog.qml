import QtQuick 2.9
import org.camera.permission 1.0

BaseSelectImageDialog {
    property bool openDialog: false

    Connections {
        target: ImagePicker
        onCameraPermissionProvided: {
            if (result === AbstractCameraPermission.Denied) {
                cameraButtonEnabled = false
            }
            if ((result !== AbstractCameraPermission.Granted)) {
                dialog.open()
            }
        }
    }

    onOpenDialogChanged: {
        if (ImagePicker.hasCameraPermission() === AbstractCameraPermission.Denied) {
            ImagePicker.requestCameraPermission()
        } else {
            dialog.open()
        }
    }
}
