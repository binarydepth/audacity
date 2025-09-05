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

    function getDescription(code) {
        switch (code) {
        case "modern":
            return qsTrc("appshell/gettingstarted", "A clearer interface. Ideal for new users");
        case "classic":
            return qsTrc("appshell/gettingstarted", "Closely matches the layout of Audacity 3");
        default:
            return "";
        }
    }
    function getWorkspaceImageSource(code) {
        // Detect if current theme is dark by checking background color brightness
        var isDarkTheme = ui.theme.backgroundPrimaryColor.toString().indexOf("#") === 0 ? parseInt(ui.theme.backgroundPrimaryColor.toString().substr(1), 16) < 0x808080 : false;

        // Use the existing image files for both modern and classic
        return isDarkTheme ? "resources/UILayout_DarkMode.png" : "resources/UILayout_LightMode.png";
    }

    title: qsTrc("appshell/gettingstarted", "What UI layout (workspace) do you want?")

    // Left side content
    leftContent: Column {
        anchors.fill: parent
        spacing: 16

        // Workspace options
        Column {
            spacing: 8
            width: parent.width

            Repeater {
                id: workspaceRepeater

                model: model.workspaces

                delegate: Rectangle {
                    border.color: modelData.selected ? ui.theme.accentColor : ui.theme.strokeColor
                    border.width: modelData.selected ? 2 : 1
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
                                model.selectWorkspace(modelData.code);
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
                                text: getDescription(modelData.code)
                                width: 172 // hardcoded width to fit the text for now
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            model.selectWorkspace(modelData.code);
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
                height: 30  // This creates 30px of space
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
        } // End of workspace options Column
    } // End of left side Column

    // Right side content
    rightContent: Image {
        anchors.fill: parent
        asynchronous: true
        cache: true
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: false
        source: {
            for (var i = 0; i < model.workspaces.length; i++) {
                if (model.workspaces[i].selected) {
                    return getWorkspaceImageSource(model.workspaces[i].code)
                }
            }
            return ""
        }

        onStatusChanged: {
            if (status === Image.Error) {
                console.log("Failed to load workspace image:", source)
            } else if (status === Image.Ready) {
                console.log("Successfully loaded workspace image:", source)
            }
        }
    }

    Component.onCompleted: {
        model.load();
    }

    SeparatorLine {
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: Qt.Vertical
    }
    WorkspaceLayoutPageModel {
        id: model

    }

    // Listen to theme changes to update workspace images
    Connections {
        function onThemeChanged() {
            // Force update of images when theme changes
            workspaceRepeater.model = undefined;
            workspaceRepeater.model = model.workspaces;
        }

        target: ui.theme
    }
}
