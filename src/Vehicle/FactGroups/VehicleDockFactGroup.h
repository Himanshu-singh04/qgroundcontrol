/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"

class VehicleDockFactGroup : public FactGroup
{
    Q_OBJECT
    Q_PROPERTY(Fact *dockVolt READ dockVolt CONSTANT)
    Q_PROPERTY(Fact *dockCurr READ dockCurr CONSTANT)
    Q_PROPERTY(Fact *dockTemp READ dockTemp CONSTANT)
    Q_PROPERTY(Fact *cell1    READ cell1    CONSTANT)
    Q_PROPERTY(Fact *cell2    READ cell2    CONSTANT)
    Q_PROPERTY(Fact *cell3    READ cell3    CONSTANT)
    Q_PROPERTY(Fact *cell4    READ cell4    CONSTANT)
    Q_PROPERTY(Fact *cell5    READ cell5    CONSTANT)
    Q_PROPERTY(Fact *cell6    READ cell6    CONSTANT)

public:
    explicit VehicleDockFactGroup(QObject *parent = nullptr);

    Fact *dockVolt() { return &_dockVoltFact; }
    Fact *dockCurr() { return &_dockCurrFact; }
    Fact *dockTemp() { return &_dockTempFact; }
    Fact *cell1()    { return &_cell1Fact; }
    Fact *cell2()    { return &_cell2Fact; }
    Fact *cell3()    { return &_cell3Fact; }
    Fact *cell4()    { return &_cell4Fact; }
    Fact *cell5()    { return &_cell5Fact; }
    Fact *cell6()    { return &_cell6Fact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    Fact _dockVoltFact = Fact(0, QStringLiteral("dockVolt"), FactMetaData::valueTypeDouble);
    Fact _dockCurrFact = Fact(0, QStringLiteral("dockCurr"), FactMetaData::valueTypeDouble);
    Fact _dockTempFact = Fact(0, QStringLiteral("dockTemp"), FactMetaData::valueTypeDouble);
    Fact _cell1Fact    = Fact(0, QStringLiteral("cell1"),    FactMetaData::valueTypeDouble);
    Fact _cell2Fact    = Fact(0, QStringLiteral("cell2"),    FactMetaData::valueTypeDouble);
    Fact _cell3Fact    = Fact(0, QStringLiteral("cell3"),    FactMetaData::valueTypeDouble);
    Fact _cell4Fact    = Fact(0, QStringLiteral("cell4"),    FactMetaData::valueTypeDouble);
    Fact _cell5Fact    = Fact(0, QStringLiteral("cell5"),    FactMetaData::valueTypeDouble);
    Fact _cell6Fact    = Fact(0, QStringLiteral("cell6"),    FactMetaData::valueTypeDouble);
};
