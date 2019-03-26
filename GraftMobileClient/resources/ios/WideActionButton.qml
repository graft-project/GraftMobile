import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0

RoundButton {
    radius: 8
    highlighted: true
    Material.elevation: 1
    Material.accent: pressed ? ColorFactory.color(DesignFactory.AndroidStatusBar) :
                               ColorFactory.color(DesignFactory.Foreground)
    font {
        pixelSize: 14
        bold: true
        capitalization: Font.MixedCase
    }
    background {
        x: 0
        width: background.parent.width
    }
}
