{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/METEOLIB-TP)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Unit METEOFNC;

INTERFACE

Const
 UnitSystemSI=0; { SystŠme internationale }
 UnitSystemIP=1; { SystŠme imp‚riale }

 MIN_HUM_RATIO=1E-7;
 TRIPLE_POINT_WATER_IP=32.018;
 TRIPLE_POINT_WATER_SI=0.01;
 R_DA_IP=53.350;
 R_DA_SI=287.042;

Function  dLnPws(TDryBulb:Real):Real;
Function  GetCurrUnitSystem:Byte;
Function  GetDryAirDensity(TDryBulb,Pressure:Real):Real;
Function  GetDryAirVolume(TDryBulb,Pressure:Real):Real;
Function  GetDryAirEnthalpy(TDryBulb:Real):Real;
Function  GetHumRatioFromEnthalpyAndTDryBulb(MoistAirEnthalpy,TDryBulb:Real):Real;
Function  GetHumRatioFromSpecificHum(SpecificHum:Real):Real;
Function  GetHumRatioFromVapPres(VapPres,Pressure:Real):Real;
Function  GetSpecificHumFromHumRatio(HumRatio:Real):Real;
Function  GetTDryBulbFromEnthalpyAndHumRatio(MoistAirEnthalpy,HumRatio:Real):Real;
Function  GetVapPresFromHumRatio(HumRatio,Pressure:Real):Real;
Procedure SetCurrUnitSystme(X:Byte);

IMPLEMENTATION

Uses CONVERS;

Var
 MeteoUnits:Byte;

Function Max(A,B:Real):Real;Begin
 If A>B Then Max:=A
        Else Max:=B;
End;

Function POW(a,b:Real):Real;
Var
 p:Real;
 I:Integer;
Begin
 p:=1;
 For i:=1 to Trunc(b) do Begin
  p := p * a;
 End;
 Pow:=p;
End;

{ @description: Cette fonction permet de retourner la pression
                de vapeur de retour en fonction du taux d'humidit‚
                et de la pression.
  @param:       HumRatio: Taux d'humidit‚ en lb_H2O ou kg_H2O kg_Air
                Pressure: Pression atmosph‚rique en Psi ou Pa
}

Function GetVapPresFromHumRatio(HumRatio,Pressure:Real):Real;
Var
 BoundedHumRatio:Real;
Begin
 BoundedHumRatio:=Max(HumRatio,MIN_HUM_RATIO);
 GetVapPresFromHumRatio:=Pressure*BoundedHumRatio/(0.621945+BoundedHumRatio);
End;

{ @description: Cette fonction permet de retourner l'humidit‚
                sp‚cifique … partir du rapport d'humidit‚
                (c'est-…-dire le rapport de m‚lange).
  @param:       HumRatio: Taux d'humidit‚ en lb_H2O ou kg_H2O kg_Air
}

Function GetSpecificHumFromHumRatio(HumRatio:Real):Real;
Var
 BoundedHumRatio:Real;
Begin
 BoundedHumRatio:=Max(HumRatio,MIN_HUM_RATIO);
 GetSpecificHumFromHumRatio:=BoundedHumRatio/(1.0+BoundedHumRatio);
End;

{ @description: Cette fonction permet de retourner le taux
                d'humidit‚ (c'est-…-dire le taux de m‚lange) …
                partir d'une humidit‚ sp‚cifique.
  @param: SpecificHum: Taux d'humidit‚ sp‚cifique en lb_H2O ou kg_H2O
}

Function GetHumRatioFromSpecificHum(SpecificHum:Real):Real;
Var
 HumRatio:Real;
Begin
 HumRatio:=SpecificHum/(1.0-SpecificHum);
 GetHumRatioFromSpecificHum:=Max(HumRatio,MIN_HUM_RATIO);
End;

{ @description: Cette fonction permet de retourner l'enthalpie
                de l'air sec en fonction de la temp‚rature
                du bulbe sec.
}

Function GetDryAirEnthalpy(TDryBulb:Real):Real;Begin
 If(MeteoUnits=UnitSystemIP)Then GetDryAirEnthalpy:=0.240*TDryBulb
                            Else GetDryAirEnthalpy:=1006*TDryBulb;
End;

{ @description: Cette fonction permet de retourner la d‚riv‚e du
                logarithme naturel de la pression de vapeur saturante
                en fonction de la temp‚rature du bulbe sec.
}

Function dLnPws(TDryBulb:Real):Real;
Var
 R,T:Real;
Begin
 If(MeteoUnits=UnitSystemIP)Then Begin
  T:=FahrToRankine(TDryBulb);
  If(TDryBulb<=TRIPLE_POINT_WATER_IP)Then Begin
   R:=1.0214165E+04/Pow(T,2)-5.3765794E-03+2*1.9202377E-07*T+
      3*3.5575832E-10*Pow(T,2)-4*9.0344688E-14*Pow(T,3)+4.1635019/T;
  End
   Else
  Begin
   R:=1.0440397E+04/Pow(T,2)-2.7022355E-02+2*1.2890360E-05*T-
      3*2.4780681E-09*Pow(T,2)+6.5459673/T;
  End;
 End
  Else
 Begin
  T:=CelsiusToKelvin(TDryBulb);
  If(TDryBulb<=TRIPLE_POINT_WATER_SI)Then Begin
   R:=5.6745359E+03/Pow(T,2)-9.677843E-03+2*6.2215701E-07*T+
      3*2.0747825E-09*Pow(T,2)-4*9.484024E-13*Pow(T,3)+4.1635019/T;
  End
   Else
  Begin
   R:=5.8002206E+03/Pow(T,2)-4.8640239E-02+2*4.1764768E-05*T-
      3*1.4452093E-08*Pow(T,2)+6.5459673/T;
  End;
 End;
 dLnPws:=R;
End;

{ @description: Cette fonction permet de retourner le taux d'humidit‚
                de retour ‚tant donn‚ la pression de vapeur d'eau et
                la pression atmosph‚rique.
}

Function GetHumRatioFromVapPres(VapPres,Pressure:Real):Real;
Var
 HumRatio:Real;
Begin
 HumRatio:=0.621945*VapPres/(Pressure-VapPres);
 GetHumRatioFromVapPres:=Max(HumRatio,MIN_HUM_RATIO);
End;

{ @description: Cette fonction permet de retourner la densit‚ de l'air
                sec en fonction de la temp‚rature et de la pression
                du bulbe sec.
}

Function GetDryAirDensity(TDryBulb,Pressure:Real):Real;Begin
 If(MeteoUnits=UnitSystemIP)Then Begin
  GetDryAirDensity:=(144.0*Pressure)/R_DA_IP/FahrToRankine(TDryBulb);
 End
  Else
 Begin
  GetDryAirDensity:=Pressure/R_DA_SI/CelsiusToKelvin(TDryBulb);
 End;
End;

{ @description: Cette fonction permet de restituer le volume d'air
                sec en fonction de la temp‚rature et de la pression
                du bulbe sec.
}

Function GetDryAirVolume(TDryBulb,Pressure:Real):Real;Begin
 If(MeteoUnits=UnitSystemIP)Then Begin
  GetDryAirVolume:=R_DA_IP*FahrToRankine(TDryBulb)/(144.0*Pressure);
 End
  Else
 Begin
  GetDryAirVolume:=R_DA_SI*CelsiusToKelvin(TDryBulb)/Pressure;
 End;
End;

{ @description: Cette fonction permet de retourner la temp‚rature du
                bulbe sec … partir du rapport d'enthalpie et d'humidit‚.
}

Function GetTDryBulbFromEnthalpyAndHumRatio(MoistAirEnthalpy,HumRatio:Real):Real;
Var
 BoundedHumRatio:Real;
Begin
 BoundedHumRatio:=Max(HumRatio,MIN_HUM_RATIO);
 If(MeteoUnits=UnitSystemIP)Then Begin
  GetTDryBulbFromEnthalpyAndHumRatio:=(MoistAirEnthalpy-1061.0*BoundedHumRatio)/(0.240+0.444*BoundedHumRatio);
 End
  Else
 Begin
  GetTDryBulbFromEnthalpyAndHumRatio:=(MoistAirEnthalpy/1000.0-2501.0*BoundedHumRatio)/(1.006+1.86*BoundedHumRatio);
 End;
End;

{ @description: Cette fonction permet de retourner le rapport d'humidit‚
                … partir de l'enthalpie et de la temp‚rature du bulbe sec.
}

Function GetHumRatioFromEnthalpyAndTDryBulb(MoistAirEnthalpy,TDryBulb:Real):Real;
Var
 HumRatio:Real;
Begin
 If(MeteoUnits=UnitSystemIP)Then Begin
  HumRatio:=(MoistAirEnthalpy-0.240*TDryBulb)/(1061.0+0.444*TDryBulb);
 End
  Else
 Begin
  HumRatio:=(MoistAirEnthalpy/1000.0-1.006*TDryBulb)/(2501.0+1.86*TDryBulb);
 End;
 GetHumRatioFromEnthalpyAndTDryBulb:=Max(HumRatio,MIN_HUM_RATIO);
End;


Function GetCurrUnitSystem:Byte;Begin
 GetCurrUnitSystem:=MeteoUnits;
End;

Procedure SetCurrUnitSystme(X:Byte);Begin
 If X in[UnitSystemSI,UnitSystemIP]Then Begin
  MeteoUnits:=X;
 End;
End;

BEGIN
 MeteoUnits:=UnitSystemSI;
END.
