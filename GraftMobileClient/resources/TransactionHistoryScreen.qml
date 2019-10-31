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
        
    // Delegate to display transaction in listview
    Component {
        id: txDelegate    
        
        Item {
            height: tx_history.height / 8
            width: parent.width

            RowLayout {
                id: txViewItem
                spacing: 5
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                
                // direction icon
                Image {
                    width: parent.width / 7
                    Layout.leftMargin: 15
                    Layout.rightMargin: 10
                    source: direction === TransactionInfo.In ? "imgs/incoming_tx_arrow.png"
                                                             : "imgs/outgoing_tx_arrow.png"
                    
                }
                
                // tx_id + status + timestamp
                Column {
                    width: parent.width / 2 + 20
                    // tx_id
                    Text {
                        text: hash
                        width: parent.width
                        elide: Qt.ElideMiddle
                    }
                    // complete / incomplete / failed
                    Text {
                        text: status === TransactionInfo.Completed ? 
                                  qsTr("Completed - Block height: ") + blockHeight
                                : status === TransactionInfo.Pending ? 
                                  qsTr("Pending transaction")
                                : qsTr("Failed transaction")
                        
                        
                    }
                    // timestamp
                    Text {
                        text: timeStamp
                    }
                }
                
                // Amount + fee
                Column {
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    width: parent.width / 3 - 50
                    
                    
                    Text {
                        text: (direction === TransactionInfo.In ? "+ " : "- ") + "GRFT " + amount
                        color: (direction === TransactionInfo.In ? "#4FB67A" : "#FC581F")
                        horizontalAlignment: Text.AlignRight
                        width: parent.width
                        anchors.right: parent.right
                    }
                    Text {
                        text: qsTr("Fee: ") + fee
                        color: (direction === TransactionInfo.In ? "#4FB67A" : "#FC581F")
                        horizontalAlignment: Text.AlignRight
                        width: parent.width
                        anchors.right: parent.right
                    }
                   
                }
            }
            Rectangle {
                height: 1
                width: parent.width
                color: "lightgray"
                anchors.top: parent.bottom
            }

            MouseArea {
                id: clickArea;
                anchors.fill: parent
                onClicked: {
                    console.log("Clicked on: ", index)
                    pushScreen.openTransactionDetailsScreen(transaction);
                    
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
            Layout.maximumWidth: tx_history.width
            model: TxHistoryModel
            delegate: txDelegate
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                width: 5
            }
            clip: true
            Component.onCompleted: {
                console.log("width: " + width)
            }
        }
    }

}

