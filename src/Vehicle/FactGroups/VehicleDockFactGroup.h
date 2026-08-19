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
#include <QElapsedTimer>
#include <QTimer>

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
    Q_PROPERTY(Fact *ls1      READ ls1      CONSTANT)
    Q_PROPERTY(Fact *ls2      READ ls2      CONSTANT)
    Q_PROPERTY(Fact *ls3      READ ls3      CONSTANT)
    Q_PROPERTY(Fact *ls4      READ ls4      CONSTANT)
    Q_PROPERTY(Fact *ls5      READ ls5      CONSTANT)
    Q_PROPERTY(Fact *ls6      READ ls6      CONSTANT)
    Q_PROPERTY(Fact *slot1    READ slot1    CONSTANT)
    Q_PROPERTY(Fact *slot2    READ slot2    CONSTANT)
    Q_PROPERTY(Fact *slot1V   READ slot1V   CONSTANT)
    Q_PROPERTY(Fact *slot2V   READ slot2V   CONSTANT)
    Q_PROPERTY(Fact *slotI    READ slotI    CONSTANT)
    
    Q_PROPERTY(bool  online   READ online   NOTIFY onlineChanged)

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
    Fact *ls1()      { return &_ls1Fact; }
    Fact *ls2()      { return &_ls2Fact; }
    Fact *ls3()      { return &_ls3Fact; }
    Fact *ls4()      { return &_ls4Fact; }
    Fact *ls5()      { return &_ls5Fact; }
    Fact *ls6()      { return &_ls6Fact; }
    Fact *slot1()    { return &_slot1Fact; }
    Fact *slot2()    { return &_slot2Fact; }
    Fact *slot1V()   { return &_slot1VFact; }
    Fact *slot2V()   { return &_slot2VFact; }
    Fact *slotI()    { return &_slotIFact; }

    bool online() const { return _online; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

signals:
    void onlineChanged(bool online);

private slots:
    void _checkOnlineStatus();

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
    Fact _ls1Fact      = Fact(0, QStringLiteral("ls1"),      FactMetaData::valueTypeInt32);
    Fact _ls2Fact      = Fact(0, QStringLiteral("ls2"),      FactMetaData::valueTypeInt32);
    Fact _ls3Fact      = Fact(0, QStringLiteral("ls3"),      FactMetaData::valueTypeInt32);
    Fact _ls4Fact      = Fact(0, QStringLiteral("ls4"),      FactMetaData::valueTypeInt32);
    Fact _ls5Fact      = Fact(0, QStringLiteral("ls5"),      FactMetaData::valueTypeInt32);
    Fact _ls6Fact      = Fact(0, QStringLiteral("ls6"),      FactMetaData::valueTypeInt32);
    Fact _slot1Fact    = Fact(0, QStringLiteral("slot1"),    FactMetaData::valueTypeInt32);
    Fact _slot2Fact    = Fact(0, QStringLiteral("slot2"),    FactMetaData::valueTypeInt32);
    Fact _slot1VFact   = Fact(0, QStringLiteral("slot1V"),   FactMetaData::valueTypeDouble);
    Fact _slot2VFact   = Fact(0, QStringLiteral("slot2V"),   FactMetaData::valueTypeDouble);
    Fact _slotIFact    = Fact(0, QStringLiteral("slotI"),    FactMetaData::valueTypeDouble);

    bool          _online = false;
    QElapsedTimer _lastReceivedTimer;
    QTimer        _updateTimer;
};
