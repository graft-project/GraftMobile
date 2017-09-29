import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import com.graft.design 1.0

SwipeDelegate {
    id: root

    signal removeItemClicked()
    signal editItemClicked()

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

    onClicked: {
        ProductModel.changeSelection(index)
        swipe.close()
    }

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
            visible: true
            enabled: false
            checked: selectState
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
        }
    }

    swipe.onPositionChanged: checkBox.visible = false
    swipe.onClosed: checkBox.visible = true
    swipe.right: RowLayout {
        width: 90
        spacing: 0
        enabled: root.swipe.complete
        height: parent.height
        anchors.right: parent.right

        Rectangle {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width / 2
            color: "#e5e7ea"

            Image {
                height: parent.height / 3
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                source: "qrc:/imgs/edit.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    editItemClicked()
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width / 2
            color: ColorFactory.color(DesignFactory.CartLabel)

            Image {
                height: parent.height / 3
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                source: "qrc:/imgs/delete.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    removeItemClicked()
                }
            }
        }
    }
}
