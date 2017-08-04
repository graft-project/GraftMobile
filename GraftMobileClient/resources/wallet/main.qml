import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("WALLET")

    header: Header {

    }

    BalanceView {
        anchors.fill: parent
    }
//    Loader {
//      source:"balanceView.qml";
//    }
}

