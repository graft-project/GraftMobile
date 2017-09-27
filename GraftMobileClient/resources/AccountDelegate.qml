import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0

Item {
    property alias nameItem: walletName
    property alias cardIcon: cardPicture.source
    property alias number: walletNumber.text

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 12
        }

        Text {
            id: walletName
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
                font.pointSize: 14
                Layout.alignment: Qt.AlignRight
                color: ColorFactory.color(DesignFactory.MainText)
            }
        }
    }
}
