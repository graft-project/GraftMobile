import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import com.graft.design 1.0

Rectangle {
    color: ColorFactory.color(DesignFactory.Foreground)

    signal menuIconClicked()
    signal menuDoneClicked()

    property string headerText
    property bool menuState
    property bool cartEnable
    property bool doneEnable
    property int selectedProductCount
}
