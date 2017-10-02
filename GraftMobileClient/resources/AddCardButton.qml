import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Button {
    property alias imageSource: image.source
    property alias imageVisible: image.visible
    property alias textItem: text

    flat: true
    leftPadding: 0
    rightPadding: 0

    contentItem: RowLayout {
        spacing: 10

        Image {
            id: image
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            Layout.alignment: Image.AlignLeft
        }

        Text {
            id: text
            Layout.alignment: Text.AlignLeft
        }
    }
}
