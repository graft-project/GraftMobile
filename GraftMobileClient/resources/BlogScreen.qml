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
        isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
        navigationButtonState: Detector.isPlatform(Platform.Android)
        actionButtonState: false
    }
    specialBackMode: {
        hideWebView
    }

    ProgressBar {
        id: progressBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 5
        from: 0.0
        to: 100.0
        visible: webView.visible
        value: webView.loadProgress
        onValueChanged: height = value !== to ? 5 : 0
    }

    WebView {
        id: webView
        anchors {
            top: progressBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        visible: false
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

                    MouseArea {
                        anchors.fill: parent
                        z: descriptionLabel.z - 1
                        cursorShape: descriptionLabel.hoveredLink.length !== 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            var link = descriptionLabel.linkAt(mouseX, mouseY)
                            if (link.length !== 0) {
                                showWebView(link)
                            }
                        }
                    }
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

    states: [
        State {
            name: "showWebView"
            PropertyChanges {
                target: webView
                visible: true
            }
            PropertyChanges {
                target: listView
                visible: false
            }
            PropertyChanges {
                target: blogScreen.screenHeader
                isNavigationButtonVisible: true
                navigationButtonState: !Detector.isPlatform(Platform.Android)
            }
        },
        State {
            name: "hideWebView"
            PropertyChanges {
                target: webView
                visible: false
            }
            PropertyChanges {
                target: listView
                visible: true
            }
            PropertyChanges {
                target: blogScreen.screenHeader
                isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
                navigationButtonState: Detector.isPlatform(Platform.Android)
            }
        }
    ]

    function showWebView(url) {
        webView.url = url
        blogScreen.state = "showWebView"
    }

    function hideWebView() {
        webView.url = "http://localhost"
        blogScreen.state = "hideWebView"
    }
}
