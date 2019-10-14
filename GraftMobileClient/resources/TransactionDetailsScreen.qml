import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
import org.navigation.attached.properties 1.0
import "components"

BaseScreen {
    id: txInfo
    property QtObject transaction
    title: qsTr("Transaction details")

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            navigationText: qsTr("Cancel")
            background.color = "#ffffff"
        }
    }
    
    function printableTxStatus(status) {
        switch (status) {
        case TransactionInfo.Completed:
            return qsTr("Completed")
        case TransactionInfo.Pending:
            return qsTr("Pending")
        case TransactionInfo.Failed:
            return qsTr("Failed")
        }
    }
    
    ColumnLayout {
        id: rootLayout
        spacing: 0
        anchors.fill: parent
        property color backgroundInColor: "#0A4FB67A"
        property color foregroundInColor: "#FF4FB67A"
        property color backgroundOutColor: "#0AFC581F"
        property color foregroundOutColor: "#FFFC581F"
        
        // amount
        Rectangle {
           width: parent.width
           color: (transaction.direction === TransactionInfo.In ? rootLayout.backgroundInColor : rootLayout.backgroundOutColor)
           Layout.fillHeight: true
           Layout.maximumHeight: 60
           Text {
               anchors.centerIn: parent
               font.pointSize: 16
               text:  (transaction.direction === TransactionInfo.In ? "+ " : "- ") + "GRFT " + transaction.amount
               color: (transaction.direction === TransactionInfo.In ? rootLayout.foregroundInColor : rootLayout.foregroundOutColor)
           }
        }
        // delimiter
        Rectangle {
            height: 1
            width: parent.width
            color: "lightgray"
            anchors.topMargin: 1
        }
        
        Column {
            Layout.maximumHeight: 45
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            spacing: 2
            Text {
                text: transaction.timestamp.toString()
                font.bold: true
            }
            
            Text {
                id: tx_id
                text: "TX ID: " + transaction.hash.toString()
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log(transaction.hash.toString())
                    }
                }
            }
            
          
        }
        // delimiter
        Rectangle {
            height: 1
            width: parent.width
            color: "lightgray"
            anchors.topMargin: 1
        }
        Column {
            Layout.maximumHeight: 45
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            spacing: 2
            Text {
                text: qsTr("Block height: ") + transaction.blockHeight.toString()
            }
            
            Text {
                text: qsTr("Fee: ") + transaction.fee
            }
            
            Text {
                text: qsTr("Status: ") + txInfo.printableTxStatus(transaction.status)
            }
            
            Item {
                width: 1
                height: 20
            }
            
            Text {
                text: qsTr("Destinations: \n") + transaction.destinations_formatted.toString()
            }
            
            Item {
                width: 1
                height: 20
            }
            
            Text {
                text: qsTr("Payment ID: ") + transaction.paymentId
            }
                        
        }
        Item {
            Layout.fillHeight: true
        }
        
        

    }
}
