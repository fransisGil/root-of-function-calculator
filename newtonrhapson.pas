unit newtonrhapson;

interface

uses Vcl.Grids, evaluator, Math, SysUtils;

function NewtonRaphsonMethodWithGrid(funcName: string; tebakanAwal, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;

implementation

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

function NewtonRaphsonMethodWithGrid(funcName: string; tebakanAwal, toleransi: Double; maxIter: Integer;
  var iterasi: Integer; grid: TStringGrid): Double;
var
  x, xn, fx, fpx: Double;
  iter: Integer;
  row: Integer;

  procedure WriteRow(iterNum: Integer; xnVal, fxn, dfxn, xnp1, err: Double);
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
    grid.Cells[3, row] := FormatFloat('0.00000000', dfxn);
    grid.Cells[4, row] := FormatFloat('0.00000000', xnp1);
    grid.Cells[5, row] := FormatFloat('0.00000000', err);
    grid.Refresh;
  end;

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
    xn := x - fx / fpx;
    Inc(iter);

    WriteRow(iter, x, fx, fpx, xn, Abs(xn - x));

    if Abs(EvaluateFunction(xn)) < toleransi then
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
