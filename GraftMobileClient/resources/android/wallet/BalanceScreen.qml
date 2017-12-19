import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    id: balanceScreen

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        CoinListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        AddNewButton {
            buttonTitle: qsTr("Add new account")
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.bottomMargin: 15
            topLine: true
            bottomLine: true
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            text: qsTr("PAY")
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            onClicked: pushScreen.openMnemomicViewScreen()
        }
    }
}
