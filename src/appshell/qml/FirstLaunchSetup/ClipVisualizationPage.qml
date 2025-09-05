/*
 * Audacity: A Digital Audio Editor
 */
import QtQuick 2.15
import QtQuick.Layouts 1.15

import Muse.Ui 1.0
import Muse.UiComponents 1.0
import Audacity.AppShell 1.0
import Audacity.ProjectScene 1.0

DoublePage {
    id: root

    function getClipImageSource(style) {
        switch (style) {
        case ClipStyle.COLORFUL:
            return "resources/ClipVisuals_ColourfulClips.png";
        case ClipStyle.CLASSIC:
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
                border.color: clipStyleModel.currentClipStyle === ClipStyle.COLORFUL ? ui.theme.accentColor : ui.theme.strokeColor
                border.width: clipStyleModel.currentClipStyle === ClipStyle.COLORFUL ? 1 : 1
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
                        checked: clipStyleModel.currentClipStyle === ClipStyle.COLORFUL

                        onToggled: {
                            clipStyleModel.selectClipStyle(ClipStyle.COLORFUL);
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
                        clipStyleModel.selectClipStyle(ClipStyle.COLORFUL);
                    }
                }
            }

            // Classic option
            Rectangle {
                border.color: clipStyleModel.currentClipStyle === ClipStyle.CLASSIC ? ui.theme.accentColor : ui.theme.strokeColor
                border.width: clipStyleModel.currentClipStyle === ClipStyle.CLASSIC ? 1 : 1
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
                        checked: clipStyleModel.currentClipStyle === ClipStyle.CLASSIC

                        onToggled: {
                            clipStyleModel.selectClipStyle(ClipStyle.CLASSIC);
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
                        clipStyleModel.selectClipStyle(ClipStyle.CLASSIC);
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
        source: getClipImageSource(clipStyleModel.currentClipStyle)

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

    SeparatorLine {
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: Qt.Vertical
    }
    ClipVisualizationPageModel {
        id: clipStyleModel

    }
}
