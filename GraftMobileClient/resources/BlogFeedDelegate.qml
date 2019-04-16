import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.device.platform 1.0
import "components"

Pane {
    id: contentLayout

    property alias titleText: titleLabel.text
    property alias titleImage: titleImage.source
    property alias descriptionText: descriptionLabel.text

    signal readMoreClicked()
    signal linkClicked(var url)

    padding: 0
    Material.elevation: 6
    height: mainLayout.implicitHeight

    contentItem: Rectangle {
        ColumnLayout {
            id: mainLayout
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Image {
                id: titleImage
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(parent.width, 150)
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.rightMargin: 12
                Layout.leftMargin: 12

                Label {
                    id: titleLabel
                    Layout.topMargin: 7
                    Layout.fillWidth: true
                    wrapMode: Label.WordWrap
                    font.bold: true
                    color: "#000000"
                }

                Label {
                    id: descriptionLabel
                    Layout.bottomMargin: 12
                    Layout.fillWidth: true
                    Layout.topMargin: 7
                    wrapMode: Label.WordWrap
                    elide: Label.ElideRight
                    maximumLineCount: 3
                    color: "#000000"

                    MouseArea {
                        anchors.fill: parent
                        z: descriptionLabel.z - 1
                        cursorShape: descriptionLabel.hoveredLink.length !== 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            var link = descriptionLabel.linkAt(mouseX, mouseY)
                            if (link.length !== 0) {
                                linkClicked(link)
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.bottomMargin: 12
                    Layout.preferredHeight: 35
                    Layout.alignment: Qt.AlignCenter | Qt.AlignBottom
                    radius: Detector.isPlatform(Platform.Android) ? 3 : 6
                    border.color: "#324259"
                    color: "#FFFFFF"

                    Label {
                        anchors.centerIn: parent
                        font {
                            pixelSize: 14
                            bold: true
                        }
                        color: "#34435B"
                        text: qsTr("Read more")
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: readMoreClicked()
                    }
                }
            }
        }
    }
}
