program rootOfFunctionCalc;

uses
  Vcl.Forms,
  evaluator in 'evaluator.pas',
  newtonrhapson in 'newtonrhapson.pas',
  regulafalsi in 'regulafalsi.pas',
  bissection in 'bissection.pas',
  secant in 'secant.pas',
  rootmethod in 'rootmethod.pas',
  tree in 'tree.pas',
  stack in 'stack.pas',
  main_new in 'main_new.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.