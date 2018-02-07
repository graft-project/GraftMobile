import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Dialog {
    property alias passwordTextField: textField
    property alias dialogMessage: message.text
    property alias denyButton: leftButton
    property alias confirmButton: rightButton
    property bool dialogMode: false

    visible: false
    modal: true
    padding: 5
    margins: 18
    contentItem: ColumnLayout {
        spacing: 0

        TextField {
            id: textField
            visible: !dialogMode
            Layout.fillWidth: true
            Layout.minimumWidth: 250
            Layout.rightMargin: 20
            Layout.leftMargin: 20
            font.pixelSize: 24
            echoMode: TextInput.Password
            passwordCharacter: '•'
        }

        Label {
            id: message
            visible: dialogMode
            Layout.fillWidth: true
            Layout.minimumWidth: 250
            Layout.rightMargin: 20
            Layout.leftMargin: 20
            wrapMode:Text.WordWrap
            font.pixelSize: 15
        }

        RowLayout {
            spacing: 5
            Layout.alignment: Qt.AlignRight | Qt.AlignBottom
            Layout.rightMargin: 20

            Button {
                id: leftButton
                flat: true
            }

            Button {
                id: rightButton
                flat: true
            }
        }
    }
}
