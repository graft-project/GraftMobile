import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Dialog {
    property alias passwordTextField: textField
    property alias dialogMessage: message.text
    property alias confirmButtonText: leftButton.text
    property alias confirmButtonEnabled: leftButton.enabled
    property alias denyButtonText: rightButton.text
    property bool dialogMode: false

    signal confirmed()
    signal denied()

    visible: false
    modal: true
    padding: 5
    margins: 18
    focus: true
    onOpened: textField.focus = true
    contentItem: ColumnLayout {
        spacing: 0

        TextField {
            id: textField
            focus: true
            visible: !dialogMode
            Layout.fillWidth: true
            Layout.minimumWidth: 250
            Layout.rightMargin: 20
            Layout.leftMargin: 20
            font.pixelSize: 24
            echoMode: TextInput.Password
            passwordCharacter: '•'
            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    processing(leftButton)
                }
            }
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
                onClicked: confirmed()
                Keys.onEnterPressed: processing(leftButton)
                Keys.onReturnPressed: processing(leftButton)
            }

            Button {
                id: rightButton
                flat: true
                onClicked: denied()
                Keys.onEnterPressed: processing(rightButton)
                Keys.onReturnPressed: processing(rightButton)
            }
        }
    }

    function processing(buttonId) {
        buttonId.clicked()
        textField.focus = true
    }
}
