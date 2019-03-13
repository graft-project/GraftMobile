import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtWebView 1.1
import com.device.platform 1.0
import "components"

BaseScreen {
    id: blogScreen

    property QtObject blogReader: null

    Connections {
        target: blogReader

        onBlogFeedPathChanged: {
            webView.url = path
        }
    }

    title: qsTr("Blog")
    screenHeader {
        isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
        navigationButtonState: Detector.isPlatform(Platform.Android)
        actionButtonState: true
        isBlog: true
    }
    specialBackMode: {
        hideWebView
    }
    action: {
        if (webView.visible) {
            webView.reload
        } else {
            if (blogReader !== null) {
                blogReader.getBlogFeeds
            }
        }
    }

    Component.onCompleted: {
        blogReader = GraftClient.blogReader()
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            screenHeader.actionText = qsTr("Update")
        }
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
        model: blogReader !== null ? blogReader.feedModel() : null
        spacing: 3
        clip: true

        delegate: BlogFeedDelegate {
            width: parent.width

            titleText: title
            titleImage: image
            date: formattedDate
            descriptionText: description
            splitterVisible: index !== listView.count - 1

            onLinkClicked: showWebView(url)
            onReadMoreClicked: showWebView(fullFeedPath)
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
