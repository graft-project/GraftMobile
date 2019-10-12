import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
import org.navigation.attached.properties 1.0
import "components"

BaseScreen {
    id: tx_history
    
    title: qsTr("Transaction history")
        
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
        z: 1000
        
    }
    
    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        // tx history view
        ListView {
            id: txListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: TxHistoryModel
            delegate: txDelegate
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                width: 5
            }
            clip: true
        }
    }

}

