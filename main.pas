unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, regulafalsi, bissection, secant, newtonrhapson,
  Vcl.Grids, Vcl.StdCtrls, Vcl.Menus;

type
  TAplikasi = class(TForm)
    StringGrid1: TStringGrid;
    MainMenu1: TMainMenu;
    Metode1: TMenuItem;
    Metode2: TMenuItem;
    ertutup1: TMenuItem;
    NewtonRaphson1: TMenuItem;
    NewtonRaphson2: TMenuItem;
    Bisection1: TMenuItem;
    Bisection2: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    edtError: TEdit;
    cmbFungsi: TComboBox;
    GroupBox1: TGroupBox;
    edtSelangA: TEdit;
    edtSelangB: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
 



  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Aplikasi: TAplikasi;

implementation

{$R *.dfm}






 procedure TAplikasi.FormCreate(Sender: TObject);
begin
  Screen.MenuFont := Aplikasi.Font;
end;

end.
