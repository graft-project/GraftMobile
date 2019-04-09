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

    Connections {
        target: blogReader

        onBlogFeedPathChanged: {
            webView.url = path
        }
    }

    title: qsTr("About Graft Blockchain")
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

    Flickable {
        anchors.fill: parent
        ScrollBar.vertical: ScrollBar {
            width: 5
        }
        clip: true
        contentHeight: mainLayout.implicitHeight

        ColumnLayout {
            id: mainLayout
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                Layout.topMargin: 30
                Layout.leftMargin: 30
                Layout.rightMargin: 30

                Image {
                    Layout.preferredHeight: 96
                    Layout.alignment: Qt.AlignHCenter
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/g-max.png"
                }

                Label {
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
                        Layout.topMargin: 25
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
                        columnSpacing: -5
                        rowSpacing: -5
                        columns: 2

                        WideActionButton {
                            Layout.fillWidth: true
                            Layout.columnSpan: 2
                            text: qsTr("Our site")
                            onClicked: Qt.openUrlExternally("https://www.graft.network/")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Discord")
                            Material.accent: "#7289DA"
                            onClicked: Qt.openUrlExternally("https://discord.gg/BuZr5fy")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Forum")
                            Material.accent: "#485975"
                            onClicked: Qt.openUrlExternally("https://www.graft.network/forum/")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Telegram")
                            Material.accent: "#2497D6"
                            onClicked: Qt.openUrlExternally("https://t.me/joinchat/EneBw0RALAOjkSL2mdt2Gw")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Steemit")
                            Material.accent: "#06D6A9"
                            onClicked: Qt.openUrlExternally("https://steemit.com/@graft")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Reddit")
                            Material.accent: "#FF4500"
                            onClicked: Qt.openUrlExternally("https://www.reddit.com/r/Graft/")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("LinkedIn")
                            Material.accent: "#0274B3"
                            onClicked: Qt.openUrlExternally("https://www.linkedin.com/company/graft-network/")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Twitter")
                            Material.accent: "#34B3F7"
                            onClicked: Qt.openUrlExternally("https://twitter.com/graftnetwork")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Facebook")
                            Material.accent: "#3A589E"
                            onClicked: Qt.openUrlExternally("https://www.facebook.com/Graft-460292407666720/")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("BitcoinTalks")
                            Material.accent: "#485975"
                            onClicked: Qt.openUrlExternally("https://bitcointalk.org/index.php?topic=2115188")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Medium")
                            Material.accent: "#000000"
                            onClicked: Qt.openUrlExternally("https://medium.com/@graftnetwork")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("Instagram")
                            Material.accent: "#E30088"
                            onClicked: Qt.openUrlExternally("https://www.instagram.com/graftnetwork/")
                        }

                        WideActionButton {
                            Layout.preferredWidth: 164
                            text: qsTr("YouTube")
                            Material.accent: "#FB0007"
                            onClicked: Qt.openUrlExternally("https://www.youtube.com/channel/UCoMSpYdhQDDhhRcyilyyqtw")
                        }
                    }
                }

                WideActionButton {
                    id: moreButton
                    Layout.topMargin: 9
                    Layout.bottomMargin: 20
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
                Layout.preferredHeight: listView.childrenRect.height + newsTitle.height * 2
                Layout.fillWidth: true
                color: "#F4F4F4"

                ColumnLayout {
                    id: blogLayout
                    anchors {
                        fill: parent
                        topMargin: 13
                    }

                    Label {
                        id: newsTitle
                        Layout.leftMargin: 25
                        text: qsTr("Latest news:")
                        font.pixelSize: 20
                    }

                    ListView {
                        id: listView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: blogReader !== null ? blogReader.feedModel() : null
                        interactive: false
                        spacing: 28

                        delegate: BlogFeedDelegate {
                            id: blogFeedDelegate
                            width: listView.width - 50
                            x: 25

                            titleText: title
                            titleImage: image
                            descriptionText: description

                            onLinkClicked: showWebView(url)
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
