import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../"

SwipeDelegate {
    id: root

    property bool selectState: false
    property alias productPriceTextColor: selectedProductDelegate.productPriceTextColor
    property alias productText: selectedProductDelegate.productText
    property alias lineTopVisible: selectedProductDelegate.lineTopVisible
    property alias lineBottomVisible: selectedProductDelegate.lineBottomVisible
    property alias productImage: selectedProductDelegate.productImage
    property alias productPrice: selectedProductDelegate.productPrice

    padding: 0
    topPadding: 0
    bottomPadding: 0
    focusPolicy: Qt.ClickFocus
    onActiveFocusChanged: {
        if (!focus || root.swipe.complete) {
            swipe.close()
        }
    }

    swipe.onPositionChanged: checkBox.visible = false
    swipe.onClosed: checkBox.visible = true

    SelectedProductDelegate {
        id: selectedProductDelegate

        // TODO: QTBUG-50992. QQC2: Object destroyed during incubation.
        // For more details see https://bugreports.qt.io/browse/QTBUG-50992
        x: contentItem.x
        y: contentItem.y
        z: contentItem.z
        width: contentItem.width
        height: contentItem.height
        color: selectState ? ColorFactory.color(DesignFactory.Highlighting) : "transparent"

        CheckBox {
            id: checkBox
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            Material.elevation: 0
            Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
            visible: true
            checked: selectState
        }
    }

    onClicked: {
        ProductModel.changeSelection(index)
        swipe.close()
    }

    swipe.right: Component {
        RowLayout {
            width: 90
            spacing: 0
            enabled: root.swipe.complete
            height: parent.height
            anchors.right: parent.right

            Rectangle {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width / 2
                color: ColorFactory.color(DesignFactory.AllocateLine)

                Image {
                    anchors.centerIn: parent
                    height: parent.height / 3
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/edit.png"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("PAINT!!!")
                    }
                }
            }

            Rectangle {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width / 2
                color: ColorFactory.color(DesignFactory.CartLabel)

                Image {
                    anchors.centerIn: parent
                    height: parent.height / 3
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/delete.png"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("DELETE!!!")
                    }
                }
            }
        }
    }
}
