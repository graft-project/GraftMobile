import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0

RoundButton {
    radius: 14
    topPadding: 13
    bottomPadding: 13
    highlighted: true
    Material.elevation: 0
    Material.accent: ColorFactory.color(DesignFactory.Foreground)
    Layout.alignment: Qt.AlignCenter
    Layout.fillWidth: true
    Layout.leftMargin: 40
    Layout.rightMargin: 40
    Layout.bottomMargin: 13
    font {
        family: "Liberation Sans"
        pointSize: 13
        capitalization: Font.MixedCase
    }
}
