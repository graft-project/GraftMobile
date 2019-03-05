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
    specialBackMode: webView.goBack

    WebView {
        id: webView
        anchors.fill: parent
        url: GraftClient.pathToFeeds()

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
}
