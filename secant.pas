unit secant;

interface

uses evaluator, rootmethod;

type
  TSecant = class(TRootMethod)
    private

    public
      class function FindRoot(f: string):double; override;
  end;

implementation

class function TSecant.FindRoot(f: string): Double;
begin
  Result := 0;
end;

end.
