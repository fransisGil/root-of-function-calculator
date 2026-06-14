unit bissection;

interface

uses Vcl.Grids, evaluator, Math, SysUtils;

function BiseksiMethodWithGrid(funcExpr: string; a, b, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;

implementation

function BiseksiMethodWithGrid(funcExpr: string; a, b, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;
var
  fa, fb, fc, c: Double;
  iter: Integer;
  a_old, b_old, fa_old, fb_old: Double;
  selang: string;
  error: Double;

  procedure WriteRow(iterNum: Integer; A, B, C, FA, FB, FC: Double; const Selang: string; Err: Double);
  var
    row: Integer;
  begin
    if (grid.RowCount = 2) and (iterNum = 1) then
      row := 1
    else
    begin
      row := grid.RowCount;
      grid.RowCount := row + 1;
    end;
    grid.Cells[0, row] := IntToStr(iterNum);
    grid.Cells[1, row] := FormatFloat('0.00000000', A);
    grid.Cells[2, row] := FormatFloat('0.00000000', B);
    grid.Cells[3, row] := FormatFloat('0.00000000', C);
    grid.Cells[4, row] := FormatFloat('0.00000000', FA);
    grid.Cells[5, row] := FormatFloat('0.00000000', FB);
    grid.Cells[6, row] := FormatFloat('0.00000000', FC);
    grid.Cells[7, row] := Selang;
    grid.Cells[8, row] := FormatFloat('0.00000000', Err);
    grid.Refresh;
  end;

begin
  if a > b then
  begin
    c := a; a := b; b := c;
  end;

  fa := EvaluateExpression(funcExpr, a);
  fb := EvaluateExpression(funcExpr, b);

  if Abs(fa) < toleransi then
  begin
    iterasi := 1;
    Result := a;
    WriteRow(1, a, b, a, fa, fb, fa, 'Akar', 0);
    Exit;
  end;
  if Abs(fb) < toleransi then
  begin
    iterasi := 1;
    Result := b;
    WriteRow(1, a, b, b, fa, fb, fb, 'Akar', 0);
    Exit;
  end;

  if fa * fb >= 0 then
    raise Exception.Create(Format('Interval [%g, %g] tidak mengurung akar (f(a)=%g, f(b)=%g)', [a, b, fa, fb]));

  iter := 0;
  repeat
    a_old := a; b_old := b;
    fa_old := fa; fb_old := fb;

    c := (a + b) / 2;
    fc := EvaluateExpression(funcExpr, c);
    Inc(iter);

      // Error = setengah panjang interval
    error := Abs(b_old - a_old) / 2;

    if fa * fc < 0 then
    begin
      selang := Format('[%g, %g]', [a, c]);
      b := c;
      fb := fc;
    end
    else
    begin
      selang := Format('[%g, %g]', [c, b]);
      a := c;
      fa := fc;
    end;

    WriteRow(iter, a_old, b_old, c, fa_old, fb_old, fc, selang, error);

    if error <= toleransi then
    begin
      iterasi := iter;
      Result := c;
      Exit;
    end;

    if iter >= maxIter then
      raise Exception.Create('Iterasi maksimum tercapai tanpa konvergensi');
  until False;
end;

end.
