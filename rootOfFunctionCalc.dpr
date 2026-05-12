program rootOfFunctionCalc;

uses
  Vcl.Forms,
  main in 'main.pas' {Aplikasi},
  evaluator in 'evaluator.pas',
  newtonrhapson in 'newtonrhapson.pas',
  regulafalsi in 'regulafalsi.pas',
  bissection in 'bissection.pas',
  secant in 'secant.pas',
  rootmethod in 'rootmethod.pas',
  tree in 'tree.pas',
  stack in 'stack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAplikasi, Aplikasi);
  Application.Run;
end.
