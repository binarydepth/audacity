/*
 * Audacity: A Digital Audio Editor
 */
import QtQuick 2.15
import QtQuick.Layouts 1.15

import Muse.Ui 1.0
import Muse.UiComponents 1.0
import Audacity.AppShell 1.0

Item {
    id: root

    // Properties similar to Page
    property alias title: titleLabel.text
    property NavigationSection navigationSection: null
    property int navigationStartRow: 2
    property string activeButtonTitle: ""

    // Properties for the left side content
    property alias leftContent: leftContentItem.data

    // Properties for the right side content
    property alias rightContent: rightContentItem.data

    // Optional properties for customization
    property bool showRightContent: true

    anchors.fill: parent

    function readInfo() {
        accessibleInfo.readInfo()
    }

    function resetFocus() {
        accessibleInfo.resetFocus()
    }

    property NavigationPanel navigationPanel: NavigationPanel {
        name: "ContentPanel"
        enabled: root.enabled && root.visible
        section: root.navigationSection
        order: root.navigationStartRow
        direction: NavigationPanel.Vertical
    }

    AccessibleItem {
        id: accessibleInfo

        accessibleParent: root.navigationPanel.accessible
        visualItem: root
        role: MUAccessible.Button
        name: root.title + ". " + root.activeButtonTitle

        function readInfo() {
            accessibleInfo.ignored = false
            accessibleInfo.focused = true
        }

        function resetFocus() {
            accessibleInfo.ignored = true
            accessibleInfo.focused = false
        }
    }

    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 0

        // Left side - Controls
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

            Column {
                anchors.fill: parent
                anchors.topMargin: 24
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                anchors.bottomMargin: 24
                spacing: 24

                StyledTextLabel {
                    id: titleLabel
                    horizontalAlignment: Qt.AlignLeft
                    width: parent.width
                    font: ui.theme.largeBodyBoldFont
                    wrapMode: Text.Wrap
                }

                Item {
                    id: leftContentItem
                    width: parent.width
                    height: parent.height - titleLabel.height - parent.spacing
                }
            }
        }

        // Right side - Preview/Image
        Item {
            id: rightContentItem
            Layout.fillWidth: root.showRightContent
            Layout.fillHeight: true
            visible: root.showRightContent
        }
    }
}
