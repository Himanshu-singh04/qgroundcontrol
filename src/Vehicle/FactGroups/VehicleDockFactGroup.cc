/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleDockFactGroup.h"
#include "Vehicle.h"

VehicleDockFactGroup::VehicleDockFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/DockFact.json"), parent)
{
    _addFact(&_dockVoltFact);
    _addFact(&_dockCurrFact);
    _addFact(&_dockTempFact);
    _addFact(&_cell1Fact);
    _addFact(&_cell2Fact);
    _addFact(&_cell3Fact);
    _addFact(&_cell4Fact);
    _addFact(&_cell5Fact);
    _addFact(&_cell6Fact);

    _dockVoltFact.setRawValue(qQNaN());
    _dockCurrFact.setRawValue(qQNaN());
    _dockTempFact.setRawValue(qQNaN());
    _cell1Fact.setRawValue(qQNaN());
    _cell2Fact.setRawValue(qQNaN());
    _cell3Fact.setRawValue(qQNaN());
    _cell4Fact.setRawValue(qQNaN());
    _cell5Fact.setRawValue(qQNaN());
    _cell6Fact.setRawValue(qQNaN());
}

void VehicleDockFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    if (message.msgid != MAVLINK_MSG_ID_NAMED_VALUE_FLOAT) {
        return;
    }

    mavlink_named_value_float_t value{};
    mavlink_msg_named_value_float_decode(&message, &value);

    // Make sure we null-terminate the string, size is 10 chars
    char nameBuf[11];
    memset(nameBuf, 0, sizeof(nameBuf));
    memcpy(nameBuf, value.name, 10);
    QString name = QString::fromLatin1(nameBuf);

    bool parsed = false;

    if (name == QStringLiteral("Dock_Volt")) {
        dockVolt()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Dock_Curr")) {
        dockCurr()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Dock_Temp")) {
        dockTemp()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Cell1")) {
        cell1()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Cell2")) {
        cell2()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Cell3")) {
        cell3()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Cell4")) {
        cell4()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Cell5")) {
        cell5()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("Cell6")) {
        cell6()->setRawValue(value.value);
        parsed = true;
    }

    if (parsed) {
        _setTelemetryAvailable(true);
    }
}
