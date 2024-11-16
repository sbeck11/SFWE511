PROGRAM Sludge
  VAR
    InletValveStatus AT %IX0.12 : BOOL;
    OverflowSensor AT %IX0.13 : BOOL;
    PumpStatus AT %IX0.14 : BOOL;
    DisinfectantStatus AT %IX0.17 : BOOL;
    GasHighVolumeAlert AT %IX0.25 : BOOL;
    InletControl AT %QX0.1 : BOOL;
    OutletControl AT %QX0.2 : BOOL;
    SludgeOutPump AT %QX0.5 : BOOL;
    ActivatePumpAdjust AT %QX0.6 : BOOL;
    OverflowValveOpen AT %QX0.13 : BOOL;
    SolidWasteAlarm AT %QX0.15 : BOOL;
    FiltrationControl AT %QX0.16 : BOOL;
    ThickeningPump AT %QX0.20 : BOOL;
    DigesterPump AT %QX0.22 : BOOL;
    HotWaterPumpIn AT %QX0.23 : BOOL;
    HotWaterPumpOut AT %QX0.24 : BOOL;
    GasPumpToTransport AT %QX0.25 : BOOL;
    pHValid AT %QX0.26 : BOOL;
    UVLowerStrength AT %QX0.27 : BOOL;
    UVIncreaseStrength AT %QX0.28 : BOOL;
    InflowSensor AT %MW0.1 : INT;
    DissolvedO2 AT %MW0.3 : INT;
    pHSensor AT %MW0.4 : INT;
    TurbiditySensor AT %MW0.5 : INT;
    TSSSensor AT %MW0.7 : INT;
    UVPower AT %MW1.71 : INT;
    O2Demand AT %MW0.8 : INT;
    SludgePumpVolume AT %MW3.51 : INT;
    Const5 AT %MW3.5 : INT := 5;
    Const500 AT %MW3.6 : INT := 500;
    Const10000 AT %MW3.6 : INT := 10000;
    pHUpper AT %MW3.7 : INT := 8;
    pHLower AT %MW3.8 : INT := 6;
    TurbidityThreshold AT %MW3.52 : INT := 60;
    TSSThreshold AT %MW3.71 : INT := 275;
    UVUpper AT %MW3.81 : INT := 10500;
    UVLower AT %MW3.9 : INT := 9999;
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
    InfluentWaterFlow AT %IX0.1 : INT;
    EffluentWaterFlow AT %IX0.2 : INT;
    AirFlow AT %IX0.3 : INT;
    PretreatmentUnitFlow AT %IX0.4 : INT;
    ClarifierWaterDepth AT %IX0.5 : INT := 4;
    ClarifierWaterTemp AT %IX0.6 : INT;
    AerobicSurface AT %IX0.7 : INT;
    AerobicReactorAirflow AT %IX0.8 : LINT;
    AerobicWaterLevel AT %IX0.9 : INT;
    TSS AT %IX0.11 : INT;
    SandContainerFlow AT %IX0.18 : INT;
    SandWaterLevelHigh AT %IX0.19 : BOOL := 0;
    SecondaryClarifierWaterDepth AT %IX0.20 : INT := 0;
    BOD5 AT %IX0.21 : INT := 0;
    AirBlower AT %QX0.3 : BOOL;
    FerrousChemicalDeploy AT %QX0.4 : BOOL;
    PretreatInletControlStatus AT %QX1.1 : BOOL;
    PretreatOutletControlStatus AT %QX1.2 : BOOL;
    ScreeningContainerEffluentValve AT %QX1.3 : BOOL;
    SandContainerEffluentValve AT %QX1.4 : BOOL;
    ScreeningContSludgeEffluentValve AT %QX1.5 : BOOL;
    ClarifierOutletValve AT %QX1.6 : BOOL;
    SecondaryClarifierOutletValve AT %QX1.7 : BOOL;
    SecondaryClarifierSludgeValve AT %QX1.8 : BOOL;
    AirMinFlow AT %MW1.1 : LINT := 49923;
    AirMaxFlow AT %MW1.2 : LINT := 186302;
    TempMin AT %MW1.3 : INT := 17;
    TempMax AT %MW1.4 : INT := 30;
    DesignFlow AT %MW1.5 : INT := 10000;
    DryWeatherFlow AT %MW1.6 : INT := 27702;
    TSSThreshold AT %MW1.7 : INT := 275;
    BOD5Threshold AT %MW1.8 : INT := 313;
    InfluentFlowValveStatus AT %MW1.9 : BOOL := 0;
    ClarifierWaterDepthThreshold AT %MW1.10 : INT := 4;
    ClarifierSurface AT %MW1.11 : INT := 144;
    SecondClarifierDepthThresh AT %MW1.12 : INT := 4;
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
    FilterPresureSwitchHigh AT %IX0.15 : INT;
    FilterPressureSwitchLow AT %IX0.16 : INT;
    RoughingTricklingFilterVolume AT %MW0.0 : INT := 1063;
    RoughingCircularHumusTank AT %MW0.1 : INT := 144;
    Const144 AT %MW0.2 : INT := 144;
    Const1063 AT %MW0.3 : INT := 1063;
    SludgePumpControl AT %QX0.5 : BOOL;
    MixerControl AT %QX0.6 : BOOL;
    FilterFlowControlvalve AT %QX0.8 : BOOL;
    FilterationControl AT %QX0.16 : BOOL;
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