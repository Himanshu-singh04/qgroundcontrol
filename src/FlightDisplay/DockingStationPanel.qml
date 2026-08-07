/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FactControls

Rectangle {
    id:             control
    implicitWidth:  ScreenTools.defaultFontPixelWidth * 28
    implicitHeight: mainLayout.implicitHeight + (ScreenTools.defaultFontPixelHeight * 1.5)
    color:          qgcPal.window
    radius:         ScreenTools.defaultFontPixelHeight / 2
    opacity:        0.92
    border.color:   qgcPal.windowShade
    border.width:   1

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool   _hasTelemetry:  _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.telemetryAvailable

    visible:        _hasTelemetry && !QGroundControl.videoManager.fullScreen

    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }

    QGCPalette { id: qgcPal }

    ColumnLayout {
        id:                 mainLayout
        anchors.fill:       parent
        anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.75
        spacing:            ScreenTools.defaultFontPixelHeight * 0.5

        // ==========================================
        // HEADER
        // ==========================================
        RowLayout {
            Layout.fillWidth:   true
            spacing:            ScreenTools.defaultFontPixelWidth

            Rectangle {
                width:          ScreenTools.defaultFontPixelWidth * 0.75
                height:         ScreenTools.defaultFontPixelHeight * 0.75
                radius:         width / 2
                color:          qgcPal.brandBlue
            }

            QGCLabel {
                text:           qsTr("DOCKING STATION")
                font.bold:      true
                font.pointSize: ScreenTools.defaultFontPointSize + 1
                color:          qgcPal.text
            }

            Item { Layout.fillWidth: true }
        }

        Rectangle {
            Layout.fillWidth:   true
            height:             1
            color:              qgcPal.windowShade
        }

        // ==========================================
        // MAIN TELEMETRY (Volt, Curr, Temp)
        // ==========================================
        GridLayout {
            columns:            3
            Layout.fillWidth:   true
            columnSpacing:      ScreenTools.defaultFontPixelWidth
            rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.25

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing:          2
                QGCLabel {
                    text:             qsTr("Voltage")
                    font.pointSize:   ScreenTools.smallFontPointSize
                    color:            qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
                QGCLabel {
                    text:             _activeVehicle && _activeVehicle.dock ? (_activeVehicle.dock.dockVolt.valueString + " " + _activeVehicle.dock.dockVolt.units) : "N/A"
                    font.bold:        true
                    font.pointSize:   ScreenTools.mediumFontPointSize
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing:          2
                QGCLabel {
                    text:             qsTr("Current")
                    font.pointSize:   ScreenTools.smallFontPointSize
                    color:            qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
                QGCLabel {
                    text:             _activeVehicle && _activeVehicle.dock ? (_activeVehicle.dock.dockCurr.valueString + " " + _activeVehicle.dock.dockCurr.units) : "N/A"
                    font.bold:        true
                    font.pointSize:   ScreenTools.mediumFontPointSize
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing:          2
                QGCLabel {
                    text:             qsTr("Temp")
                    font.pointSize:   ScreenTools.smallFontPointSize
                    color:            qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
                QGCLabel {
                    text:             _activeVehicle && _activeVehicle.dock ? (_activeVehicle.dock.dockTemp.valueString + " " + _activeVehicle.dock.dockTemp.units) : "N/A"
                    font.bold:        true
                    font.pointSize:   ScreenTools.mediumFontPointSize
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // ==========================================
        // SLOTS STATUS
        // ==========================================
        RowLayout {
            Layout.fillWidth:   true
            Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.25
            spacing:            ScreenTools.defaultFontPixelWidth

            QGCLabel {
                text:           qsTr("Charging Slots")
                font.bold:      true
                font.pointSize: ScreenTools.smallFontPointSize
                color:          qgcPal.textMuted
            }
            Rectangle {
                Layout.fillWidth:   true
                height:             1
                color:              qgcPal.windowShade
            }
        }

        GridLayout {
            columns:            2
            Layout.fillWidth:   true
            columnSpacing:      ScreenTools.defaultFontPixelWidth * 2
            rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.25

            // Slot 1
            RowLayout {
                spacing: ScreenTools.defaultFontPixelWidth
                QGCLabel {
                    text: "Slot 1:"
                    font.pointSize: ScreenTools.defaultFontPointSize
                    color: qgcPal.textMuted
                }
                Rectangle {
                    width:  12
                    height: 12
                    radius: 6
                    color:  _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot1.rawValue === 1 ? qgcPal.brandBlue : "transparent"
                    border.color: qgcPal.textMuted
                    border.width: 1
                }
                QGCLabel {
                    text: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot1.rawValue === 1 ?
                              (_activeVehicle.dock.slot1V.valueString + " V") : qsTr("Empty")
                    font.bold: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot1.rawValue === 1
                    font.pointSize: ScreenTools.defaultFontPointSize
                    color: qgcPal.text
                }
            }

            // Slot 2
            RowLayout {
                spacing: ScreenTools.defaultFontPixelWidth
                QGCLabel {
                    text: "Slot 2:"
                    font.pointSize: ScreenTools.defaultFontPointSize
                    color: qgcPal.textMuted
                }
                Rectangle {
                    width:  12
                    height: 12
                    radius: 6
                    color:  _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot2.rawValue === 1 ? qgcPal.brandBlue : "transparent"
                    border.color: qgcPal.textMuted
                    border.width: 1
                }
                QGCLabel {
                    text: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot2.rawValue === 1 ?
                              (_activeVehicle.dock.slot2V.valueString + " V") : qsTr("Empty")
                    font.bold: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot2.rawValue === 1
                    font.pointSize: ScreenTools.defaultFontPointSize
                    color: qgcPal.text
                }
            }
        }

        // ==========================================
        // LIMIT SWITCHES STATUS
        // ==========================================
        RowLayout {
            Layout.fillWidth:   true
            Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.25
            spacing:            ScreenTools.defaultFontPixelWidth

            QGCLabel {
                text:           qsTr("Limit Switches")
                font.bold:      true
                font.pointSize: ScreenTools.smallFontPointSize
                color:          qgcPal.textMuted
            }
            Rectangle {
                Layout.fillWidth:   true
                height:             1
                color:              qgcPal.windowShade
            }
        }

        // Grid layout for 6 Limit Switches
        GridLayout {
            columns:            3
            Layout.fillWidth:   true
            columnSpacing:      ScreenTools.defaultFontPixelWidth
            rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.3

            Repeater {
                model: [
                    { name: "LS 1", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls1 : null },
                    { name: "LS 2", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls2 : null },
                    { name: "LS 3", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls3 : null },
                    { name: "LS 4", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls4 : null },
                    { name: "LS 5", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls5 : null },
                    { name: "LS 6", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls6 : null }
                ]

                delegate: RowLayout {
                    spacing: ScreenTools.defaultFontPixelWidth * 0.5
                    Layout.alignment: Qt.AlignLeft

                    Rectangle {
                        width:  12
                        height: 12
                        radius: 6
                        color:  modelData.fact && modelData.fact.rawValue === 1 ? qgcPal.brandRed : qgcPal.windowShade
                        border.color: qgcPal.textMuted
                        border.width: 1

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    QGCLabel {
                        text:             modelData.name
                        font.pointSize:   ScreenTools.defaultFontPointSize - 1
                        color:            modelData.fact && modelData.fact.rawValue === 1 ? qgcPal.text : qgcPal.textMuted
                        font.bold:        modelData.fact && modelData.fact.rawValue === 1
                    }
                }
            }
        }

        // ==========================================
        // CELL VOLTAGES
        // ==========================================
        RowLayout {
            Layout.fillWidth:   true
            Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.25
            spacing:            ScreenTools.defaultFontPixelWidth

            QGCLabel {
                text:           qsTr("Cell Voltages")
                font.bold:      true
                font.pointSize: ScreenTools.smallFontPointSize
                color:          qgcPal.textMuted
            }

            Rectangle {
                Layout.fillWidth:   true
                height:             1
                color:              qgcPal.windowShade
            }
        }

        GridLayout {
            columns:            3
            Layout.fillWidth:   true
            columnSpacing:      ScreenTools.defaultFontPixelWidth * 1.5
            rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.4

            Repeater {
                model: [
                    { name: "C1", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell1 : null },
                    { name: "C2", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell2 : null },
                    { name: "C3", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell3 : null },
                    { name: "C4", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell4 : null },
                    { name: "C5", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell5 : null },
                    { name: "C6", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell6 : null }
                ]

                delegate: ColumnLayout {
                    spacing: 1
                    QGCLabel {
                        text:             modelData.name
                        font.pointSize:   ScreenTools.smallFontPointSize - 1
                        color:            qgcPal.textMuted
                        Layout.alignment: Qt.AlignLeft
                    }
                    QGCLabel {
                        text:             modelData.fact ? (modelData.fact.valueString + " V") : "N/A"
                        font.pointSize:   ScreenTools.defaultFontPointSize
                        color:            qgcPal.text
                        Layout.alignment: Qt.AlignLeft
                    }
                }
            }
        }
    }
}
