unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, regulafalsi, bissection, secant,
  newtonrhapson,
  Vcl.Grids, Vcl.StdCtrls, Vcl.Menus, System.Actions, Vcl.ActnList;

type
  TAplikasi = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    edtError: TEdit;
    cmbFungsi: TComboBox;
    GroupBox1: TGroupBox;
    edtSelangA: TEdit;
    edtSelangB: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    cmbMetode: TComboBox;
    MainMenu1: TMainMenu;
    Metode1: TMenuItem;
    metodeTerbuka: TMenuItem;
    metodeTertutup: TMenuItem;
    lblMetode: TLabel;
    ActionList1: TActionList;
    pilihTerbuka: TAction;
    pilihTertutup: TAction;
    procedure toggleSelang(switch: boolean = false);
    procedure FormCreate(Sender: TObject);
    procedure edtErrorKeyPress(Sender: TObject; var Key: Char);
    procedure metodeClick(Sender: TObject);
    procedure pilihTerbukaExecute(Sender: TObject);
    procedure pilihTertutupExecute(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Aplikasi: TAplikasi;

implementation

{$R *.dfm}

procedure TAplikasi.toggleSelang(switch: boolean = false);
begin
  GroupBox1.Enabled := switch;
  GroupBox1.Visible := switch;
end;

procedure TAplikasi.edtErrorKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0' .. '9', #8]) then
  begin
    if (Key = '.') then
    begin
      if Pos(Key, edtError.Text) > 1 then
      begin
        Key := #0
      end;
    end
    else
      Key := #0;
  end
end;

procedure TAplikasi.FormCreate(Sender: TObject);
var
  index: integer;
begin
  // lblMetode.Caption := MainMenu1.Items.Items[0].Items[0].Name;
  with MainMenu1.Items.Items[0] do
  begin
    for index := 0 to Count - 1 do
    begin
      if Items[index].Default then
      begin
        lblMetode.Caption := Items[index].Name;
        Items[index].InitiateAction;
        exit
      end;
    end;
  end;
end;

procedure TAplikasi.metodeClick(Sender: TObject);
var
  clickedItem: TMenuItem;
begin
  clickedItem := TMenuItem(Sender);
  if clickedItem.Name = 'regulafalsi' then
    toggleSelang(false)
  else
    toggleSelang(true);
end;

procedure TAplikasi.pilihTerbukaExecute(Sender: TObject);
begin
  cmbMetode.Items.Clear;
  cmbMetode.Items.Add('Newton Rhapson');
  cmbMetode.Items.Add('Secant');
end;

procedure TAplikasi.pilihTertutupExecute(Sender: TObject);
begin
  cmbMetode.Items.Clear;
  cmbMetode.Items.Add('Bisection');
  cmbMetode.Items.Add('Regula Falsi');
end;

end.
