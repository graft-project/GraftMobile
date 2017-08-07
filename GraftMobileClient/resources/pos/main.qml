import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 320
    height: 480
    title: qsTr("POS")

    ProductScreen {
        anchors.fill: parent
    }
}
