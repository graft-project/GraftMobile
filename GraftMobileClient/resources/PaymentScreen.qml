import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "components"

BaseScreen {
    id: root

    property alias textLabel: completeLabelText.text

    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
        actionButtonState: true
    }
    action: pushScreen

    Rectangle {
        anchors.fill: parent
        color: Qt.platform.os === "ios" ? "#FFFFFF" : "#E9E9E9"

        Item {
            anchors {
                top: parent.top
                bottom: completeLabel.top
                left: parent.left
                right: parent.right
            }

            Image {
                anchors.centerIn: parent
                height: 200
                width: height
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/paid_icon.png"
            }
        }

        Pane {
            id: completeLabel

            height: 50
            anchors {
                right: parent.right
                left: parent.left
                bottom: doneButton.top
                bottomMargin: Qt.platform.os === "android" ? 15 : doneButton.height + 15
            }
            Material.elevation: Qt.platform.os === "android" ? 6 : 0
            padding: 0

            contentItem: Rectangle {
                color: ColorFactory.color(DesignFactory.CircleBackground)

                Text {
                    id: completeLabelText
                    anchors.centerIn: parent
                    color: "#FFFFFF"
                }
            }
        }

        WideActionButton {
            id: doneButton
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 15
                rightMargin:15
                bottomMargin: 15
            }
            text: qsTr("DONE")
            onClicked: pushScreen()
        }
    }
}
