import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "components"

ColumnLayout {
    property bool visibilityPass: false

    spacing: 0

    LinearEditItem {
        id: passwordTextField
        Layout.alignment: Qt.AlignLeft
        Layout.topMargin: 10
        maximumLength: 50
        title: Qt.platform.os === "android" ? qsTr("Password") : qsTr("Password:")
        echoMode: visibilityPass ? TextInput.Normal : TextInput.Password
        passwordCharacter: '•'

        RoundButton {
            radius: 100
            highlighted: true
            Material.elevation: 0
            Material.accent: visibilityPass ? "#2034435b" : "transparent"
            anchors {
                right: parent.right
                top: parent.top
                topMargin:  -5
            }
            background {
                x: 0
                y: 0
                width: background.parent.width
                height: background.parent.height
            }

            Image {
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                height: parent.height / 2
                width: parent.width / 2
                source: visibilityPass ? "qrc:/imgs/visibility_on.png" : "qrc:/imgs/visibility_off.png"
            }

            onClicked: {
                visibilityPass =!visibilityPass
            }
        }
    }
}
