unit regulafalsi;

interface

uses evaluator, rootmethod;

type
  TRegulaFalsi = class(TRootMethod)
    private

    public
      class function FindRoot(f: string):double; override;
  end;

var
  default_tolerance_limit : Double;

implementation

class function TRegulaFalsi.FindRoot(f: string): Double;
begin
  Result := 0;
end;

end.
