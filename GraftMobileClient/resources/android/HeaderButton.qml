import QtQuick 2.9
import QtQuick.Controls 2.2

RoundButton {
    id: button

    property alias image: buttonImage
    signal buttonClicked()
//    Layout.preferredHeight: parent.height - 10
//    Layout.preferredWidth: height
//    Layout.alignment: Qt.AlignLeft
//    visible: isNavigationButtonVisible
    flat: true

    Image {
        id: buttonImage
//        width: 20
//        height: 18
        anchors.centerIn: parent
//        source: "qrc:/imgs/back_icon.png"
    }

    onClicked: buttonClicked()
}
