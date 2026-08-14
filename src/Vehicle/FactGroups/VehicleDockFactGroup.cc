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
    _addFact(&_ls1Fact);
    _addFact(&_ls2Fact);
    _addFact(&_ls3Fact);
    _addFact(&_ls4Fact);
    _addFact(&_ls5Fact);
    _addFact(&_ls6Fact);
    _addFact(&_slot1Fact);
    _addFact(&_slot2Fact);
    _addFact(&_slot1VFact);
    _addFact(&_slot2VFact);
    _addFact(&_slotIFact);

    _dockVoltFact.setRawValue(qQNaN());
    _dockCurrFact.setRawValue(qQNaN());
    _dockTempFact.setRawValue(qQNaN());
    _cell1Fact.setRawValue(qQNaN());
    _cell2Fact.setRawValue(qQNaN());
    _cell3Fact.setRawValue(qQNaN());
    _cell4Fact.setRawValue(qQNaN());
    _cell5Fact.setRawValue(qQNaN());
    _cell6Fact.setRawValue(qQNaN());
    _ls1Fact.setRawValue(0);
    _ls2Fact.setRawValue(0);
    _ls3Fact.setRawValue(0);
    _ls4Fact.setRawValue(0);
    _ls5Fact.setRawValue(0);
    _ls6Fact.setRawValue(0);
    _slot1Fact.setRawValue(0);
    _slot2Fact.setRawValue(0);
    _slot1VFact.setRawValue(qQNaN());
    _slot2VFact.setRawValue(qQNaN());
    _slotIFact.setRawValue(qQNaN());
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

    if (name == QStringLiteral("DOCK_VOLT")) {
        dockVolt()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("DOCK_CURR")) {
        dockCurr()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("DOCK_TEMP")) {
        dockTemp()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("CELL1_V")) {
        cell1()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("CELL2_V")) {
        cell2()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("CELL3_V")) {
        cell3()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("CELL4_V")) {
        cell4()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("CELL5_V")) {
        cell5()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("CELL6_V")) {
        cell6()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("LS_1")) {
        ls1()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("LS_2")) {
        ls2()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("LS_3")) {
        ls3()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("LS_4")) {
        ls4()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("LS_5")) {
        ls5()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("LS_6")) {
        ls6()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("SLOT_1")) {
        slot1()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("SLOT_2")) {
        slot2()->setRawValue(static_cast<int>(value.value));
        parsed = true;
    } else if (name == QStringLiteral("SLOT1_V")) {
        slot1V()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("SLOT2_V")) {
        slot2V()->setRawValue(value.value);
        parsed = true;
    } else if (name == QStringLiteral("SLOT_I")) {
        slotI()->setRawValue(value.value);
        parsed = true;
    }

    if (parsed) {
        _setTelemetryAvailable(true);
    }
}
