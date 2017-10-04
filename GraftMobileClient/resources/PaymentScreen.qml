import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "components"

BaseScreen {
id: root

    Pane {
        id: completeLabel
        height: 50
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
        }
        Material.background: ColorFactory.color(DesignFactory.CircleBackground)
        Material.elevation: 4

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 12
            }
            color: "#ffffff"
            text: qsTr("Total Checkout: ") + totalAmount + '$'
        }
    }

    ColumnLayout {
        width: parent.width
        anchors {
            top: completeLabel.bottom
            topMargin: 10
            bottom: parent.bottom
        }

        Image {
            Layout.preferredWidth: parent.width / 1.75
            fillMode: Image.PreserveAspectFit

            source: "qrc:/imgs/paid_icon.png"
        }

        WideActionButton {
            text: qsTr("DONE")
            onClicked: confirmPay()
        }
    }
}
