import QtQuick 2.9
import com.device.platform 1.0

Loader {
    id: dialogLoader

    property var rootScreenWidth: null
    property var rootScreenHeight: null

    function openDialog() {
        if (!Detector.isPlatform(Platform.Desktop)) {
            dialogLoader.setSource("qrc:/CameraPermissionDialog.qml", { "openDialog": true,
                                   "screenHeight": rootScreenHeight,
                                   "screenWidth": rootScreenWidth })
        } else {
            dialogLoader.setSource("qrc:/BaseSelectImageDialog.qml", {
                                   "screenHeight": rootScreenHeight,
                                   "screenWidth": rootScreenWidth })
        }
    }
}
