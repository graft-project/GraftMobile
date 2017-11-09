import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0

RoundButton {
    radius: 2
    highlighted: true
    Material.elevation: 1
    Material.accent: ColorFactory.color(DesignFactory.Foreground)
    Layout.alignment: Qt.AlignCenter
    Layout.fillWidth: true
    font {
        pointSize: 14
        bold: true
        capitalization: Font.AllUppercase
    }
    background {
        x: 0
        width: background.parent.width
    }
}
