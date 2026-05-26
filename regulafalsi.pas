unit regulafalsi;

interface

uses Vcl.Grids, evaluator, Math, SysUtils;

function RegulaFalsiMethodWithGrid(funcName: string; a, b, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;

implementation

function RegulaFalsiMethodWithGrid(funcName: string; a, b, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;
var
  fa, fb, fc, c: Double;
  iter: Integer;
  row: Integer;

  procedure WriteRow(iterNum: Integer; valA, valB, valC, fA, fB, fC, err: Double);
  begin
    if (grid.RowCount = 2) and (iterNum = 1) then
      row := 1
    else
    begin
      row := grid.RowCount;
      grid.RowCount := row + 1;
    end;
    grid.Cells[0, row] := IntToStr(iterNum);
    grid.Cells[1, row] := FormatFloat('0.00000000', valA);
    grid.Cells[2, row] := FormatFloat('0.00000000', valB);
    grid.Cells[3, row] := FormatFloat('0.00000000', valC);
    grid.Cells[4, row] := FormatFloat('0.00000000', fA);
    grid.Cells[5, row] := FormatFloat('0.00000000', fB);
    grid.Cells[6, row] := FormatFloat('0.00000000', fC);
    grid.Cells[7, row] := FormatFloat('0.00000000', err);
    grid.Refresh;
  end;

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
    WriteRow(1, a, b, a, fa, fb, fa, 0);
    Exit;
  end;
  if Abs(fb) < toleransi then
  begin
    iterasi := 1;
    Result := b;
    WriteRow(1, a, b, b, fa, fb, fb, 0);
    Exit;
  end;

  if fa * fb >= 0 then
    raise Exception.Create(Format('Interval [%g, %g] tidak mengurung akar (f(a)=%g, f(b)=%g)', [a, b, fa, fb]));

  iter := 0;
  repeat
    c := (a * fb - b * fa) / (fb - fa);
    fc := EvaluateFunction(c);
    Inc(iter);

    WriteRow(iter, a, b, c, fa, fb, fc, Abs(c - (a+b)/2));

    if Abs(fc) < toleransi then
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
