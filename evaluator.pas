unit evaluator;

interface

var
  CurrentFunctionIndex: Integer;

function EvaluateFunction(x: Double): Double;
function GetFunctionIndex(const funcName: string): Integer;

implementation

function EvaluateFunction(x: Double): Double;
begin
  case CurrentFunctionIndex of
    0: Result := x * x - 4;
    1: Result := x * x * x - x - 2;
    2: Result := Exp(x) - 3 * x;
    3: Result := Sin(x) - 0.5;
  else
    Result := 0;
  end;
end;

function GetFunctionIndex(const funcName: string): Integer;
begin
  if funcName = 'x^2 - 4' then Result := 0
  else if funcName = 'x^3 - x - 2' then Result := 1
  else if funcName = 'e^x - 3x' then Result := 2
  else if funcName = 'sin(x) - 0.5' then Result := 3
  else Result := -1;
end;

end.
