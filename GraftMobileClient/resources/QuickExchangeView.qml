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

        PathView {
            id: pathView
            anchors.fill: parent
            pathItemCount: 3
            offset: 1.5
            model: QuickExchangeModel

            delegate: QuickExchangeDelegate {
                id: quickExchangeDelegate
                height: pathView.height / 2
                icon: iconPath
                text: price
                isBold: primary
            }

            highlightRangeMode: PathView.StrictlyEnforceRange
            snapMode: PathView.NoSnap
            clip: true
            path: Path {
                startX: -50
                startY: root.height / 2
                PathLine {
                    x: pathView.width + 50
                    y: root.height / 2
                }
            }
        }
    }
}
