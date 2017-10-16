import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: basePage
    property var pushScreen
    property var action
    property alias screenHeader: appHeader

    header: Header {
        id: appHeader
        headerText: basePage.title

        onNavigationButtonClicked: {
            basePage.pushScreen.goBack()
        }

        onActionButtonClicked: {
            action()
        }
    }
}
