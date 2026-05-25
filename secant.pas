unit secant;

interface

function SecantMethod(funcName: string; x0, x1, toleransi: Double; maxIter: Integer; var iterasi: Integer): Double;

implementation

uses evaluator, Math, SysUtils;

function SecantMethod(funcName: string; x0, x1, toleransi: Double; maxIter: Integer; var iterasi: Integer): Double;
var
  f0, f1, x2: Double;
  iter: Integer;
begin
  CurrentFunctionIndex := GetFunctionIndex(funcName);
  if CurrentFunctionIndex = -1 then
    raise Exception.Create('Fungsi tidak dikenal: ' + funcName);

  f0 := EvaluateFunction(x0);
  f1 := EvaluateFunction(x1);
  iter := 0;
  repeat
    if Abs(f1 - f0) < 1e-12 then
      raise Exception.Create('Penyebut mendekati nol dalam metode Secant');
    x2 := x1 - f1 * (x1 - x0) / (f1 - f0);
    Inc(iter);
    if Abs(EvaluateFunction(x2)) < toleransi then
    begin
      iterasi := iter;
      Result := x2;
      Exit;
    end;
    x0 := x1;
    f0 := f1;
    x1 := x2;
    f1 := EvaluateFunction(x1);
    if iter >= maxIter then
      raise Exception.Create('Iterasi maksimum tercapai tanpa konvergensi');
  until False;
end;

end.
