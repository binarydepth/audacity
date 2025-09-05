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

    title: clipStyleModel.pageTitle

    // Left side content
    leftContent: Column {
        anchors.fill: parent
        spacing: 0

        // Radio button options
        Column {
            spacing: 8
            width: parent.width

            Repeater {
                model: clipStyleModel.clipStyles

                delegate: Rectangle {
                    border.color: modelData.selected ? ui.theme.accentColor : ui.theme.strokeColor
                    border.width: 1
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
                            checked: modelData.selected

                            onToggled: {
                                clipStyleModel.selectClipStyle(modelData.style);
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
                                font: ui.theme.bodyFont
                                text: modelData.description
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            clipStyleModel.selectClipStyle(modelData.style);
                        }
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
        source: clipStyleModel.currentImagePath

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
