unit rootmethod;

interface

uses evaluator;

type
  TRootMethod = class
    public
      class function FindRoot(f: string): double; virtual;
  end;

implementation

class function TRootMethod.FindRoot(f: string): double;
begin
  Result := 0;
end;

end.
