/*
 * Audacity: A Digital Audio Editor
 */
import QtQuick 2.15
import QtQuick.Layouts 1.15

import Muse.Ui 1.0
import Muse.UiComponents 1.0
import Audacity.AppShell 1.0

Page {
    id: root

    title: ""
    explanation: ""

    titleContentSpacing: 0

    WorkspaceLayoutPageModel {
        id: model
    }

    // Listen to theme changes to update workspace images
    Connections {
        target: ui.theme
        function onThemeChanged() {
            // Force update of images when theme changes
            workspaceRepeater.model = undefined
            workspaceRepeater.model = model.workspaces
        }
    }

    Component.onCompleted: {
        model.load()
    }

    function getDescription(code) {
        switch (code) {
        case "modern":
            return qsTrc("appshell/gettingstarted", "A clearer interface. Ideal for new users")
        case "classic":
            return qsTrc("appshell/gettingstarted", "Closely matches the layout of Audacity 3")
        default:
            return ""
        }
    }

    function getWorkspaceImageSource(code) {
        // Detect if current theme is dark by checking background color brightness
        var isDarkTheme = ui.theme.backgroundPrimaryColor.toString().indexOf("#") === 0 ?
                         parseInt(ui.theme.backgroundPrimaryColor.toString().substr(1), 16) < 0x808080 : false

        switch (code) {
        case "modern":
            return isDarkTheme ? "resources/UILayout_Modern_DarkMode.png" : "resources/UILayout_Modern_LightMode.png"
        case "classic":
            return isDarkTheme ? "resources/UILayout_Classic_DarkMode.png" : "resources/UILayout_Classic_LightMode.png"
        default:
            return ""
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Left side - Title, description, and workspace options
        Column {
            Layout.preferredWidth: 280
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // Title
            StyledTextLabel {
                text: qsTrc("appshell/gettingstarted", "What UI layout (workspace) do you want?")
                font: ui.theme.largeBodyBoldFont
                wrapMode: Text.Wrap
            }

            // Workspace options
            Column {
                width: parent.width
                spacing: 8

                Repeater {
                    id: workspaceRepeater
                    model: model.workspaces

                    delegate: Rectangle {
                        width: parent.width
                        height: 50
                        color: "transparent"
                        border.color: modelData.selected ? ui.theme.accentColor : ui.theme.strokeColor
                        border.width: modelData.selected ? 2 : 1
                        radius: 6

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 12

                            RoundedRadioButton {
                                anchors.verticalCenter: parent.verticalCenter
                                checked: modelData.selected
                                onToggled: {
                                    model.selectWorkspace(modelData.code)
                                }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2

                                StyledTextLabel {
                                    text: modelData.title
                                    font: ui.theme.bodyBoldFont
                                }

                                StyledTextLabel {
                                    text: getDescription(modelData.code)
                                    opacity: 0.7
                                    font: ui.theme.bodyFont
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                model.selectWorkspace(modelData.code)
                            }
                        }

                        NavigationControl {
                            name: "Workspace_" + modelData.code
                            enabled: parent.enabled && parent.visible
                            accessible.role: Accessible.Button
                            accessible.name: modelData.title

                            panel: NavigationPanel {
                                name: "WorkspacePanel"
                                enabled: parent.enabled && parent.visible
                                section: root.navigationSection
                                order: root.navigationStartRow + 1
                                direction: NavigationPanel.Horizontal
                            }
                            row: index
                            column: 0

                            onActiveChanged: {
                                if (active) {
                                    parent.forceActiveFocus()
                                }
                            }

                            onTriggered: {
                                model.selectWorkspace(modelData.code)
                            }
                        }
                    }
                }

                // Additional info text
                StyledTextLabel {
                    width: parent.width
                    text: qsTrc("appshell/gettingstarted", "You can change between these layouts at any time using our new 'workspaces' feature.")
                    opacity: 0.7
                    wrapMode: Text.WordWrap
                    font: ui.theme.bodyFont
                }
            } // End of workspace options Column
        } // End of left side Column

        // Right side - Preview area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 200
            Layout.minimumHeight: 150
            color: ui.theme.backgroundSecondaryColor
            border.color: ui.theme.strokeColor
            border.width: 1
            radius: 6

            // Find the selected workspace and show its image
            Image {
                anchors.fill: parent
                anchors.margins: 10
                source: {
                    for (var i = 0; i < model.workspaces.length; i++) {
                        if (model.workspaces[i].selected) {
                            return getWorkspaceImageSource(model.workspaces[i].code)
                        }
                    }
                    return ""
                }
                fillMode: Image.PreserveAspectFit
                smooth: true

                onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("Failed to load workspace image:", source)
                    } else if (status === Image.Ready) {
                        console.log("Successfully loaded workspace image:", source)
                    }
                }
            }
        }
    }
}
