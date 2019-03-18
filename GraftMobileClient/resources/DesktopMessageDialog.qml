import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Dialog {
    id: desktopMessageDialog

    property alias messageTitle: titleText.text
    property alias text: additionalText.text
    property alias firstButton: leftButton
    property alias secondButton: rightButton

    height: 170
    focus: true
    contentItem: ColumnLayout {
        spacing: 10

        Label {
            id: titleText
            Layout.fillWidth: true
            Layout.minimumWidth: 200
            Layout.rightMargin: 20
            Layout.leftMargin: 20
            wrapMode: Text.WordWrap
            font {
                pixelSize: 15
                bold: true
            }
        }

        Label {
            id: additionalText
            Layout.fillWidth: true
            Layout.minimumWidth: 200
            Layout.rightMargin: 20
            Layout.leftMargin: 28
            wrapMode: Text.WordWrap
            font.pixelSize: 12
            color: "#8e8e93"
        }

        RowLayout {
            Layout.rightMargin: 25
            Layout.alignment: Qt.AlignBottom

            Item {
                Layout.fillWidth: true
            }

            Button {
                id: leftButton
                font {
                    pixelSize: titleText.font.pixelSize
                    capitalization: Font.MixedCase
                }
                Keys.onEnterPressed: processing(leftButton, rightButton)
                Keys.onReturnPressed: processing(leftButton, rightButton)
            }

            Button {
                id: rightButton
                focus: true
                font {
                    pixelSize: titleText.font.pixelSize
                    capitalization: Font.MixedCase
                }
                Keys.onEnterPressed: processing(rightButton, rightButton)
                Keys.onReturnPressed: processing(rightButton, rightButton)
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        processing(rightButton, rightButton)
                    }
                }
            }
        }
    }

    function processing(itemPressed, itemFocus) {
        itemPressed.clicked()
        itemFocus.focus = true
    }
}
