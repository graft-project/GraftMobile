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
            height: 55
            width: parent.width
            Component.onCompleted: {
                console.log("Root item width: ", width)
            }

            RowLayout {
                id: txViewItem
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                spacing: 5
                Layout.maximumWidth: parent.width - 10
                
                // direction icon
                Image {
                    Layout.leftMargin: 5
                    source: direction === TransactionInfo.In ? "imgs/incoming_tx_arrow.png"
                                                             : "imgs/outgoing_tx_arrow.png"
                    
                }
                
                // tx_id + status + timestamp
                Column {
                    // tx_id
                    Text {
                        text: hash
                        width: 240
                        elide: Qt.ElideMiddle
                        Component.onCompleted: {
                            console.log("width: ", width, " rowLayout width: ", txViewItem.width, " column width: ", parent.width)
                        }
                    }
                    // complete / incomplete / failed
                    Text {
                        text: status === TransactionInfo.Completed ? 
                                  qsTr("Completed - Block height: ") + blockHeight
                                : status === TransactionInfo.Pending ? 
                                  qsTr("Pending transaction")
                                : qsTr("Failed transaction")
                        
                        Component.onCompleted: {
                            console.log("width: ", width, " rowLayout width: ", txViewItem.width)
                        }
                    }
                    // timestamp
                    Text {
                        
                        text: timeStamp
                    }
                }
                
                // Amount + fee
                Column {
                    Layout.leftMargin: 1
                    // Layout.topMargin: 20
                    Text {
                        text: (direction === TransactionInfo.In ? "+ " : "- ") + "GRFT " + amount
                        color: (direction === TransactionInfo.In ? "#4FB67A" : "#FC581F")
                    }
                    Text {
                        text: qsTr("Fee: ") + fee
                        color: (direction === TransactionInfo.In ? "#4FB67A" : "#FC581F")
                    }
                }
            }
            Rectangle {
                height: 1
                width: parent.width
                color: "lightgray"
                anchors.top: txViewItem.bottom 
                anchors.topMargin: 1
                
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
    
//    Component {
//        id: txDelegate
//        Row {
//            id: txViewItem
//            width: parent.width;
//            height: 80
            
//            // direction icon
//            Image {
//                source: "imgs/incoming_tx_arrow.png"
//            }
//            // tx_id + status + timestamp
//            Column {
//                width: txViewItem.width / 2
//                // tx_id
//                Text {
//                    text: hash
//                }
//                // complete / incomplete / failed
//                Text {
//                    text: status === TransactionInfo.Completed ? 
//                              qsTr("Completed - Block height: ") + blockHeight
//                            : status === TransactionInfo.Pending ? 
//                              qsTr("Pending transaction")
//                            : qsTr("Failed transaction")
//                }
//                // timestamp
//                Text {
//                    text: timeStamp
//                }
//            }
            
//            // Amount + fee
//            Column {
//                width: txViewItem / 3
//                Text {
//                    text: (direction === TransactionInfo.In ? "+ " : "- ") + "GRFT " + amount
//                    color: (direction === TransactionInfo.In ? "#4FB67A" : "#FC581F")
//                }
//                Text {
//                    text: qsTr("Fee: ") + amount
//                    color: (direction === TransactionInfo.In ? "#4FB67A" : "#FC581F")
//                }
//            }
            
//            MouseArea {
//                id: clickArea;
//                anchors.fill: parent;
//                onClicked: {
//                    console.log("Clicked on: ", index)
//                    console.log("pushscreen: " + pushScreen)
//                    pushScreen.openTransactionInfoScreen(transaction);
//                }
//            }
//        }
//    }
    
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

