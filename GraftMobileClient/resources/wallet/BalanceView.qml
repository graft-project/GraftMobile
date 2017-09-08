import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../"
import "../components"

BaseScreen {
    id: rootItem
    title: qsTr("Wallet")

    property real amountGraft: 0
    property real amountMoney: 0

    ColumnLayout {
        anchors.fill: parent
        spacing: 30

        Image {
            id: graftWalletLogo
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 50
            Layout.preferredHeight: parent.width / 2
            Layout.preferredWidth: parent.width / 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/graft_wallet_logo.png"
        }

        ColumnLayout {
            spacing: 20
            Layout.alignment: Qt.AlignCenter

            Text {
                text: qsTr("Balance:")
                Layout.alignment: Qt.AlignCenter
                color: ColorFactory.color(DesignFactory.MainText)
                font {
                    pointSize: 18
                }
            }

            RowLayout {
                spacing: 0
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: amountGraft
                    color: ColorFactory.color(DesignFactory.DarkText)
                    font.pointSize: 25
                }

                Image {
                    Layout.preferredHeight: 25
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/g_icon_black.png"
                }
            }

            Text {
                text: amountMoney + "USD"
                Layout.alignment: Qt.AlignCenter
                color: ColorFactory.color(DesignFactory.MainText)
                font {
                    pointSize: 18
                }
            }
        }

        WideRoundButton {
            text: qsTr("PAY")
            onPressed: {
                pushScreen.openQRCodeScanner()
            }
        }
    }
}
