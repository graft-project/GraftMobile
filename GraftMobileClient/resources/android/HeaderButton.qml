import QtQuick 2.9
import QtQuick.Controls 2.2

RoundButton {
    id: button

    property alias image: buttonImage
    signal buttonClicked()

    flat: true

    Image {
        id: buttonImage
        anchors.centerIn: parent
    }

    onClicked: buttonClicked()
}
