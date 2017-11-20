import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

RowLayout {
    property alias icon: image.source
    property alias text: label.text
    property bool isBold: false

    Image {
        id: image
        cache: false
        Layout.maximumHeight: parent.height
        Layout.maximumWidth: height
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: label
        color: "#ffffff"
        font {
            pointSize: isBold ? 20 : 18
            bold: isBold
        }
    }
}
