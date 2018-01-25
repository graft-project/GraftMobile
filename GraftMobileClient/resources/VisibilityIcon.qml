import QtQuick 2.9
import QtQuick.Controls 2.2

CheckBox {
    id: visibilityControl
    checked: false
    indicator.width: 1
    indicator.height: 1

    Image {
        anchors {
            fill: parent
            bottomMargin: 1
            leftMargin: 1
        }
        fillMode: Image.PreserveAspectFit
        source: visibilityControl.checked ? "qrc:/imgs/visibility_on.png" : "qrc:/imgs/visibility_off.png"
    }
}
