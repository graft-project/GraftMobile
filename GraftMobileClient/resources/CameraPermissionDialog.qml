import QtQuick 2.9
import org.camera.permission 1.0

BaseSelectImageDialog {
    property bool openDialog: false

    Connections {
        target: ImagePicker
        onCameraPermissionProvided: {
//            if (result === AbstractCameraPermission.Denied) {
//                console.log("----3----")
//                cameraButtonEnabled = false
//            }
//            if ((result !== AbstractCameraPermission.Granted)) {
//                console.log("----4----")
//                dialog.open()
//            }

//            if (result === AbstractCameraPermission.Denied) {
                console.log("----3----", result)
            if (result === AbstractCameraPermission.Denied) {
                cameraButtonEnabled = false
            }
//                cameraButtonEnabled = false

//            }
//            if ((ImagePicker.hasCameraPermission() === AbstractCameraPermission.None)) {
//                console.log("----4----")
//                dialog.open()
//            }
//            else if (ImagePicker.hasCameraPermission() === AbstractCameraPermission.Denied)
//                cameraButtonEnabled = false

        }
    }

    onOpenDialogChanged: {
//        if (ImagePicker.hasCameraPermission() === AbstractCameraPermission.Denied) {
//            ImagePicker.requestCameraPermission()
//        } else {
//            console.log("----2----")
//            dialog.open()
//        }


        console.log("----1----")
//        if (ImagePicker.hasCameraPermission() === AbstractCameraPermission.Denied) {
//            cameraButtonEnabled = false
//        }
        dialog.open()
    }
}
