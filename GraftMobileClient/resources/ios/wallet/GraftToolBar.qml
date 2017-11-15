import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../components"

Rectangle {
    property var pushScreen

    height: 49
    color: ColorFactory.color(DesignFactory.IosNavigationBar)

    ListModel {
        id: listModel

        ListElement {
            label: qsTr("Wallet")
            image: "qrc:/imgs/walletIos.png"
            openScreen: "openMainScreen"
        }

        ListElement {
            label: qsTr("Transaction")
            image: "qrc:/imgs/transactionIos.png"
            openScreen: "openTransactionScreen"
        }

        ListElement {
            label: qsTr("Transfer")
            image: "qrc:/imgs/transferIos.png"
            openScreen: "openTransferScreen"
        }

        ListElement {
            label: qsTr("Settings")
            image: "qrc:/imgs/configIos.png"
            openScreen: "openSettingsScreen"
        }

        ListElement {
            label: qsTr("About")
            image: "qrc:/imgs/infoIos.png"
            openScreen: "openAbout"
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: listModel
        spacing: 8
        orientation: ListView.Horizontal
        clip: true
        interactive: false
        delegate: ToolBarButton {
            text: label
            source: image
            itemColor: ListView.isCurrentItem ? "#25FFFFFF" : "transparent"
            onClicked: {
                listView.currentIndex = index
                pushScreen[openScreen]()
            }
        }
    }
}
