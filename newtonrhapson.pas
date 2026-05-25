unit newtonrhapson;

interface

function NewtonRaphsonMethod(funcName: string; tebakanAwal, toleransi: Double; maxIter: Integer; var iterasi: Integer): Double;

implementation

uses evaluator, Math, SysUtils;

function Derivative(x: Double): Double;
begin
  case CurrentFunctionIndex of
    0: Result := 2 * x;
    1: Result := 3 * x * x - 1;
    2: Result := Exp(x) - 3;
    3: Result := Cos(x);
  else
    Result := 0;
  end;
end;

function NewtonRaphsonMethod(funcName: string; tebakanAwal, toleransi: Double; maxIter: Integer; var iterasi: Integer): Double;
var
  x, fx, fpx: Double;
  iter: Integer;
begin
  CurrentFunctionIndex := GetFunctionIndex(funcName);
  if CurrentFunctionIndex = -1 then
    raise Exception.Create('Fungsi tidak dikenal: ' + funcName);

  x := tebakanAwal;
  iter := 0;
  repeat
    fx := EvaluateFunction(x);
    fpx := Derivative(x);
    if Abs(fpx) < 1e-12 then
      raise Exception.Create('Turunan mendekati nol, metode Newton gagal');
    x := x - fx / fpx;
    Inc(iter);
    if Abs(EvaluateFunction(x)) < toleransi then
    begin
      iterasi := iter;
      Result := x;
      Exit;
    end;
    if iter >= maxIter then
      raise Exception.Create('Iterasi maksimum tercapai tanpa konvergensi');
  until False;
end;

end.
