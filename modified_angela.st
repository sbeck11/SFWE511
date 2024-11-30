PROGRAM Sludge
  VAR
    InletValveStatus AT %IX0 : BOOL := 1;
    OverflowSensor AT %IX1 : BOOL := 0;
    PumpStatus AT %IX2 : BOOL := 1;
    DisinfectantStatus AT %IX3 : BOOL := 1;
    GasHighVolumeAlert AT %IX4 : BOOL := 1;
    InletControl AT %QX5 : BOOL := 0;
    OutletControl AT %QX6 : BOOL := 0;
    SludgeOutPump AT %QX7 : BOOL := 0;
    ActivatePumpAdjust AT %QX8 : BOOL := 0;
    OverflowValveOpen AT %QX9 : BOOL := 0;
    SolidWasteAlarm AT %QX10 : BOOL := 0;
    FiltrationControl AT %QX11 : BOOL := 1;
    ThickeningPump AT %QX12 : BOOL := 0;
    DigesterPump AT %QX13 : BOOL := 0;
    HotWaterPumpIn AT %QX14 : BOOL := 0;
    HotWaterPumpOut AT %QX15 : BOOL := 0;
    GasPumpToTransport AT %QX16 : BOOL := 1;
    pHValid AT %QX17 : BOOL := 1;
    UVLowerStrength AT %QX18 : BOOL := 0;
    UVIncreaseStrength AT %QX19 : BOOL := 0;
    InflowSensor AT %IW20 : INT := 10000;
    DissolvedO2 AT %IW21 : INT := 9800;
    pHSensor AT %IW22 : INT := 6;
    TurbiditySensor AT %IW23 : INT := 1;
    TSSSensor AT %IW24 : INT := 1;
    O2Demand AT %IW25 : INT := 6;
    UVPower AT %IW26 : INT := 8000;
    SludgePumpVolume AT %IW27 : INT := 60;
    TurbidityThreshold AT %IW28 : INT := 60;
    pHUpper AT %IW29 : INT := 8;
    pHLower AT %IW30 : INT := 6;
    TSSThreshold AT %IW31 : INT := 275;
    UVUpper AT %IW32 : INT := 10500;
    UVLower AT %IW33 : INT := 9999;
    Const5 AT %IW34 : INT := 5;
    Const500 AT %IW35 : INT := 500;
    Const10000 AT %IW36 : INT := 10000;
  END_VAR
  VAR
    _TMP_GT8_OUT : BOOL;
    _TMP_GT21_OUT : BOOL;
    _TMP_GE27_OUT : BOOL;
    _TMP_GT33_OUT : BOOL;
    _TMP_GT15_OUT : BOOL;
    _TMP_LT46_OUT : BOOL;
    _TMP_LT38_OUT : BOOL;
    _TMP_AND44_OUT : BOOL;
    _TMP_LT40_OUT : BOOL;
    _TMP_GT56_OUT : BOOL;
    _TMP_AND57_OUT : BOOL;
    _TMP_LT50_OUT : BOOL;
    _TMP_GT65_OUT : BOOL;
    _TMP_AND52_OUT : BOOL;
    _TMP_LT62_OUT : BOOL;
    _TMP_GT72_OUT : BOOL;
    _TMP_SUB39_OUT : INT;
    _TMP_LE77_OUT : BOOL;
  END_VAR

  ThickeningPump := OverflowSensor;
  DigesterPump := OverflowSensor AND SolidWasteAlarm;
  _TMP_GT8_OUT := GT(DissolvedO2, O2Demand);
  HotWaterPumpOut := _TMP_GT8_OUT;
  _TMP_GT21_OUT := GT(O2Demand, DissolvedO2);
  HotWaterPumpIn := _TMP_GT21_OUT;
  GasPumpToTransport := GasHighVolumeAlert;
  _TMP_GE27_OUT := GE(SludgePumpVolume, Const5);
  SludgeOutPump := _TMP_GE27_OUT OR NOT(OverflowSensor) AND PumpStatus;
  _TMP_GT33_OUT := GT(Const10000, InflowSensor);
  InletControl := _TMP_GT33_OUT;
  InletValveStatus := InletControl;
  _TMP_GT15_OUT := GT(InflowSensor, Const10000);
  ActivatePumpAdjust := _TMP_GT15_OUT;
  OverflowValveOpen := OverflowSensor;
  _TMP_LT46_OUT := LT(TurbiditySensor, TurbidityThreshold);
  _TMP_LT38_OUT := LT(TSSSensor, TSSThreshold);
  _TMP_AND44_OUT := AND(_TMP_LT46_OUT, _TMP_LT38_OUT);
  FiltrationControl := pHValid AND _TMP_AND44_OUT;
  _TMP_LT40_OUT := LT(pHUpper, pHSensor);
  _TMP_GT56_OUT := GT(pHSensor, pHLower);
  _TMP_AND57_OUT := AND(_TMP_LT40_OUT, _TMP_GT56_OUT);
  pHValid := _TMP_AND57_OUT;
  PumpStatus := pHValid AND _TMP_AND44_OUT;
  _TMP_LT50_OUT := LT(UVUpper, UVPower);
  _TMP_GT65_OUT := GT(UVPower, UVLower);
  _TMP_AND52_OUT := AND(_TMP_LT50_OUT, _TMP_GT65_OUT);
  OutletControl := DisinfectantStatus AND _TMP_AND52_OUT;
  _TMP_LT62_OUT := LT(UVLower, UVPower);
  UVIncreaseStrength := _TMP_LT62_OUT;
  _TMP_GT72_OUT := GT(UVPower, UVUpper);
  UVLowerStrength := _TMP_GT72_OUT;
  DisinfectantStatus := _TMP_LT62_OUT;
  _TMP_SUB39_OUT := SUB(InflowSensor, Const10000);
  _TMP_LE77_OUT := LE(_TMP_SUB39_OUT, Const500);
  InletControl := _TMP_LE77_OUT;
END_PROGRAM

PROGRAM influent
  VAR
    InfluentWaterFlow AT %IW50 : INT := 10000;
    EffluentWaterFlow AT %IW49 : INT := 10000;
    AirFlow AT %IW42 : INT := 5000;
    PretreatmentUnitFlow AT %IW48 : INT := 7000;
    ClarifierWaterDepth AT %IW43 : INT := 4;
    ClarifierWaterTemp AT %IW44 : INT := 72;
    AerobicSurface AT %IW45 : INT;
    AerobicReactorAirflow AT %IW46 : INT := 5000;
    AerobicWaterLevel AT %IW47 : INT := 75;
    TSS AT %IW11 : INT := 900;
    SandContainerFlow AT %IW18 : INT := 7000;
    SandWaterLevelHigh AT %IX19 : BOOL := 0;
    SecondaryClarifierWaterDepth AT %IW40 : INT := 0;
    BOD5 AT %IW41 : INT := 0;
    AirBlower AT %QX42 : BOOL := 1;
    FerrousChemicalDeploy AT %QX44 : BOOL := 0;
    PretreatInletControlStatus AT %QX41 : BOOL := 1;
    PretreatOutletControlStatus AT %QX2 : BOOL := 1;
    ScreeningContainerEffluentValve AT %QX43 : BOOL := 1;
    SandContainerEffluentValve AT %QX45 : BOOL := 1;
    ScreeningContSludgeEffluentValve AT %QX46 : BOOL := 1;
    ClarifierOutletValve AT %QX47 : BOOL := 1;
    SecondaryClarifierOutletValve AT %QX48 : BOOL := 1;
    SecondaryClarifierSludgeValve AT %QX49 : BOOL := 1;
    AirMinFlow AT %MW41 : INT := 49923;
    AirMaxFlow AT %MW45 : INT := 186302;
    TempMin AT %MW46 : INT := 17;
    TempMax AT %MW47 : INT := 30;
    DesignFlow AT %MW48 : INT := 10000;
    DryWeatherFlow AT %MW49 : INT := 27702;
    TSSThreshold AT %MW50 : INT := 275;
    BOD5Threshold AT %MW51 : INT := 313;
    InfluentFlowValveStatus AT %MX52 : BOOL := 0;
    ClarifierWaterDepthThreshold AT %MW42 : INT := 4;
    ClarifierSurface AT %MW43 : INT := 144;
    SecondClarifierDepthThresh AT %MW44 : INT := 4;
  END_VAR
  VAR
    _TMP_LE7_OUT : BOOL;
    _TMP_GT15_OUT : BOOL;
    _TMP_LT17_OUT : BOOL;
    _TMP_GT21_OUT : BOOL;
    _TMP_GT27_OUT : BOOL;
    _TMP_GT12_OUT : BOOL;
    _TMP_GT4_OUT : BOOL;
  END_VAR

  _TMP_LE7_OUT := LE(InfluentWaterFlow, DryWeatherFlow);
  PretreatInletControlStatus := _TMP_LE7_OUT;
  SandContainerEffluentValve := SandWaterLevelHigh;
  ScreeningContainerEffluentValve := SandWaterLevelHigh;
  _TMP_GT15_OUT := GT(ClarifierWaterDepth, ClarifierWaterDepthThreshold);
  ClarifierOutletValve := _TMP_GT15_OUT;
  _TMP_LT17_OUT := LT(AerobicReactorAirflow, AirMinFlow);
  AirBlower := _TMP_LT17_OUT;
  _TMP_GT21_OUT := GT(AerobicReactorAirflow, AirMaxFlow);
  AirBlower := NOT(_TMP_GT21_OUT);
  _TMP_GT27_OUT := GT(TSS, TSSThreshold);
  _TMP_GT12_OUT := GT(BOD5, BOD5Threshold);
  FerrousChemicalDeploy := _TMP_GT12_OUT OR _TMP_GT27_OUT;
  _TMP_GT4_OUT := GT(SecondaryClarifierWaterDepth, SecondClarifierDepthThresh);
  SecondaryClarifierSludgeValve := _TMP_GT4_OUT;
  SecondaryClarifierOutletValve := _TMP_GT4_OUT;
END_PROGRAM

PROGRAM Humus
  VAR
    FilterPresureSwitchHigh AT %IX15 : INT;
    FilterPressureSwitchLow AT %IX16 : INT;
    RoughingTricklingFilterVolume AT %MW0 : INT := 1063;
    RoughingCircularHumusTank AT %MW1 : INT := 144;
    Const144 AT %MW2 : INT := 144;
    Const1063 AT %MW3 : INT := 1063;
    SludgePumpControl AT %QX50 : BOOL;
    MixerControl AT %QX51 : BOOL;
    FilterFlowControlvalve AT %QX52 : BOOL;
    FilterationControl AT %QX20 : BOOL;
  END_VAR
  VAR
    _TMP_GT3_OUT : BOOL;
    _TMP_LT7_OUT : BOOL;
    _TMP_GE14_OUT : BOOL;
    _TMP_GE21_OUT : BOOL;
  END_VAR

  _TMP_GT3_OUT := GT(FilterPresureSwitchHigh, Const144);
  FilterationControl := _TMP_GT3_OUT;
  _TMP_LT7_OUT := LT(FilterPressureSwitchLow, Const144);
  FilterationControl := _TMP_LT7_OUT;
  _TMP_GE14_OUT := GE(RoughingTricklingFilterVolume, Const1063);
  FilterFlowControlvalve := _TMP_GE14_OUT;
  FilterFlowControlvalve := MixerControl;
  _TMP_GE21_OUT := GE(RoughingCircularHumusTank, Const144);
  SludgePumpControl := _TMP_GE21_OUT;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : Sludge;
  END_RESOURCE
END_CONFIGURATION

(*DBG:char md5[] = "578c10bc9da653279b6b30593cf42823";*)
(*DBG:/**)
(*DBG: * This file is part of OpenPLC Runtime*)
(*DBG: **)
(*DBG: * Copyright (C) 2023 Autonomy, GP Orcullo*)
(*DBG: * Based on the work by GP Orcullo on Beremiz for uC*)
(*DBG: **)
(*DBG: * This program is free software; you can redistribute it and/or*)
(*DBG: * modify it under the terms of the GNU General Public License*)
(*DBG: * as published by the Free Software Foundation; either version 2*)
(*DBG: * of the License, or (at your option) any later version.*)
(*DBG: **)
(*DBG: * This program is distributed in the hope that it will be useful,*)
(*DBG: * but WITHOUT ANY WARRANTY; without even the implied warranty of*)
(*DBG: * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the*)
(*DBG: * GNU General Public License for more details.*)
(*DBG: **)
(*DBG: * You should have received a copy of the GNU General Public License*)
(*DBG: * along with this program; If not, see <http://www.gnu.org/licenses/>.*)
(*DBG: **)
(*DBG: */*)
(*DBG:*)
(*DBG:#include <stdbool.h>*)
(*DBG:*)
(*DBG:#include "iec_types_all.h"*)
(*DBG:#include "POUS.h"*)
(*DBG:*)
(*DBG:#define SAME_ENDIANNESS      0*)
(*DBG:#define REVERSE_ENDIANNESS   1*)
(*DBG:*)
(*DBG:uint8_t endianness;*)
(*DBG:*)
(*DBG:*)
(*DBG:extern SLUDGE RES0__INSTANCE0;*)
(*DBG:*)
(*DBG:static const struct {*)
(*DBG:    void *ptr;*)
(*DBG:    __IEC_types_enum type;*)
(*DBG:} debug_vars[] = {*)
(*DBG:    {&(RES0__INSTANCE0.INLETVALVESTATUS), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.OVERFLOWSENSOR), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.PUMPSTATUS), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.DISINFECTANTSTATUS), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.GASHIGHVOLUMEALERT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INLETCONTROL), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.OUTLETCONTROL), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SLUDGEOUTPUMP), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.ACTIVATEPUMPADJUST), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.OVERFLOWVALVEOPEN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SOLIDWASTEALARM), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FILTRATIONCONTROL), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.THICKENINGPUMP), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.DIGESTERPUMP), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.HOTWATERPUMPIN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.HOTWATERPUMPOUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.GASPUMPTOTRANSPORT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.PHVALID), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.UVLOWERSTRENGTH), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.UVINCREASESTRENGTH), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INFLOWSENSOR), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.DISSOLVEDO2), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.PHSENSOR), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.TURBIDITYSENSOR), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.TSSSENSOR), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.UVPOWER), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.O2DEMAND), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SLUDGEPUMPVOLUME), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.CONST5), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.CONST500), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.CONST10000), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.PHUPPER), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.PHLOWER), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.TURBIDITYTHRESHOLD), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.TSSTHRESHOLD), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.UVUPPER), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.UVLOWER), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT8_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT21_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GE27_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT33_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT15_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_LT46_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_LT38_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_AND44_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_LT40_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT56_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_AND57_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_LT50_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT65_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_AND52_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_LT62_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT72_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_SUB39_OUT), INT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_LE77_OUT), BOOL_ENUM},*)
(*DBG:};*)
(*DBG:*)
(*DBG:#define VAR_COUNT               55*)
(*DBG:*)
(*DBG:uint16_t get_var_count(void)*)
(*DBG:{*)
(*DBG:    return VAR_COUNT;*)
(*DBG:}*)
(*DBG:*)
(*DBG:size_t get_var_size(size_t idx)*)
(*DBG:{*)
(*DBG:    if (idx >= VAR_COUNT)*)
(*DBG:    {*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case BOOL_ENUM:*)
(*DBG:        return sizeof(BOOL);*)
(*DBG:    case INT_ENUM:*)
(*DBG:        return sizeof(INT);*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void *get_var_addr(size_t idx)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case BOOL_ENUM:*)
(*DBG:        return (void *)&((__IEC_BOOL_t *) ptr)->value;*)
(*DBG:    case INT_ENUM:*)
(*DBG:        return (void *)&((__IEC_INT_t *) ptr)->value;*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void force_var(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    if (forced) {*)
(*DBG:        size_t var_size = get_var_size(idx);*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case BOOL_ENUM: {*)
(*DBG:            memcpy(&((__IEC_BOOL_t *) ptr)->value, val, var_size);*)
(*DBG:            //((__IEC_BOOL_t *) ptr)->value = *((BOOL *) val);*)
(*DBG:            ((__IEC_BOOL_t *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case INT_ENUM: {*)
(*DBG:            memcpy(&((__IEC_INT_t *) ptr)->value, val, var_size);*)
(*DBG:            //((__IEC_INT_t *) ptr)->value = *((INT *) val);*)
(*DBG:            ((__IEC_INT_t *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    } else {*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case BOOL_ENUM:*)
(*DBG:            ((__IEC_BOOL_t *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        case INT_ENUM:*)
(*DBG:            ((__IEC_INT_t *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void swap_bytes(void *ptr, size_t size) *)
(*DBG:{*)
(*DBG:    uint8_t *bytePtr = (uint8_t *)ptr;*)
(*DBG:    size_t i;*)
(*DBG:    for (i = 0; i < size / 2; ++i) *)
(*DBG:    {*)
(*DBG:        uint8_t temp = bytePtr[i];*)
(*DBG:        bytePtr[i] = bytePtr[size - 1 - i];*)
(*DBG:        bytePtr[size - 1 - i] = temp;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void trace_reset(void)*)
(*DBG:{*)
(*DBG:    for (size_t i=0; i < VAR_COUNT; i++) *)
(*DBG:    {*)
(*DBG:        force_var(i, false, 0);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_trace(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    if (idx >= 0 && idx < VAR_COUNT) *)
(*DBG:    {*)
(*DBG:        if (endianness == REVERSE_ENDIANNESS)*)
(*DBG:        {*)
(*DBG:            // Aaaaarghhhh... Stupid AVR is Big Endian.*)
(*DBG:            swap_bytes(val, get_var_size(idx));*)
(*DBG:        }*)
(*DBG:*)
(*DBG:        force_var(idx, forced, val);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_endianness(uint8_t value)*)
(*DBG:{*)
(*DBG:    if (value == SAME_ENDIANNESS || value == REVERSE_ENDIANNESS)*)
(*DBG:    {*)
(*DBG:        endianness = value;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
