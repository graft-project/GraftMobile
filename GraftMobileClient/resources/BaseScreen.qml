import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: basePage
    property var pushScreen
    property bool cartEnable: false
    property bool doneEnable: false
//    property bool menuState: true
    property bool qwerty: false
    property int selectedProductCount: 0


    header: Loader {
        id: buttonLoader
        source: "qrc:/Header.qml"
        onLoaded: {
            console.log(buttonLoader.item.cartEnable)
            item.headerText = basePage.title
            item.cartEnable = cartEnable
            item.doneEnable = doneEnable
            item.menuState = qwerty
            item.selectedProductCount = selectedProductCount
        }

//        Connections {
//            target: buttonLoader.item
//            onMenuIconClicked: {
//                if (qwerty) {
//                    basePage.pushScreen.showMenu()
//                } else {
//                    basePage.pushScreen.goBack()
//                }
//            }
//        }
    }

//    onMenuStateChanged: {
//        console.log(buttonLoader.item.cartEnable)
//       buttonLoader.item.menuState = menuState
//    }
}
