import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0

Item {
    id: rootItem

    signal itemClicked()
    default property alias contentItem: rootItem.data
    property alias balanceInGraft: graftMoney.text

    MouseArea {
        anchors.fill: parent
        onClicked: {
            itemClicked()
            console.log("in Wallet")
        }
    }

    MenuLabelItem {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        name: qsTr("Wallet")
        icon: "qrc:/imgs/waller.png"
    }

    RowLayout {
        spacing: 3
        anchors {
            right: parent.right
            rightMargin: 10
            top: parent.top
            topMargin: 10
        }

        Text {
            id: graftMoney
            color: ColorFactory.color(DesignFactory.MainText)
            Layout.alignment: Qt.AlignRight
            font {
                bold: true
                family: "Liberation Sans"
                pointSize: 15
            }
        }

        Image {
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            Layout.alignment: Qt.AlignRight
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/g-min.png"
        }
    }
}
