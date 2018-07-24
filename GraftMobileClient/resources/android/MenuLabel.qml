import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0

Rectangle {
    property alias icon: iconItem.source
    property alias name: textItem.text

    color: "transparent"

    RowLayout {
        spacing: 24
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        Image {
            id: iconItem
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            Layout.alignment: Qt.AlignLeft
        }

        Label {
            id: textItem
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            color: ColorFactory.color(DesignFactory.MainText)
            font {
                bold: true
                family: "Liberation Sans"
                pixelSize: 15
            }
        }
    }
}
