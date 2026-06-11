unit rootmethod;

interface

type
  TRootMethod = class
  protected
    FTolerance: Double;
    FMaxIter: Integer;
    FIterations: Integer;
    FFunctionStr: string;
  public
    constructor Create(tol: Double; maxIter: Integer; funcStr: string);
    function FindRoot: Double; virtual; abstract;
    property Iterations: Integer read FIterations;
  end;

implementation

constructor TRootMethod.Create(tol: Double; maxIter: Integer; funcStr: string);
begin
  FTolerance := tol;
  FMaxIter := maxIter;
  FFunctionStr := funcStr;
  FIterations := 0;
end;

end.
