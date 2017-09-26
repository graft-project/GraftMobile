import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseScreen {
    id: additionItem
    title: qsTr("Add")
    screenHeader {
        navigationButtonState: false
    }

    property alias currencyModel: productItem.currencyModel

    ColumnLayout {
        spacing: 3
        anchors {
            fill: parent
            topMargin: 55
            bottomMargin: 20
            leftMargin: 20
            rightMargin: 20
        }

        ProductItemView {
            id: productItem
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter

            RoundButton {
                id: addButton
                padding: 25
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 80
                Layout.preferredWidth: 80
                highlighted: true
                Material.elevation: 0
                Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
                contentItem: Image {
                    source: "qrc:/imgs/plus_icon.png"
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("ADD PHOTO")
                color: ColorFactory.color(DesignFactory.MainText)
                font {
                    family: "Liberation Sans"
                    pointSize: 10
                }
            }
        }

        WideActionButton {
            text: qsTr("Confirm")
            onClicked: {
                ProductModel.add("", title.text,
                                 parseFloat(price.text), graftCBox.currentText)
                additionItem.pushScreen.openProductScreen()
                GraftClient.save()
            }
        }
    }
}
