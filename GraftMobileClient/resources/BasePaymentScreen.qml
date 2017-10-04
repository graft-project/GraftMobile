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
        navigationButtonState: true
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

        Image {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredHeight: 200
            Layout.preferredWidth: height
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/paid_icon.png"
        }

        WideActionButton {
            text: qsTr("DONE")
            onClicked: pushScreen.openBalanceScreen()
        }
    }
}
