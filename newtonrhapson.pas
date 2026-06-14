unit newtonrhapson;

interface

uses Vcl.Grids, evaluator, Math, SysUtils;

function NewtonRaphsonMethodWithGrid(funcExpr: string; tebakanAwal, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;

implementation

function Derivative(const funcExpr: string; x: Double): Double;
const
  h = 1e-6;
begin
  Result := (EvaluateExpression(funcExpr, x + h) - EvaluateExpression(funcExpr, x)) / h;
end;

function NewtonRaphsonMethodWithGrid(funcExpr: string; tebakanAwal, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;
var
  x, xn, fx, fpx: Double;
  iter: Integer;
  error: Double;

  procedure WriteRow(iterNum: Integer; xnVal, fxn, xnp1, err: Double);
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
    grid.Cells[1, row] := FormatFloat('0.00000000', xnVal);
    grid.Cells[2, row] := FormatFloat('0.00000000', fxn);
    grid.Cells[3, row] := FormatFloat('0.00000000', xnp1);
    grid.Cells[4, row] := FormatFloat('0.00000000', err);
    grid.Refresh;
  end;

begin
  x := tebakanAwal;
  iter := 0;
  repeat
    fx := EvaluateExpression(funcExpr, x);
    fpx := Derivative(funcExpr, x);
    if Abs(fpx) < 1e-12 then
      raise Exception.Create('Turunan mendekati nol, metode Newton gagal');
    xn := x - fx / fpx;
    Inc(iter);

    error := Abs(xn - x);
    WriteRow(iter, x, fx, xn, error);

    if error <= toleransi then
    begin
      iterasi := iter;
      Result := xn;
      Exit;
    end;

    x := xn;
    if iter >= maxIter then
      raise Exception.Create('Iterasi maksimum tercapai tanpa konvergensi');
  until False;
end;

end.
