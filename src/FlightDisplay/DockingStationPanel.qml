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
    implicitWidth:  ScreenTools.defaultFontPixelWidth * 26
    implicitHeight: mainLayout.implicitHeight + (ScreenTools.defaultFontPixelHeight * 1.5)
    color:          qgcPal.window
    radius:         ScreenTools.defaultFontPixelHeight / 2
    opacity:        0.9
    border.color:   qgcPal.windowShade
    border.width:   1

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool   _hasTelemetry:  _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.telemetryAvailable

    visible:        _hasTelemetry && !QGroundControl.videoManager.fullScreen

    // Smooth entry transition when telemetry starts
    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }

    QGCPalette { id: qgcPal }

    ColumnLayout {
        id:                 mainLayout
        anchors.fill:       parent
        anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.75
        spacing:            ScreenTools.defaultFontPixelHeight * 0.5

        // Header with title
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

        // Horizontal Separator
        Rectangle {
            Layout.fillWidth:   true
            height:             1
            color:              qgcPal.windowShade
        }

        // Main Metrics (Grid of Voltage, Current, Temp)
        GridLayout {
            columns:            3
            Layout.fillWidth:   true
            columnSpacing:      ScreenTools.defaultFontPixelWidth
            rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.25

            // Volt
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

            // Current
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

            // Temp
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

        // Section Title: Cell Voltages
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

        // Cell Voltages Grid (3 columns x 2 rows)
        GridLayout {
            columns:            3
            Layout.fillWidth:   true
            columnSpacing:      ScreenTools.defaultFontPixelWidth * 1.5
            rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.4

            Repeater {
                model: [
                    { name: qsTr("C1"), fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell1 : null },
                    { name: qsTr("C2"), fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell2 : null },
                    { name: qsTr("C3"), fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell3 : null },
                    { name: qsTr("C4"), fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell4 : null },
                    { name: qsTr("C5"), fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell5 : null },
                    { name: qsTr("C6"), fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell6 : null }
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
