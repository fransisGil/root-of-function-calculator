unit evaluator;

interface

uses tree, stack;

type
  TEvaluator = class
    public
      class function evaluate(f: string; x: double): double;
  end;


implementation

class function TEvaluator.evaluate(f: string; x: Double):  double;
begin
  Result := 0;
end;

end.
