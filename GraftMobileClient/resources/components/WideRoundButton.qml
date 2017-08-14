import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

RoundButton {
    radius: 14
    topPadding: 10
    bottomPadding: 10
    highlighted: true
    Material.elevation: 0
    Material.accent: "#757575"
    Layout.alignment: Qt.AlignCenter
    Layout.fillWidth: true
    Layout.leftMargin: 40
    Layout.rightMargin: 40
    Layout.bottomMargin: 10
    font {
        family: "Liberation Sans"
        pointSize: 13
        capitalization: Font.MixedCase
    }
}
