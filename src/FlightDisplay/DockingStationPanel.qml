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
    width:          mainLayout.width + (ScreenTools.defaultFontPixelWidth * 1.0)
    height:         mainLayout.height + (ScreenTools.defaultFontPixelHeight * 1.0)
    color:          qgcPal.window
    radius:         ScreenTools.defaultFontPixelHeight / 2
    opacity:        0.92
    border.color:   qgcPal.windowShade
    border.width:   1

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool   _hasTelemetry:  _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.telemetryAvailable
    property bool   _isOnline:      _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.online

    // Collapsible section state variables (collapsed by default)
    property bool   statusExpanded: false
    property bool   cellsExpanded:  false

    visible:        _hasTelemetry && !QGroundControl.videoManager.fullScreen

    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }

    QGCPalette { id: qgcPal }

    // Helper functions to interpret limit switches (0 is active/triggered)
    function getSystemState(lsActive, lsInactive) {
        if (lsActive === 0 && lsInactive === 1) return "Active"
        if (lsActive === 1 && lsInactive === 0) return "Inactive"
        if (lsActive === 1 && lsInactive === 1) return "Moving"
        if (lsActive === 0 && lsInactive === 0) return "Error"
        return "N/A"
    }

    function getArmText(ls1, ls2) {
        var state = getSystemState(ls1, ls2)
        if (state === "Active") return qsTr("Open")
        if (state === "Inactive") return qsTr("Closed")
        return state
    }

    function getArmColor(ls1, ls2) {
        if (!_isOnline) return "#7f8c8d" // Grey if offline
        var state = getSystemState(ls1, ls2)
        if (state === "Active") return "#e67e22" // Orange
        if (state === "Inactive") return "#2ecc71" // Green
        if (state === "Moving") return "#3498db" // Blue
        return "#e74c3c" // Red (Error)
    }

    function getElevatorText(ls3, ls4) {
        var state = getSystemState(ls3, ls4)
        if (state === "Active") return qsTr("Up")
        if (state === "Inactive") return qsTr("Down")
        return state
    }

    function getElevatorColor(ls3, ls4) {
        if (!_isOnline) return "#7f8c8d"
        var state = getSystemState(ls3, ls4)
        if (state === "Active") return "#2ecc71" // Green
        if (state === "Inactive") return "#e67e22" // Orange
        if (state === "Moving") return "#3498db" // Blue
        return "#e74c3c" // Red
    }

    function getLidText(ls5, ls6) {
        var state = getSystemState(ls5, ls6)
        if (state === "Active") return qsTr("Open")
        if (state === "Inactive") return qsTr("Closed")
        return state
    }

    function getLidColor(ls5, ls6) {
        if (!_isOnline) return "#7f8c8d"
        var state = getSystemState(ls5, ls6)
        if (state === "Active") return "#e67e22" // Orange
        if (state === "Inactive") return "#2ecc71" // Green
        if (state === "Moving") return "#3498db" // Blue
        return "#e74c3c" // Red
    }

    ColumnLayout {
        id:                 mainLayout
        anchors.top:        parent.top
        anchors.topMargin:  ScreenTools.defaultFontPixelHeight * 0.5
        anchors.left:       parent.left
        anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 0.5
        width:              ScreenTools.defaultFontPixelWidth * 16
        spacing:            ScreenTools.defaultFontPixelHeight * 0.3

        // ==========================================
        // HEADER
        // ==========================================
        RowLayout {
            Layout.fillWidth:   true
            spacing:            ScreenTools.defaultFontPixelWidth * 0.5

            Rectangle {
                width:          4
                height:         10
                radius:         1
                color:          _isOnline ? qgcPal.brandBlue : qgcPal.textMuted
            }

            QGCLabel {
                text:           qsTr("DOCK STATUS")
                font.bold:      true
                font.pointSize: ScreenTools.defaultFontPointSize - 1
                color:          _isOnline ? qgcPal.text : qgcPal.textMuted
            }

            Item { Layout.fillWidth: true }

            QGCLabel {
                text:           _isOnline ? qsTr("ONLINE") : qsTr("OFFLINE")
                font.bold:      true
                font.pointSize: ScreenTools.smallFontPointSize - 2
                color:          _isOnline ? "#2ecc71" : "#e74c3c"
            }
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
            columnSpacing:      ScreenTools.defaultFontPixelWidth * 0.25
            rowSpacing:         0

            // Volt
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing:          0
                QGCLabel {
                    text:             qsTr("Voltage")
                    font.pointSize:   ScreenTools.smallFontPointSize - 2
                    color:            qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
                QGCLabel {
                    text:             _activeVehicle && _activeVehicle.dock ? (_activeVehicle.dock.dockVolt.valueString + " V") : "N/A"
                    font.bold:        true
                    font.pointSize:   ScreenTools.smallFontPointSize
                    color:            _isOnline ? qgcPal.text : qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Current
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing:          0
                QGCLabel {
                    text:             qsTr("Current")
                    font.pointSize:   ScreenTools.smallFontPointSize - 2
                    color:            qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
                RowLayout {
                    spacing:          2
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        id:             currentIndicator
                        width:          6
                        height:         6
                        radius:         3
                        color: {
                            if (!_isOnline || !_activeVehicle || !_activeVehicle.dock) return "#7f8c8d"
                            var curr = _activeVehicle.dock.dockCurr.rawValue
                            if (curr > 0.05) return "#2ecc71"
                            if (curr < -0.05) return "#3498db"
                            return "#7f8c8d"
                        }
                        
                        opacity:        1.0
                        
                        Timer {
                            running:    _isOnline && _activeVehicle && _activeVehicle.dock && Math.abs(_activeVehicle.dock.dockCurr.rawValue) > 0.05
                            repeat:     true
                            interval:   800
                            onTriggered: {
                                blinkAnim.start()
                            }
                        }

                        SequentialAnimation on opacity {
                            id:      blinkAnim
                            running: false
                            NumberAnimation { to: 0.3; duration: 400; easing.type: Easing.InOutQuad }
                            NumberAnimation { to: 1.0; duration: 400; easing.type: Easing.InOutQuad }
                        }
                    }

                    QGCLabel {
                        text:             _activeVehicle && _activeVehicle.dock ? (_activeVehicle.dock.dockCurr.valueString + " A") : "N/A"
                        font.bold:        true
                        font.pointSize:   ScreenTools.smallFontPointSize
                        color:            _isOnline ? qgcPal.text : qgcPal.textMuted
                    }
                }
            }

            // Temp
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing:          0
                QGCLabel {
                    text:             qsTr("Temp")
                    font.pointSize:   ScreenTools.smallFontPointSize - 2
                    color:            qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
                QGCLabel {
                    text:             _activeVehicle && _activeVehicle.dock ? (_activeVehicle.dock.dockTemp.valueString + "°C") : "N/A"
                    font.bold:        true
                    font.pointSize:   ScreenTools.smallFontPointSize
                    color:            _isOnline ? qgcPal.text : qgcPal.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // ==========================================
        // SLOTS STATUS (Charging Slots)
        // ==========================================
        Rectangle {
            Layout.fillWidth:   true
            height:             1
            color:              qgcPal.windowShade
        }

        ColumnLayout {
            Layout.fillWidth:   true
            spacing:            ScreenTools.defaultFontPixelHeight * 0.15

            RowLayout {
                Layout.fillWidth:   true
                spacing:            ScreenTools.defaultFontPixelWidth * 0.5

                // Slot 1
                RowLayout {
                    spacing: 2
                    Layout.fillWidth: true
                    QGCLabel {
                        text: "S1:"
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color: qgcPal.textMuted
                    }
                    QGCLabel {
                        text: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot1.rawValue === 1 ?
                                  (_activeVehicle.dock.slot1V.valueString + "V") : qsTr("Empty")
                        font.bold: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot1.rawValue === 1
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color: !_isOnline ? qgcPal.textMuted : (_activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot1.rawValue === 1 ? qgcPal.text : qgcPal.textMuted)
                    }
                }

                // Slot 2
                RowLayout {
                    spacing: 2
                    Layout.fillWidth: true
                    QGCLabel {
                        text: "S2:"
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color: qgcPal.textMuted
                    }
                    QGCLabel {
                        text: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot2.rawValue === 1 ?
                                  (_activeVehicle.dock.slot2V.valueString + "V") : qsTr("Empty")
                        font.bold: _activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot2.rawValue === 1
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color: !_isOnline ? qgcPal.textMuted : (_activeVehicle && _activeVehicle.dock && _activeVehicle.dock.slot2.rawValue === 1 ? qgcPal.text : qgcPal.textMuted)
                    }
                }
            }

            // Slot Current (SLOT_I)
            RowLayout {
                Layout.fillWidth:   true
                spacing:            4
                QGCLabel {
                    text:           qsTr("Slot Current:")
                    font.pointSize: ScreenTools.smallFontPointSize - 1
                    color:          qgcPal.textMuted
                }
                QGCLabel {
                    text:           _activeVehicle && _activeVehicle.dock ? (_activeVehicle.dock.slotI.valueString + " A") : "N/A"
                    font.bold:      true
                    font.pointSize: ScreenTools.smallFontPointSize - 1
                    color:          _isOnline ? qgcPal.text : qgcPal.textMuted
                }
            }
        }

        // ==========================================
        // COLLAPSIBLE: SYSTEM STATUS (Limit Switches)
        // ==========================================
        Rectangle {
            Layout.fillWidth:   true
            height:             1
            color:              qgcPal.windowShade
        }

        ColumnLayout {
            Layout.fillWidth:   true
            spacing:            ScreenTools.defaultFontPixelHeight * 0.15

            // Collapsible Header
            QGCMouseArea {
                Layout.fillWidth:   true
                implicitHeight:     headerRow.height
                
                onClicked: control.statusExpanded = !control.statusExpanded

                RowLayout {
                    id:                 headerRow
                    anchors.left:       parent.left
                    anchors.right:      parent.right

                    QGCLabel {
                        text:           qsTr("System Status")
                        font.bold:      true
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color:          qgcPal.textMuted
                    }

                    Item { Layout.fillWidth: true }

                    QGCLabel {
                        text:           control.statusExpanded ? "▼" : "▶"
                        font.pointSize: ScreenTools.smallFontPointSize - 2
                        color:          qgcPal.textMuted
                    }
                }
            }

            // Expanded content (3 key components based on limit switches)
            ColumnLayout {
                Layout.fillWidth:   true
                visible:            control.statusExpanded
                spacing:            ScreenTools.defaultFontPixelHeight * 0.25
                Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.15

                // Locking Arm
                RowLayout {
                    Layout.fillWidth: true
                    QGCLabel {
                        text:           qsTr("Locking Arm")
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color:          _isOnline ? qgcPal.text : qgcPal.textMuted
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        radius:         3
                        color:          Qt.rgba(armColor.r, armColor.g, armColor.b, 0.15)
                        border.color:   armColor
                        border.width:   1
                        implicitWidth:  ScreenTools.defaultFontPixelWidth * 4.5
                        implicitHeight: ScreenTools.defaultFontPixelHeight * 0.95

                        property color armColor: getArmColor(_activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls1.rawValue : 0,
                                                             _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls2.rawValue : 0)

                        QGCLabel {
                            anchors.centerIn: parent
                            text:             _isOnline && _activeVehicle && _activeVehicle.dock ?
                                                  getArmText(_activeVehicle.dock.ls1.rawValue, _activeVehicle.dock.ls2.rawValue) : "N/A"
                            font.pointSize:   ScreenTools.smallFontPointSize - 2
                            font.bold:        true
                            color:            parent.armColor
                        }
                    }
                }

                // Elevator
                RowLayout {
                    Layout.fillWidth: true
                    QGCLabel {
                        text:           qsTr("Elevator")
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color:          _isOnline ? qgcPal.text : qgcPal.textMuted
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        radius:         3
                        color:          Qt.rgba(elevColor.r, elevColor.g, elevColor.b, 0.15)
                        border.color:   elevColor
                        border.width:   1
                        implicitWidth:  ScreenTools.defaultFontPixelWidth * 4.5
                        implicitHeight: ScreenTools.defaultFontPixelHeight * 0.95

                        property color elevColor: getElevatorColor(_activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls3.rawValue : 0,
                                                                   _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls4.rawValue : 0)

                        QGCLabel {
                            anchors.centerIn: parent
                            text:             _isOnline && _activeVehicle && _activeVehicle.dock ?
                                                  getElevatorText(_activeVehicle.dock.ls3.rawValue, _activeVehicle.dock.ls4.rawValue) : "N/A"
                            font.pointSize:   ScreenTools.smallFontPointSize - 2
                            font.bold:        true
                            color:            parent.elevColor
                        }
                    }
                }

                // Lid
                RowLayout {
                    Layout.fillWidth: true
                    QGCLabel {
                        text:           qsTr("Lid")
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color:          _isOnline ? qgcPal.text : qgcPal.textMuted
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        radius:         3
                        color:          Qt.rgba(lidColor.r, lidColor.g, lidColor.b, 0.15)
                        border.color:   lidColor
                        border.width:   1
                        implicitWidth:  ScreenTools.defaultFontPixelWidth * 4.5
                        implicitHeight: ScreenTools.defaultFontPixelHeight * 0.95

                        property color lidColor: getLidColor(_activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls5.rawValue : 0,
                                                             _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.ls6.rawValue : 0)

                        QGCLabel {
                            anchors.centerIn: parent
                            text:             _isOnline && _activeVehicle && _activeVehicle.dock ?
                                                  getLidText(_activeVehicle.dock.ls5.rawValue, _activeVehicle.dock.ls6.rawValue) : "N/A"
                            font.pointSize:   ScreenTools.smallFontPointSize - 2
                            font.bold:        true
                            color:            parent.lidColor
                        }
                    }
                }
            }
        }

        // ==========================================
        // COLLAPSIBLE: CELL VOLTAGES
        // ==========================================
        Rectangle {
            Layout.fillWidth:   true
            height:             1
            color:              qgcPal.windowShade
        }

        ColumnLayout {
            Layout.fillWidth:   true
            spacing:            ScreenTools.defaultFontPixelHeight * 0.15

            // Collapsible Header
            QGCMouseArea {
                Layout.fillWidth:   true
                implicitHeight:     headerRow2.height

                onClicked: control.cellsExpanded = !control.cellsExpanded

                RowLayout {
                    id:                 headerRow2
                    anchors.left:       parent.left
                    anchors.right:      parent.right

                    QGCLabel {
                        text:           qsTr("Cell Voltages")
                        font.bold:      true
                        font.pointSize: ScreenTools.smallFontPointSize - 1
                        color:          qgcPal.textMuted
                    }

                    Item { Layout.fillWidth: true }

                    QGCLabel {
                        text:           control.cellsExpanded ? "▼" : "▶"
                        font.pointSize: ScreenTools.smallFontPointSize - 2
                        color:          qgcPal.textMuted
                    }
                }
            }

            // Expanded content (Cell voltages compact grid)
            GridLayout {
                columns:            3
                Layout.fillWidth:   true
                columnSpacing:      ScreenTools.defaultFontPixelWidth * 0.5
                rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.15
                visible:            control.cellsExpanded
                Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.15

                Repeater {
                    model: [
                        { name: "C1", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell1 : null },
                        { name: "C2", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell2 : null },
                        { name: "C3", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell3 : null },
                        { name: "C4", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell4 : null },
                        { name: "C5", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell5 : null },
                        { name: "C6", fact: _activeVehicle && _activeVehicle.dock ? _activeVehicle.dock.cell6 : null }
                    ]

                    delegate: RowLayout {
                        spacing: 2
                        QGCLabel {
                            text:             modelData.name
                            font.pointSize:   ScreenTools.smallFontPointSize - 2
                            color:            qgcPal.textMuted
                        }
                        QGCLabel {
                            text:             modelData.fact ? (modelData.fact.valueString + "V") : "N/A"
                            font.pointSize:   ScreenTools.smallFontPointSize - 1
                            color:            _isOnline ? qgcPal.text : qgcPal.textMuted
                        }
                    }
                }
            }
        }
    }
}
