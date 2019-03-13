import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

ColumnLayout {
    id: contentLayout

    property alias titleText: titleLabel.text
    property alias titleImage: titleImage.source
    property alias date: formattedDateLabel.text
    property alias descriptionText: descriptionLabel.text
    property alias splitterVisible: bottomSplitter.visible

    signal readMoreClicked()
    signal linkClicked(var url)

    anchors {
        leftMargin: 20
        rightMargin: 20
        left: parent.left
        right: parent.right
    }

    Label {
        id: formattedDateLabel
        Layout.topMargin: 20
        font.pixelSize: 13
        color: "#14a8bb"
    }

    Label {
        id: titleLabel
        Layout.fillWidth: true
        Layout.topMargin: 10
        font {
            pixelSize: 17
            bold: true
        }
        wrapMode: Label.WordWrap
        color: "#14a8bb"
    }

    Image {
        id: titleImage
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(parent.width, 150)
    }

    Label {
        id: descriptionLabel
        Layout.fillWidth: true
        wrapMode: Label.WordWrap
        textFormat: Label.RichText
        color: "#34435b"

        MouseArea {
            anchors.fill: parent
            z: descriptionLabel.z - 1
            cursorShape: descriptionLabel.hoveredLink.length !== 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                var link = descriptionLabel.linkAt(mouseX, mouseY)
                if (link.length !== 0) {
                    linkClicked(link)
                }
            }
        }
    }

    Label {
        Layout.topMargin: 10
        Layout.bottomMargin: 20
        text: qsTr("Read more")
        font.underline: mouseArea.containsMouse
        color: "#14a8bb"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: readMoreClicked()
        }
    }

    Rectangle {
        id: bottomSplitter
        Layout.fillWidth: true
        Layout.preferredHeight: 10
        color: "#dedede"
    }
}
