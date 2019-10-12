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
    property QtObject transaction
    
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
            text: "id: " + transaction.hash.toString()
        }
        Text {
            text: "timestamp: " + transaction.timestamp.toString()
        }
        Text {
            text: "direction: " + transaction.direction.toString()
        }

        Text {
            text: "status: " + transaction.status.toString()
        }
        Text {
            text: "block height: " + transaction.blockHeight.toString()
        }

        Text {
            text: "amount: " + transaction.amount.toString()
        }
        
        Text {
            text: "Destinations: \n" + transaction.destinations_formatted.toString()
                  
        }
        
        Text {
            text: "fee: " + transaction.fee
        }
        
        Text {
            text: "payment id: " + transaction.paymentId
        }
     

    }
}
