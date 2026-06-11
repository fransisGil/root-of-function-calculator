unit secant;

interface

uses Vcl.Grids, evaluator, Math, SysUtils;

function SecantMethodWithGrid(funcExpr: string; x0, x1, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;

implementation

function SecantMethodWithGrid(funcExpr: string; x0, x1, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;
var
  f0, f1, x2, f2: Double;
  iter: Integer;

  procedure WriteRow(iterNum: Integer; v0, v1, v2, err: Double);
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
    grid.Cells[1, row] := FormatFloat('0.00000000', v0);
    grid.Cells[2, row] := FormatFloat('0.00000000', v1);
    grid.Cells[3, row] := FormatFloat('0.00000000', v2);
    grid.Cells[4, row] := FormatFloat('0.00000000', err);
    grid.Refresh;
  end;

begin
  f0 := EvaluateExpression(funcExpr, x0);
  f1 := EvaluateExpression(funcExpr, x1);
  iter := 0;

  repeat
    if Abs(f1 - f0) < 1e-12 then
      raise Exception.Create('Penyebut mendekati nol dalam metode Secant');
    x2 := x1 - f1 * (x1 - x0) / (f1 - f0);
    f2 := EvaluateExpression(funcExpr, x2);
    Inc(iter);

    WriteRow(iter, x0, x1, x2, Abs(x2 - x1));

    if Abs(f2) < toleransi then
    begin
      iterasi := iter;
      Result := x2;
      Exit;
    end;

    x0 := x1;
    f0 := f1;
    x1 := x2;
    f1 := f2;

    if iter >= maxIter then
      raise Exception.Create('Iterasi maksimum tercapai tanpa konvergensi');
  until False;
end;

end.
