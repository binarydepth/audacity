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

    function getClipImageSource(code) {
        switch (code) {
        case "colorful":
            return "resources/ClipVisuals_ColourfulClips.png";
        case "classic":
            return "resources/ClipVisuals_ClassicClips.png";
        default:
            return "";
        }
    }

    title: qsTrc("appshell/gettingstarted", "Clip visualisation")

    // Left side content
    leftContent: Column {
        anchors.fill: parent
        spacing: 0

        // Radio button options
        Column {
            spacing: 8
            width: parent.width

            // Colorful option
            Rectangle {
                border.color: clipStyleModel.currentClipStyleCode === "colorful" ? ui.theme.accentColor : ui.theme.strokeColor
                border.width: clipStyleModel.currentClipStyleCode === "colorful" ? 1 : 1
                color: "transparent"
                height: 60
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
                        checked: clipStyleModel.currentClipStyleCode === "colorful"

                        onToggled: {
                            clipStyleModel.selectClipStyle("colorful");
                        }
                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        StyledTextLabel {
                            font: ui.theme.bodyBoldFont
                            text: "Colourful"
                        }
                        StyledTextLabel {
                            font: ui.theme.bodyFont
                            opacity: 0.7
                            text: "Each track gets a new colour"
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        clipStyleModel.selectClipStyle("colorful");
                    }
                }
            }

            // Classic option
            Rectangle {
                border.color: clipStyleModel.currentClipStyleCode === "classic" ? ui.theme.accentColor : ui.theme.strokeColor
                border.width: clipStyleModel.currentClipStyleCode === "classic" ? 1 : 1
                color: "transparent"
                height: 60
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
                        checked: clipStyleModel.currentClipStyleCode === "classic"

                        onToggled: {
                            clipStyleModel.selectClipStyle("classic");
                        }
                    }
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        StyledTextLabel {
                            font: ui.theme.bodyBoldFont
                            text: "Classic"
                        }
                        StyledTextLabel {
                            font: ui.theme.bodyFont
                            opacity: 0.7
                            text: "The clips you know and love"
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        clipStyleModel.selectClipStyle("classic");
                    }
                }
            }
        } // End of radio button options Column
    } // End of left side Column

    // Right side content
    rightContent: Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        smooth: true
        source: getClipImageSource(clipStyleModel.currentClipStyleCode)

        onStatusChanged: {
            if (status === Image.Error) {
                console.log("Failed to load clip image:", source);
            } else if (status === Image.Ready) {
                console.log("Successfully loaded clip image:", source);
            }
        }
    }

    Component.onCompleted: {
        clipStyleModel.load();
    }

    ClipVisualizationPageModel {
        id: clipStyleModel

    }
}
