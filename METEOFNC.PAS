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

Function  GetDryAirEnthalpy(TDryBulb:Real):Real;
Function  GetHumRatioFromSpecificHum(SpecificHum:Real):Real;
Function  GetSpecificHumFromHumRatio(HumRatio:Real):Real;
Function  GetVapPresFromHumRatio(HumRatio,Pressure:Real):Real;
Function  GetCurrUnitSystem:Byte;
Procedure SetCurrUnitSystme(X:Byte);

IMPLEMENTATION

Var
 MeteoUnits:Byte;

Function Max(A,B:Real):Real;Begin
 If A>B Then Max:=A
        Else Max:=B;
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