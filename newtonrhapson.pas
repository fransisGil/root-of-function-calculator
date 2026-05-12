unit newtonrhapson;

interface

uses evaluator, rootmethod;

type
  TNewtonRhapson = class(TRootMethod)
    private

    public
      class function FindRoot(f: string):double; override;
  end;

implementation

class function TNewtonRhapson.FindRoot(f: string): Double;
begin
  Result := 0;
end;

end.
