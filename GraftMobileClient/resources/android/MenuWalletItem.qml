import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0

Item {
    id: rootItem

    signal itemClicked()

//    property alias name: textItem.text
    default property alias contentItem: rootItem.data
    property alias balanceInGraft: graftMoney.text


    MouseArea {
        anchors.fill: parent
        onClicked: {
            itemClicked()
        }
    }

    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 5
            rightMargin: 5
        }
        spacing: 0

        MenuItem {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Wallet")
//            source: "qrc:/imgs/waller.png"
        }

//        Image {
//            Layout.preferredHeight: 25
//            Layout.preferredWidth: 25
//            Layout.alignment: Qt.AlignLeft
//            source: "qrc:/imgs/waller.png"
//        }

//        Text {
//            id: textItem
//            color: ColorFactory.color(DesignFactory.MainText)
//            Layout.fillWidth: true
//            Layout.alignment: Qt.AlignLeft
//            font {
//                bold: true
//                family: "Liberation Sans"
//                pointSize: 10
//            }
//        }

        Text {
            id: graftMoney
            color: ColorFactory.color(DesignFactory.MainText)
            Layout.alignment: Qt.AlignRight
            font {
                bold: true
                family: "Liberation Sans"
                pointSize: 10
            }
        }

        Image {
            Layout.preferredHeight: 15
            Layout.preferredWidth: 15
            Layout.alignment: Qt.AlignRight
//            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/g-min.png"

//            Rectangle {
//                anchors.fill: parent
//                color: "red"
//            }
        }
    }
}
