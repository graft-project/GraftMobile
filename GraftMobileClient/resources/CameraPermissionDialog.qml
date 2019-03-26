import QtQuick 2.9
import org.camera.permission 1.0

BaseSelectImageDialog {
    property bool openDialog: false

    onOpenDialogChanged: {
        if (ImagePicker.hasCameraPermission() === AbstractCameraPermission.None) {
            cameraButtonEnabled = true
        } else {
            cameraButtonEnabled = ImagePicker.hasCameraPermission() === AbstractCameraPermission.Granted
        }
        dialog.open()
    }
}
