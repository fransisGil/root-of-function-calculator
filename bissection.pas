unit bissection;

interface

function BiseksiMethod(funcName: string; a, b, toleransi: Double; maxIter: Integer; var iterasi: Integer): Double;

implementation

uses evaluator, Math, SysUtils;

function BiseksiMethod(funcName: string; a, b, toleransi: Double; maxIter: Integer; var iterasi: Integer): Double;
var
  fa, fb, fc, c: Double;
  iter: Integer;
begin
  CurrentFunctionIndex := GetFunctionIndex(funcName);
  if CurrentFunctionIndex = -1 then
    raise Exception.Create('Fungsi tidak dikenal: ' + funcName);

  if a > b then
  begin
    c := a; a := b; b := c;
  end;

  fa := EvaluateFunction(a);
  fb := EvaluateFunction(b);

  if Abs(fa) < toleransi then
  begin
    iterasi := 1;
    Result := a;
    Exit;
  end;
  if Abs(fb) < toleransi then
  begin
    iterasi := 1;
    Result := b;
    Exit;
  end;

  if fa * fb >= 0 then
    raise Exception.Create(Format('Interval [%g, %g] tidak mengurung akar (f(a)=%g, f(b)=%g)', [a, b, fa, fb]));

  iter := 0;
  repeat
    c := (a + b) / 2;
    fc := EvaluateFunction(c);
    Inc(iter);
    if (Abs(fc) < toleransi) or ((b - a) / 2 < toleransi) then
    begin
      iterasi := iter;
      Result := c;
      Exit;
    end;
    if fa * fc < 0 then
    begin
      b := c;
      fb := fc;
    end
    else
    begin
      a := c;
      fa := fc;
    end;
    if iter >= maxIter then
      raise Exception.Create('Iterasi maksimum tercapai tanpa konvergensi');
  until False;
end;

end.
