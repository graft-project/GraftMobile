import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import com.device.platform 1.0
import org.graft 1.0
import "components"

BaseScreen {
    id: root

    property string logoImage
    property var acceptAction: null

    screenHeader.visible: false

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Detector.statusBarHeight()
                Layout.alignment: Qt.AlignTop
                color: ColorFactory.color(DesignFactory.IosNavigationBar)
                visible: Detector.isPlatform(Platform.IOS)
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                Layout.alignment: Qt.AlignTop
                Layout.margins: 10
                Layout.topMargin: 20
                color: "transparent"

                Image {
                    id: graftWalletLogo
                    anchors.centerIn: parent
                    height: parent.height
                    width: parent.width
                    fillMode: Image.PreserveAspectFit
                    source: logoImage
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.margins: 10
                horizontalAlignment: Qt.AlignCenter
                wrapMode: Label.WordWrap
                font.bold: true
                text: qsTr("GRAFT Payments, LLC\nEND USER LICENSE AGREEMENT")
            }

            Flickable {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.bottomMargin: 15
                ScrollBar.vertical: ScrollBar {
                    width: 5
                }
                clip: true
                contentHeight: mainText.height + additionalText.height

                Item {
                    id: licenseText
                    width: root.width - 45

                    Label {
                        id: mainText
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            leftMargin: 20
                        }

                        wrapMode: Label.WordWrap
                        text: GraftClientConstants.licenseIntroduction()
                    }

                    Label {
                        id: additionalText
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: mainText.bottom
                        }

                        wrapMode: Label.WordWrap
                        text: GraftClientConstants.licenseConditions()
                    }
                }
            }

            WideActionButton {
                id: acceptButton
                focus: true
                Layout.fillWidth: true
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: Detector.bottomNavigationBarHeight() + 15
                Layout.alignment: Qt.AlignCenter
                text: qsTr("Accept")
                KeyNavigation.tab: acceptButton
                KeyNavigation.backtab: acceptButton
                onClicked: {
                    disableScreen()
                    acceptAction()
                }
            }
        }
    }
}
