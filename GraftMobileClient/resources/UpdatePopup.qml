import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.device.platform 1.0

Popup {
    id: updatePopup

    property string link: ""
    property string version: ""
    property bool confirmUpdate: false

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    onClosed: {
        if (confirmUpdate) {
            Qt.openUrlExternally(link)
        }
    }

    ColumnLayout {
        spacing: 0
        anchors {
            leftMargin: 20
            rightMargin: 20
            left: parent.left
            right: parent.right
        }

        Label {
            Layout.topMargin: 20
            font {
                pixelSize: 17
                bold: true
            }
            wrapMode: Label.WordWrap
            text: qsTr("New Update Available")
        }

        Label {
            Layout.topMargin: 15
            Layout.fillWidth: true
            wrapMode: Label.WordWrap
            text: qsTr("The new version of the app (%1) is available on %2. Do you want to update?").arg(version).arg(Detector.isPlatform(Platform.Android) ? "Google Play" : "App Store")
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight

            Button {
                flat: true
                text: qsTr("No, thanks")
                onClicked: close()
            }

            Button {
                flat: true
                text: qsTr("Update")
                onClicked: {
                    confirmUpdate = true
                    close()
                }
            }
        }
    }
}
