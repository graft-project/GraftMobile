import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "components"

BaseScreen {
    id: root

    property int elevation: 0

    screenHeader {
        navigationButtonState: Qt.platform.os === "android" ? true : false
        actionButton: true
    }
    action: pushScreen.openBalanceScreen

    Pane {
        id: completeLabel
        height: 50
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
        }
        Material.background: ColorFactory.color(DesignFactory.CircleBackground)
        Material.elevation: elevation

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 12
            }
            color: "#ffffff"
            text: qsTr("Paid complete!")
        }
    }

    ColumnLayout {
        anchors {
            top: completeLabel.bottom
            topMargin: 10
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        spacing: 10

        Rectangle {
            id: backgroundRect
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Qt.platform.os === "ios" ? "#FFFFFF" : "#E9E9E9"

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
}
