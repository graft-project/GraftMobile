import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0

Pane {
    id: root

    Material.elevation: Qt.platform.os === "android" ? 6 : 0
    padding: 0
    contentItem: Rectangle {
        color: ColorFactory.color(DesignFactory.CircleBackground)

        ListModel {
            id: listModel

            ListElement {
                col: "red"
                name: "Dollars"
            }

            ListElement {
                col: "black"
                name: "Bitcoin"
            }

            ListElement {
                col: "blue"
                name: "DoggyCoin"
            }

            ListElement {
                col: "yellow"
                name: "AAAACoin"
            }

            ListElement {
                col: "white"
                name: "BBBBCoin"
            }
            ListElement {
                col: "white"
                name: "GGGGCoin"
            }
            ListElement {
                col: "white"
                name: "FFFFCoin"
            }
        }

        PathView {
            id: pathView
            height: parent.height
            width: parent.width
            pathItemCount: 4
            model: listModel

            delegate: QuickExchangeDelegate {
                height: pathView.height / 2
                width: pathView.width
                iconPath: "qrc:/imgs/configIos.png"
                price: name
            }

            highlightRangeMode: PathView.StrictlyEnforceRange
            snapMode: PathView.NoSnap
            clip: true
            path: Path {
                startX: -50; startY: root.height / 2
                PathLine { x: pathView.width + 50; y: root.height / 2; }
            }
        }
    }
}
