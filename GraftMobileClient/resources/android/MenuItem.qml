import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0

Item {
    id: rootItem

    signal itemClicked()

    property alias icon: iconItem.source
    property alias name: textItem.text
    default property alias contentItem: rootItem.data

    height: layout.height

    MouseArea {
        anchors.fill: parent
        onClicked: {
            itemClicked()
        }
    }

    RowLayout {
        id: layout
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 10

        Image {
            id: iconItem
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            Layout.alignment: Qt.AlignLeft
        }

        Text {
            id: textItem
            color: ColorFactory.color(DesignFactory.MainText)
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            font {
                bold: true
                family: "Liberation Sans"
                pointSize: 10
            }
        }
    }
}
