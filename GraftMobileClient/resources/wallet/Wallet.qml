import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0

RowLayout {
    property string name: walletName.text
    property string number: walletNumber.text

    Layout.preferredWidth: parent.width

    Text {
        id: walletName
        Layout.alignment: Qt.AlignLeft
        color: ColorFactory.color(DesignFactory.LightText)
        font {
            family: "Liberation Sans"
            pointSize: 12
        }
        text: qsTr(name)
    }

    Text {
        id: walletNumber
        Layout.alignment: Qt.AlignRight
        color: ColorFactory.color(DesignFactory.LightText)
        font {
            family: "Liberation Sans"
            pointSize: 12
        }
        text: qsTr(number)
    }
}
