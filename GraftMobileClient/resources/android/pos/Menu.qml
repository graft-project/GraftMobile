import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0
import "../"
import "../components"

BaseMenu {
    logo: "qrc:/imgs/graft_pos_logo_small.png"

    ColumnLayout {
        spacing: 18
        anchors {
            left: parent.left
            right: parent.right
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/store.png"
            name: qsTr("Store")
            onItemClicked: {
                console.log("In Store")
            }
        }

        MenuWalletItem {
            Layout.fillWidth: true
            balanceInGraft: "1.14"
        }

        Rectangle {
            id: line
            Layout.fillWidth: true
            Layout.preferredHeight: 1.5
            Layout.topMargin: 33
            Layout.alignment: Qt.AlignBottom
            color: ColorFactory.color(DesignFactory.AllocateLine)
        }

        MenuLabelItem {
            id: settingLabale
            Layout.fillWidth: true
            anchors.top: line.bottom
            anchors.topMargin: 3
            icon: "qrc:/imgs/settings.png"
            name: qsTr("Settings")
            onItemClicked: {
                console.log("In Settings")
            }
        }

        MenuLabelItem {
            Layout.fillWidth: true
            anchors.top: settingLabale.bottom
            anchors.topMargin: 18
            icon: "qrc:/imgs/info.png"
            name: qsTr("About")
            onItemClicked: {
                console.log("In About")
            }
        }
    }
}

//Rectangle {
//    color: ColorFactory.color(DesignFactory.DarkText)

//    property var pushScreen
//    property alias balanceInGraft: graftMoney.text

//    ColumnLayout {
//        spacing: 20
//        anchors {
//            left: parent.left
//            leftMargin: 20
//            right: parent.right
//            rightMargin: 20
//            top: parent.top
//        }

//        Item {
//            Layout.topMargin: 20
//            Layout.preferredHeight: 180
//            Layout.preferredWidth: parent.width

//            Image {
//                width: parent.width / 2
//                fillMode: Image.PreserveAspectFit
//                anchors.centerIn: parent
//                source: "qrc:/imgs/graft_pos_logo_small.png"
//            }
//        }

//        Text {
//            text: qsTr("STORE")
//            color: ColorFactory.color(DesignFactory.LightText)
//            Layout.alignment: Qt.AlignLeft
//            font {
//                bold: true
//                family: "Liberation Sans"
//                pointSize: 10
//            }

//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    pushScreen.hideMenu()
//                    pushScreen.backProductScreen()
//                }
//            }
//        }

//        RowLayout {
//            spacing: 0

//            Text {
//                text: qsTr("WALLET")
//                color: ColorFactory.color(DesignFactory.LightText)
//                Layout.alignment: Qt.AlignLeft
//                font {
//                    family: "Liberation Sans"
//                    pointSize: 10
//                }

//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
//                        pushScreen.hideMenu()
//                        pushScreen.openWalletScreen()
//                    }
//                }
//            }

//            Item {
//                Layout.fillWidth: true
//            }

//            Text {
//                id: graftMoney
//                color: ColorFactory.color(DesignFactory.LightText)
//                Layout.alignment: Qt.AlignRight
//                font {
//                    bold: true
//                    family: "Liberation Sans"
//                    pointSize: 10
//                }
//            }

//            Image {
//                Layout.preferredHeight: 14
//                fillMode: Image.PreserveAspectFit
//                source: "qrc:/imgs/g_icon_small.png"
//            }

//        }

//        Text {
//            text: qsTr("SETTINGS")
//            color: ColorFactory.color(DesignFactory.LightText)
//            Layout.alignment: Qt.AlignLeft
//            font {
//                family: "Liberation Sans"
//                pointSize: 10
//            }
//        }
//    }
//}
