import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

RowLayout {
    property alias icon: image.source
    property alias text: label.text
    property alias isBold: label.font.bold

    Image {
        id: image
        cache: false
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: height
    }

    Label {
        id: label
        color: "#ffffff"
    }
}
