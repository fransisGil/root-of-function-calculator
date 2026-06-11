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
  main_old in 'main_old.pas' {Form1},
  main_new in 'main_new.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAplikasi, Aplikasi);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
