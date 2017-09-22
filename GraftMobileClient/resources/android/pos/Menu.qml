import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../components"

BaseMenu {
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
        }

        MenuWalletItem {
            Layout.fillWidth: true
            balanceInGraft: "1.14"
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
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/info.png"
            name: qsTr("About")
        }
    }
}
