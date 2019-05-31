import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtWebView 1.1
import com.device.platform 1.0
import "components"

BaseScreen {
    id: blogScreen

    property QtObject blogReader: null
    property string lastLoadedURL: ""
    property string lastScreenState: ""

    ListModel {
        id: buttonsModel

        ListElement {
            link: "https://www.graft.network/"
            title: qsTr("Our site")
            buttonColor: "#485975"
        }

        ListElement {
            link: "https://discord.gg/BuZr5fy"
            title: qsTr("Discord")
            buttonColor: "#7289DA"
        }

        ListElement {
            link: "https://www.graft.network/forum/"
            title: qsTr("Forum")
            buttonColor: "#485975"
        }

        ListElement {
            link: "https://t.me/joinchat/EneBw0RALAOjkSL2mdt2Gw"
            title: qsTr("Telegram")
            buttonColor: "#2497D6"
        }

        ListElement {
            link: "https://steemit.com/@graft"
            title: qsTr("Steemit")
            buttonColor: "#06D6A9"
        }

        ListElement {
            link: "https://www.reddit.com/r/Graft/"
            title: qsTr("Reddit")
            buttonColor: "#FF4500"
        }

        ListElement {
            link: "https://www.linkedin.com/company/graft-network/"
            title: qsTr("LinkedIn")
            buttonColor: "#0274B3"
        }

        ListElement {
            link: "https://twitter.com/graftnetwork"
            title: qsTr("Twitter")
            buttonColor: "#34B3F7"
        }

        ListElement {
            link: "https://www.facebook.com/Graft-460292407666720/"
            title: qsTr("Facebook")
            buttonColor: "#3A589E"
        }

        ListElement {
            link: "https://bitcointalk.org/index.php?topic=2115188"
            title: qsTr("BitcoinTalks")
            buttonColor: "#485975"
        }

        ListElement {
            link: "https://medium.com/@graftnetwork"
            title: qsTr("Medium")
            buttonColor: "#000000"
        }

        ListElement {
            link: "https://www.instagram.com/graftnetwork/"
            title: qsTr("Instagram")
            buttonColor: "#E30088"
        }

        ListElement {
            link: "https://www.youtube.com/channel/UCoMSpYdhQDDhhRcyilyyqtw"
            title: qsTr("YouTube")
            buttonColor: "#FB0007"
        }
    }

    title: qsTr("About Graft Blockchain")
    state: "hideWebView"
    screenHeader {
        isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
        navigationButtonState: Detector.isPlatform(Platform.Android)
        actionButtonState: true
        isBlog: true
    }
    specialBackMode: hideWebView
    action: update

    Connections {
        target: blogReader

        onUpdated: {
            if (lastScreenState.length !== 0) {
                blogScreen.state = lastScreenState
                reloadIndicator.stopReloading()
            }
        }
    }

    Component.onCompleted: {
        blogReader = GraftClient.blogReader()
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            screenHeader.actionText = qsTr("Update")
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        ScrollBar.vertical: ScrollBar {
            width: 5
        }
        clip: true
        contentHeight: mainLayout.implicitHeight
        boundsBehavior: Flickable.DragOverBounds

        ReloadIndicator {
            id: reloadIndicator
            anchors {
                bottomMargin: flickable.contentY <= 0 ? Math.abs(flickable.contentY) / -2.5 : 0
                bottom: flickable.contentItem.top
                horizontalCenter: flickable.contentItem.horizontalCenter
            }
            height: 35
            z: height
            imageRotation: flickable.contentY < 0 ? Math.abs(flickable.contentY) * 3 : 0
            onStartReload: blogScreen.update()
        }

        ColumnLayout {
            id: mainLayout
            anchors {
                topMargin: 0
                top: parent.top
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                Layout.topMargin: 35
                Layout.leftMargin: 15
                Layout.rightMargin: 15

                Image {
                    Layout.preferredHeight: 86
                    Layout.alignment: Qt.AlignHCenter
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(Layout.preferredHeight, Layout.preferredHeight)
                    source: "qrc:/imgs/g-blog.svg"
                }

                Label {
                    Layout.topMargin: 10
                    Layout.fillWidth: true
                    wrapMode: Label.WordWrap
                    horizontalAlignment: Label.AlignHCenter
                    text: qsTr("GRAFT is short for Global Real-time Authorizations and Fund Transfers, but" +
                               " also represents grafting of the new into the old.")
                }

                ColumnLayout {
                    id: moreLayout
                    Layout.preferredWidth: parent.width
                    visible: false
                    spacing: 25

                    Label {
                        Layout.topMargin: 15
                        Layout.fillWidth: true
                        wrapMode: Label.WordWrap
                        horizontalAlignment: Label.AlignHCenter
                        text: qsTr("GRAFT Blockchain is built on the idea that the payment industry can" +
                                    "benefit tremendously from the democratization brought forward by the" +
                                    "blockchain technology, but only when the right technologies are chosen" +
                                    "and combined with the accepted industry workflows and systems. When" +
                                    "done correctly, this transition to blockchain-based payments will" +
                                    "lead to radically improved credit/debit payment system through the" +
                                    "combination of lower transaction fees, tight privacy controls, low" +
                                    "rates on credit balances, built-in loyalty programs, and connected" +
                                    "extra services.\n GRAFT payment processing network functions similarly" +
                                    "to a credit card processing network with off-chain authorizations and" +
                                    "in-network atomic swap based interchanges. The network is completely" +
                                    "decentralized, able to work cross borders and adapting to local" +
                                    "regulatory environment. In addition to decentralization, GRAFT" +
                                    "solves four biggest problems that exist in cryptocurrency at a" +
                                    "point-of-sale today – privacy, speed, fees, and integration.\n\n" +
                                    "Economically, it’s a two layer (proof-of-work and proof-of-stake)" +
                                    "blockchain with proof-of-stake based authorizations with participants" +
                                    "able to benefit both for mining and staking. GRAFT does not maintain" +
                                    "administrative controls of the network – the network is decentralized" +
                                    "and open to participants fullfilling various functions, building" +
                                    "businesses and revenue opportunities, and adopting GRAFT to local" +
                                    "market specifics.\n\n" +
                                    "GRAFT Network will leverage existing channels and markets (such as" +
                                    "MSPs, ISO’s), while opening the field up to small newcomers.\n\n" +
                                    "Finally GRAFT is open-platform, open-source, non-for profit project" +
                                    "with strong community behind it, with intent to develop towards a fully" +
                                    "distributed autonomous organization (DAO).")
                    }

                    Image {
                        Layout.fillWidth: true
                        fillMode: Image.PreserveAspectFit
                        Layout.alignment: Qt.AlignHCenter
                        source: "qrc:/imgs/next_step.png"
                    }

                    GridLayout {
                        Layout.alignment: Qt.AlignHCenter
                        columnSpacing: 0
                        rowSpacing: 0
                        columns: 2

                        Repeater {
                            model: buttonsModel

                            WideActionButton {
                                Layout.preferredWidth: index === 0 ? moreLayout.width - (rightInset + leftInset) : moreLayout.width / 2 - rightInset
                                Layout.columnSpan: index === 0 ? 2 : 1
                                onClicked: Qt.openUrlExternally(link)
                                Material.accent: buttonColor
                                bottomInset: 4
                                rightInset: 4
                                leftInset: 4
                                topInset: 4
                                text: title
                            }
                        }
                    }
                }

                WideActionButton {
                    id: moreButton
                    Layout.topMargin: 9
                    Layout.bottomMargin: 15
                    Layout.preferredHeight: 56
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("Learn more")
                    onClicked: {
                        moreLayout.visible = !moreLayout.visible
                        text = moreLayout.visible ? qsTr("Hide more") : qsTr("Learn more")
                    }
                }
            }

            Rectangle {
                Layout.preferredHeight: listView.childrenRect.height + newsTitle.height * 2 + 10
                Layout.fillWidth: true
                color: "#F4F4F4"

                ColumnLayout {
                    id: blogLayout
                    anchors {
                        fill: parent
                        topMargin: 10
                    }

                    Label {
                        id: newsTitle
                        Layout.leftMargin: 15
                        text: qsTr("Latest news:")
                        font.pixelSize: 20
                    }

                    ListView {
                        id: listView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: blogReader !== null ? blogReader.feedModel() : null
                        interactive: false
                        spacing: 15

                        delegate: BlogFeedDelegate {
                            id: blogFeedDelegate
                            width: listView.width - 30
                            x: 15

                            titleText: title
                            titleImage: image
                            descriptionText: description

                            onLinkClicked: {
                                if (url.toString().search(/^https{0,1}/g) !== -1) {
                                    Qt.openUrlExternally(url)
                                } else {
                                    showWebView(url)
                                }
                            }
                            onReadMoreClicked: showWebView(fullFeedPath)
                        }
                    }
                }
            }
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
        visible: webView.loading
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
        onLoadingChanged: {
            if (loadRequest.url.toString().search(/^https{0,1}/g) !== -1) {
                stop()
                if (lastLoadedURL.length !== 0) {
                    webView.url = lastLoadedURL
                }
                if (loadRequest.status === WebView.LoadStartedStatus) {
                    Qt.openUrlExternally(loadRequest.url)
                }
            } else {
                if (loadRequest.status === WebView.LoadSucceededStatus) {
                    blogScreen.state = "showWebView"
                }
            }
        }
    }

    states: [
        State {
            name: "showWebView"
            PropertyChanges {
                target: flickable
                visible: false
            }
            PropertyChanges {
                target: webView
                visible: loadProgress === 100
            }
            PropertyChanges {
                target: blogScreen.screenHeader
                isNavigationButtonVisible: true
                navigationButtonState: !Detector.isPlatform(Platform.Android)
            }
            PropertyChanges {
                target: reloadIndicator
                anchors.bottomMargin: flickable.contentY <= 0 ? Math.abs(flickable.contentY) / -2.5 : 0
            }
        },
        State {
            name: "hideWebView"
            PropertyChanges {
                target: flickable
                visible: true
            }
            PropertyChanges {
                target: webView
                visible: false
            }
            PropertyChanges {
                target: blogLayout
                visible: true
            }
            PropertyChanges {
                target: blogScreen.screenHeader
                isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
                navigationButtonState: Detector.isPlatform(Platform.Android)
            }
            PropertyChanges {
                target: reloadIndicator
                imageRotation: flickable.contentY < 0 ? Math.abs(flickable.contentY) * 3 : 0
                anchors.bottomMargin: flickable.contentY <= 0 ? Math.abs(flickable.contentY) / -2.5 : 0
            }
        },
        State {
            name: "updating"
            PropertyChanges {
                target: flickable
                interactive: false
                visible: lastScreenState === "hideWebView"
            }
            PropertyChanges {
                target: webView
                visible: false
            }
            PropertyChanges {
                target: blogLayout
                visible: false
            }
            PropertyChanges {
                target: mainLayout
                anchors.topMargin: 25
            }
            PropertyChanges {
                target: reloadIndicator
                anchors.bottomMargin: -50
            }

            onCompleted: {
                if (lastScreenState === "showWebView") {
                    blogScreen.screenHeader.isNavigationButtonVisible = true
                    blogScreen.screenHeader.navigationButtonState = !Detector.isPlatform(Platform.Android)
                } else {
                    blogScreen.screenHeader.isNavigationButtonVisible = Detector.isPlatform(Platform.Android)
                    blogScreen.screenHeader.navigationButtonState = Detector.isPlatform(Platform.Android)
                }
            }
        }
    ]

    transitions: [
        Transition {
            from: "updating"
            to: "hideWebView"

            PropertyAnimation {
                target: reloadIndicator
                property: "anchors.bottomMargin"
                to: 0
                duration: 600
                easing.type: Easing.InSine
            }

            PropertyAnimation {
                target: mainLayout
                property: "anchors.topMargin"
                to: 0
                duration: 600
                easing.type: Easing.InSine
            }
        }
    ]

    function showWebView(url) {
        webView.url = url
        lastLoadedURL = url
        blogScreen.state = "showWebView"
    }

    function hideWebView() {
        blogScreen.state = "hideWebView"
    }

    function update() {
        if (blogScreen.state !== "updating") {
            lastScreenState = blogScreen.state
            blogScreen.state = "updating"
        }
        if (lastScreenState === "showWebView") {
            webView.reload()
        } else if (lastScreenState === "hideWebView" && blogReader !== null) {
            if (!reloadIndicator.isReloaded) {
                reloadIndicator.startReloading()
            }
            blogReader.getBlogFeeds()
        }
    }
}
