import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0

RoundButton {
    radius: 8
    highlighted: true
    Material.elevation: 0
    Material.accent: ColorFactory.color(DesignFactory.Foreground)
    Layout.alignment: Qt.AlignCenter
    Layout.fillWidth: true
    Layout.leftMargin: 10
    Layout.rightMargin: 10
    Layout.bottomMargin: 10
    font {
        pointSize: 11
        bold: true
        capitalization: Font.MixedCase
    }
}
