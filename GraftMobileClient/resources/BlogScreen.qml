import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtWebView 1.1
import com.device.platform 1.0
import "components"

BaseScreen {
    id: blogScreen

    Connections {
        target: GraftClient

        onBlogFeedPathChanged: {
            webView.url = path
        }
    }

    title: qsTr("Blog")
    screenHeader {
        isNavigationButtonVisible: false
        navigationButtonState: false
        actionButtonState: false
    }
    specialBackMode: hideWebView

    WebView {
        id: webView
        anchors.fill: parent

        onUrlChanged: {
            if (url.toString().includes("blog")) {
                blogScreen.screenHeader.isNavigationButtonVisible = true
                blogScreen.screenHeader.navigationButtonState = !Detector.isPlatform(Platform.Android)
            } else {
                blogScreen.screenHeader.isNavigationButtonVisible = Detector.isPlatform(Platform.Android)
                blogScreen.screenHeader.navigationButtonState = Detector.isPlatform(Platform.Android)
            }
        }
    }

    ListView {
        id: listView
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        model: FeedModel
        spacing: 3
        clip: true

        delegate: Item {
            height: contentLayout.height
            width: parent.width

            ColumnLayout {
                id: contentLayout
                anchors {
                    leftMargin: 20
                    rightMargin: 20
                    left: parent.left
                    right: parent.right
                }

                Label {
                    Layout.topMargin: 20
                    text: formattedDate
                    font.pixelSize: 13
                    color: "#14a8bb"
                }

                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: 10
                    font {
                        pixelSize: 17
                        bold: true
                    }
                    wrapMode: Label.WordWrap
                    color: "#14a8bb"
                    text: title
                }

                Image {
                    id: titleImage
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(parent.width, 150)
                    source: image
                }

                Label {
                    id: descriptionLabel
                    Layout.fillWidth: true
                    wrapMode: Label.WordWrap
                    textFormat: Label.RichText
                    text: description
                    color: "#34435b"
                }

                Label {
                    Layout.topMargin: 10
                    Layout.bottomMargin: 20
                    text: qsTr("Read more")
                    font.underline: mouseArea.containsMouse
                    color: "#14a8bb"

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: showWebView(fullFeedPath)
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 10
                    visible: index !== listView.count - 1
                    color: "#dedede"
                }
            }
        }
    }

    function showWebView(url) {
        webView.url = url
        webView.visible = true
        listView.visible = false
    }

    function hideWebView() {
        webView.url = "file:///"
        webView.visible = false
        listView.visible = true
    }
}
