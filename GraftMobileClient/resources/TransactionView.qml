import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
import org.navigation.attached.properties 1.0
import "components"

BaseScreen {
    id: txInfo

//    property alias accountName: coinAccountDelegate.accountTitle
//    property alias accountImage: coinAccountDelegate.productImage
//    property alias accountBalance: coinAccountDelegate.accountBalance
    property string accountNumber: ""
    property string accountType: ""
    property object  transaction
    
    title: qsTr("Transaction details")

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            navigationText: qsTr("Cancel")
            background.color = "#ffffff"
        }
    }

 

    ColumnLayout {
        spacing: 0
        anchors.fill: parent
        // tx_id
        Text {
            id: tx_id
            text: "tx id: cda0bb95f9398d3d3acd7bc42a...545d91573bf7622f7335de7ee87"
        }
        Text {
            text: "timestamp: 2019-07-07T16:52:51"
        }
        Text {
            text: "direction: Out [In]"
        }

        Text {
            text: "status: Completed [Pending|Failed]"
        }
        Text {
            text: "block height: 369556"
        }

        Text {
            text: "amount: 50210.9831"
        }
        
        Text {
            text: "Destinations: \n" + 
                  "(here can be mulitple lines with transfers. \nonly visible for Out transactions)\n" +
                  "\n\tG482HyYZGS7Uvaak...7ftzUZXxMibLd5myyj: 10233.122" +
                  "\n\tG482HyYZGS7Uvaak...7ftzUZXxMibLd5myyj: 39977.8610"
        }
        
        Text {
            text: "fee: 1.012"
        }
        
        Text {
            text: "payment id: 01234567890 (optional, can be empty)"
        }
     

    }

//    states: [
//        State {
//            name: "mainAddress"

//            PropertyChanges {
//                target: balance
//                title: qsTr("Main Account")
//            }
//            PropertyChanges {
//                target: mainBalance
//                visible: true
//                balanceVisible: false
//            }

//            PropertyChanges {
//                target: coinAccountDelegate
//                visible: false
//            }
//            PropertyChanges {
//                target: address
//                text: GraftClient.address()
//            }
//            PropertyChanges {
//                target: qrCodeImage
//                source: GraftClient.addressQRCodeImage()
//            }
//        },

//        State {
//            name: "coinsAddress"

//            PropertyChanges {
//                target: balance
//                title: qsTr("%1 Account").arg(accountType)
//            }
//            PropertyChanges {
//                target: mainBalance
//                visible: false
//            }
//            PropertyChanges {
//                target: coinAccountDelegate
//                coinVisible: false
//                visible: true
//            }
//            PropertyChanges {
//                target: address
//                text: accountNumber
//            }
//            PropertyChanges {
//                target: qrCodeImage
//                source: GraftClient.coinAddressQRCodeImage(accountNumber)
//            }
//        }
//    ]
}
