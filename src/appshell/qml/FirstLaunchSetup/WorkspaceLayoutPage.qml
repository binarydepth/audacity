/*
 * Audacity: A Digital Audio Editor
 */
import QtQuick 2.15
import QtQuick.Layouts 1.15

import Muse.Ui 1.0
import Muse.UiComponents 1.0
import Audacity.AppShell 1.0

DoublePage {
    id: root

    title: workspaceModel.pageTitle

    // Left side content
    leftContent: Column {
        anchors.fill: parent
        spacing: 0

        // Radio button options
        Column {
            spacing: 8
            width: parent.width

            Repeater {
                id: optionsRepeater

                model: workspaceModel.workspaces

                delegate: Rectangle {
                    border.color: modelData.selected ? ui.theme.accentColor : ui.theme.strokeColor
                    border.width: 1
                    color: "transparent"
                    height: 76
                    radius: 4
                    width: parent.width

                    Row {
                        anchors.bottomMargin: 12
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.rightMargin: 16
                        anchors.topMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12

                        RoundedRadioButton {
                            anchors.verticalCenter: parent.verticalCenter
                            checked: modelData.selected

                            onToggled: {
                                workspaceModel.selectWorkspace(modelData.code);
                            }
                        }
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            StyledTextLabel {
                                font: ui.theme.bodyBoldFont
                                text: modelData.title
                            }
                            StyledTextLabel {
                                anchors.left: parent.left
                                font: ui.theme.bodyFont
                                horizontalAlignment: Text.AlignLeft
                                text: modelData.description
                                width: 172 // hardcoded width to fit the text for now
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            workspaceModel.selectWorkspace(modelData.code);
                        }
                    }
                    NavigationControl {
                        accessible.name: modelData.title
                        accessible.role: Accessible.Button
                        column: 0
                        enabled: parent.enabled && parent.visible
                        name: "Workspace_" + modelData.code
                        row: index

                        panel: NavigationPanel {
                            direction: NavigationPanel.Horizontal
                            enabled: parent.enabled && parent.visible
                            name: "WorkspacePanel"
                            order: root.navigationStartRow + 1
                            section: root.navigationSection
                        }

                        onActiveChanged: {
                            if (active) {
                                parent.forceActiveFocus();
                            }
                        }
                        onTriggered: {
                            model.selectWorkspace(modelData.code);
                        }
                    }
                }
            }

            Item {
                height: 30  // This creates 30px of space + 8px of spacing from the previous item
                width: parent.width
            }

            // Additional info text
            StyledTextLabel {
                anchors.left: parent.left
                font: ui.theme.bodyFont
                horizontalAlignment: Text.AlignLeft
                text: qsTrc("appshell/gettingstarted", "You can change between these layouts at any time using our new 'workspaces' feature.")
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
    }

    // Right side content
    rightContent: Image {
        anchors.fill: parent
        asynchronous: true
        cache: true
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: false
        source: workspaceModel.currentImagePath

        onStatusChanged: {
            if (status === Image.Error) {
                console.log("Failed to load workspace image:", source)
            } else if (status === Image.Ready) {
                console.log("Successfully loaded workspace image:", source)
            }
        }
    }

    Component.onCompleted: {
        workspaceModel.load();
    }

    SeparatorLine {
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: Qt.Vertical
    }
    WorkspaceLayoutPageModel {
        id: workspaceModel
    }
}
