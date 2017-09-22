import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../components"

BaseMenu {
    property alias balanceInGraft: walletItem.balanceInGraft

    logo: "qrc:/imgs/graft_pos_logo_small.png"

    ColumnLayout {
        spacing: 0
        anchors {
            left: parent.left
            right: parent.right
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/store.png"
            name: qsTr("Store")
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.backProductScreen()
            }
        }

        MenuWalletItem {
            id: walletItem
            Layout.fillWidth: true
            balanceInGraft: "1.14"
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openWalletScreen()
            }
        }

        Rectangle {
            id: line
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.preferredHeight: 1.5
            Layout.alignment: Qt.AlignBottom
            color: ColorFactory.color(DesignFactory.AllocateLine)
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/settings.png"
            name: qsTr("Settings")
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openSettingsScreen()
            }
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/info.png"
            name: qsTr("About")
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openAboutScreen()
            }
        }
    }
}
