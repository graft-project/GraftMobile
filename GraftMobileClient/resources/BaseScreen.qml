import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: basePage
    property var pushScreen
    property alias cartEnable: baseHeader.cartEnable
    property alias isMenuState: baseHeader.isMenuState

    header: Header {
        id: baseHeader
        headerText: basePage.title
        cartEnable: false
        pushScreen: basePage.pushScreen
    }
}
