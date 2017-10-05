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
        actionButton: true
    }
    action: pushScreen.openBalanceScreen

    Rectangle {
        height: parent.height
        width: parent.width
        color: Qt.platform.os === "ios" ? "#FFFFFF" : "#E9E9E9"

        Pane {
            id: completeLabel

            height: 50
            anchors {
                right: parent.right
                left: parent.left
                top: parent.top
            }
            background: Rectangle {color: ColorFactory.color(DesignFactory.CircleBackground)}
            Material.elevation: Qt.platform.os === "android" ? 10 : 0

            Text {
                id: completeLabelText
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 12
                }
                color: "#FFFFFF"
            }
        }

        Image {
            anchors.centerIn: parent
            height: 200
            width: height
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/paid_icon.png"
        }

        WideActionButton {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: 5
            }
            text: qsTr("DONE")
            onClicked: pushScreen.openBalanceScreen()
        }
    }
}
