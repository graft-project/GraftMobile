import QtQuick 2.9
import org.camera.permission 1.0
import com.device.platform 1.0

BaseSelectImageDialog {
    property bool openDialog: false

    Connections {
        target: ImagePicker
        onCameraPermissionProvided: {
            if (result === AbstractCameraPermission.Denied) {
                cameraButtonEnabled = false
                dialog.open()
            }
        }
    }

    onOpenDialogChanged: {
        if (ImagePicker.hasCameraPermission() === AbstractCameraPermission.Denied) {
            if (Detector.isPlatform(Platform.IOS)) {
                cameraButtonEnabled = false
                dialog.open()
            } else if (Detector.isPlatform(Platform.Android)) {
                ImagePicker.requestCameraPermission()
            }
        } else {
            dialog.open()
        }
    }
}
