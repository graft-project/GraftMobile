import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
import org.navigation.attached.properties 1.0
import "components"

BaseScreen {
    id: balance

    property string balanceState: "mainAddress"
    property alias accountName: coinAccountDelegate.accountTitle
    property alias accountImage: coinAccountDelegate.productImage
    property alias accountBalance: coinAccountDelegate.accountBalance
    property string accountNumber: ""
    property string accountType: ""

    state: balanceState
    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            navigationText: qsTr("Cancel")
            background.color = "#ffffff"
        }
    }

    // Delegate to display transaction in listview
    
    Component {
        id: txDelegate
        Item {
            width: parent.width;
            height: 80
            Column {
                width: parent.width
                spacing: 10 
               
                Flow {
                    width: parent.width
                    spacing: 2
                    id: txView
                    Text {
                        id: hashField;
                        text: 'id: <b>' + hash + '</b>'
                        elide: Text.ElideMiddle
                        width: parent.width
                    }
                    
                    Text {
                        text: 'Height: <b>'  + blockHeight + '</b>'
                    }
                    
                    Text {
                        text: 'TimeStamp: <b>'  + timeStamp + '</b>'
                    }
                    
                    
                    Text {
                        text: 'Direction: <b>'  + direction.toString() + '</b>'
                    }
                    Text {
                        text: 'Status: <b>' + status.toString() + '</b>'
                    }
    
                    Text {
                        text: 'Amount: <b>'  + amount + '</b>'
                    }
                    
                    Text {
                        text: 'Fee: <b>'  + fee + '</b>'
                    }
                    
                    Text {
                        text: 'PaymentID: <b>' + paymentId + '</b>'
                    }
                }
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "gray"
                }
                
            }

          
            MouseArea {
                id: clickArea;
                anchors.fill: parent;
                onClicked: {
                    console.log("Clicked on: ", index)
                    console.log("pushscreen: " + pushScreen)
                    pushScreen.openTransactionInfoScreen(transaction);
                }
            }
        }
    }
    
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        width: 60
        height: 60
        running: GraftClient.updatingTransactions
    }
    
    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        BalanceViewItem {
            id: mainBalance
            visible: false
            Layout.fillWidth: true
            unlockedBalance: GraftClient.balance(GraftClientTools.UnlockedBalance)
            totalBalance: GraftClient.balance(GraftClientTools.LockedBalance)
            height: 80
        }
        


        CoinAccountDelegate {
            id: coinAccountDelegate
            visible: false
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            topLineVisible: false
            bottomLineVisible: false
        }
        

        // tx history view
        ListView {
            id: txListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: TxHistoryModel
            delegate: txDelegate
            visible: mainBalance.checked
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                width: 5
            }
            clip: true
        }
        // qr code view
        ColumnLayout {
            id: qrCodeView
            visible: !mainBalance.checked
            Rectangle {
                id: background
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#e9e9e9"

                Image {
                    id: qrCodeImage
                    cache: false
                    height: (parent.height > parent.width ? parent.width : parent.height) - 20
                    width: height
                    anchors.centerIn: parent

                    PopupMessageLabel {
                        id: walletAddressLabel
                        anchors.centerIn: parent
                        labelText: qsTr("Wallet address is copied!")
                    }
                }
            }

            Rectangle {
                color: "#ffffff"
                Layout.fillWidth: true
                Layout.preferredHeight: 144

                ColumnLayout {
                    spacing: 0
                    anchors {
                        fill: parent
                        leftMargin: 15
                        rightMargin: 15
                        bottomMargin: 15
                    }

                    Label {
                        id: address
                        Layout.fillWidth: true
                        Layout.topMargin: Detector.isPlatform(Platform.Android) ? 15 : 0
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Layout.alignment: Qt.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAnywhere
                        color: "#010101"
                        font {
                            bold: true
                            pixelSize: 16
                        }
                    }

                    WideActionButton {
                        id: clipboardButton
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
                        text: qsTr("Copy to clipboard")
                        KeyNavigation.tab: balance.Navigation.implicitFirstComponent
                        onClicked: {
                            GraftClientTools.copyToClipboard(balanceState === "mainAddress" ?
                                                             GraftClient.address() : accountNumber)
                            walletAddressLabel.opacity = 1.0
                            walletAddressLabel.timer.start()
                        }
                    }
                }
            }
        }

    }

    states: [
        State {
            name: "mainAddress"

            PropertyChanges {
                target: balance
                title: qsTr("Main Account")
            }
            PropertyChanges {
                target: mainBalance
                visible: true
                balanceVisible: false
            }

            PropertyChanges {
                target: coinAccountDelegate
                visible: false
            }
            PropertyChanges {
                target: address
                text: GraftClient.address()
            }
            PropertyChanges {
                target: qrCodeImage
                source: GraftClient.addressQRCodeImage()
            }
        },

        State {
            name: "coinsAddress"

            PropertyChanges {
                target: balance
                title: qsTr("%1 Account").arg(accountType)
            }
            PropertyChanges {
                target: mainBalance
                visible: false
            }
            PropertyChanges {
                target: coinAccountDelegate
                coinVisible: false
                visible: true
            }
            PropertyChanges {
                target: address
                text: accountNumber
            }
            PropertyChanges {
                target: qrCodeImage
                source: GraftClient.coinAddressQRCodeImage(accountNumber)
            }
        }
    ]
}
