import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0

Item {
    property alias name: walletName
    property alias cardIcon: cardPicture.source
    property string number: walletNumber.text

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 12
        }

        Text {
            id: walletName
            text: name
            font.pointSize: 14
            Layout.alignment: Qt.AlignLeft
            color: ColorFactory.color(DesignFactory.MainText)
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight

            Image {
                id: cardPicture
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: 32
                Layout.preferredWidth: 32
                fillMode: Image.PreserveAspectFit
            }

            Text {
                id: walletNumber
                text: number
                font.pointSize: 14
                Layout.alignment: Qt.AlignRight
                color: ColorFactory.color(DesignFactory.MainText)
            }
        }
    }
}
