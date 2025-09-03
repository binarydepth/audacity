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

    ClipVisualizationPageModel {
        id: clipStyleModel
    }

    Component.onCompleted: {
        clipStyleModel.load()
    }

    function getClipImageSource(code) {
        switch (code) {
        case "colorful":
            return "resources/ClipVisuals_ColourfulClips.png"
        case "classic":
            return "resources/ClipVisuals_ClassicClips.png"
        default:
            return ""
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Left side - Title, description, and radio button options
        Column {
            Layout.preferredWidth: 280
            Layout.alignment: Qt.AlignTop
            spacing: 16

            // Title
            StyledTextLabel {
                text: qsTrc("appshell/gettingstarted", "Clip visualisation")
                font: ui.theme.largeBodyBoldFont
                wrapMode: Text.Wrap
            }

            // Radio button options
            Column {
                width: parent.width
                spacing: 8

                // Colorful option
                Rectangle {
                    width: parent.width
                    height: 50
                    color: "transparent"
                    border.color: clipStyleModel.currentClipStyleCode === "colorful" ? ui.theme.accentColor : ui.theme.strokeColor
                    border.width: clipStyleModel.currentClipStyleCode === "colorful" ? 2 : 1
                    radius: 6

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12

                        RoundedRadioButton {
                            anchors.verticalCenter: parent.verticalCenter
                            checked: clipStyleModel.currentClipStyleCode === "colorful"
                            onToggled: {
                                clipStyleModel.selectClipStyle("colorful")
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            StyledTextLabel {
                                text: "Colourful"
                                font: ui.theme.bodyBoldFont
                            }

                            StyledTextLabel {
                                text: "Each track gets a new colour"
                                opacity: 0.7
                                font: ui.theme.bodyFont
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            clipStyleModel.selectClipStyle("colorful")
                        }
                    }
            }

                // Classic option
                Rectangle {
                    width: parent.width
                    height: 50
                    color: "transparent"
                    border.color: clipStyleModel.currentClipStyleCode === "classic" ? ui.theme.accentColor : ui.theme.strokeColor
                    border.width: clipStyleModel.currentClipStyleCode === "classic" ? 2 : 1
                    radius: 6

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12

                        RoundedRadioButton {
                            anchors.verticalCenter: parent.verticalCenter
                            checked: clipStyleModel.currentClipStyleCode === "classic"
                            onToggled: {
                                clipStyleModel.selectClipStyle("classic")
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            StyledTextLabel {
                                text: "Classic"
                                font: ui.theme.bodyBoldFont
                            }

                            StyledTextLabel {
                                text: "The clips you know and love"
                                opacity: 0.7
                                font: ui.theme.bodyFont
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            clipStyleModel.selectClipStyle("classic")
                        }
                    }
            }
            } // End of radio button options Column
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

            Image {
                anchors.fill: parent
                anchors.margins: 10
                source: getClipImageSource(clipStyleModel.currentClipStyleCode)
                fillMode: Image.PreserveAspectFit
                smooth: true

                onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("Failed to load clip image:", source)
                    } else if (status === Image.Ready) {
                        console.log("Successfully loaded clip image:", source)
                    }
                }
            }
        }
    }
}
