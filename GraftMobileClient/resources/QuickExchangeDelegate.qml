import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

RowLayout {
    property alias iconPath: icon.source
    property alias price: label.text

    Image {
        id: icon
        cache: false
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: height
    }

    Label {
        id: label
        color: "white"
    }
}
