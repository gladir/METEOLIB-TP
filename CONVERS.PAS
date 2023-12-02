{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/METEOLIB-TP)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Unit CONVERS;

INTERFACE

Function CentToFahr(Cent:Real):Real;
Function CentToKelvin(Cent:Real):Real;
Function CentToRankine(Celsius:Real):Real;
Function FahrToCent(Fahr:Real):Real;
Function KelvinToCent(Kelvin:Real):Real;
Function KelvinToFahr(Kelvin:Real):Real;
Function NewtonToCent(Newton:Real):Real;
Function RankineToCent(Rankine:Real):Real;
Function RankineToFahr(Rankine:Real):Real;
Function ReaumurToCent(Reaumur:Real):Real;

IMPLEMENTATION

Function FahrToCent(Fahr:Real):Real;Begin
 FahrToCent:=(5.0/9.0)*(Fahr-32.0);
End;

Function CentToFahr(Cent:Real):Real;Begin
 CentToFahr:=1.8*Cent+32.0;
End;

Function CentToKelvin(Cent:Real):Real;Begin
 CentToKelvin:=Cent+273.16;
End;

Function KelvinToCent(Kelvin:Real):Real;Begin
 KelvinToCent:=Kelvin-273.16;
End;

Function KelvinToFahr(Kelvin:Real):Real;Begin
 KelvinToFahr:=1.8*(Kelvin-273.16)+32.0;
End;

Function RankineToCent(Rankine:Real):Real;Begin
 RankineToCent:=(5.0/9.0)*(Rankine-491.69);
End;

Function CentToRankine(Celsius:Real):Real;Begin
 CentToRankine:=(Celsius*1.8)+491.69;
End;

Function RankineToFahr(Rankine:Real):Real;Begin
 RankineToFahr:=Rankine-459.69;
End;

Function ReaumurToCent(Reaumur:Real):Real;Begin
 ReaumurToCent:=Reaumur*5/4;
End;

Function NewtonToCent(Newton:Real):Real;Begin
 NewtonToCent:=Newton*100/33;
End;

END.