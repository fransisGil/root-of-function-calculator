unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Menus,
  evaluator, bissection, regulafalsi, secant, newtonrhapson;

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
    btnHitung: TButton;
    cmbMetode: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnHitungClick(Sender: TObject);
    procedure ertutup1Click(Sender: TObject);
  private
    procedure TampilkanHasil(metode, fungsi: string; iterasi: Integer; akar: Double);
    function GetTolerance: Double;
    function GetSelectedFunctionName: string;
    function GetIntervalA: Double;
    function GetIntervalB: Double;
    function GetInitialGuess: Double;
  public
    { Public declarations }
  end;

var
  Aplikasi: TAplikasi;

implementation

{$R *.dfm}

function StrToDoubleSafe(const S: string; out Value: Double): Boolean;
var
  s2: string;
  code: Integer;
begin
  s2 := Trim(S);
  s2 := StringReplace(s2, ',', '.', [rfReplaceAll]);
  Val(s2, Value, code);
  Result := (code = 0);
end;

function TAplikasi.GetTolerance: Double;
begin
  if not StrToDoubleSafe(edtError.Text, Result) then
    raise Exception.Create('Toleransi tidak valid: ' + edtError.Text);
end;

function TAplikasi.GetIntervalA: Double;
begin
  if not StrToDoubleSafe(edtSelangA.Text, Result) then
    raise Exception.Create('Interval A tidak valid: ' + edtSelangA.Text);
end;

function TAplikasi.GetIntervalB: Double;
begin
  if not StrToDoubleSafe(edtSelangB.Text, Result) then
    raise Exception.Create('Interval B tidak valid: ' + edtSelangB.Text);
end;

function TAplikasi.GetSelectedFunctionName: string;
begin
  Result := cmbFungsi.Text;
end;

function TAplikasi.GetInitialGuess: Double;
begin
  Result := (GetIntervalA + GetIntervalB) / 2;
end;

procedure TAplikasi.FormCreate(Sender: TObject);
begin
  cmbFungsi.Items.Clear;
  cmbFungsi.Items.Add('x^2 - 4');
  cmbFungsi.Items.Add('x^3 - x - 2');
  cmbFungsi.Items.Add('e^x - 3x');
  cmbFungsi.Items.Add('sin(x) - 0.5');
  cmbFungsi.ItemIndex := 0;

  cmbMetode.Items.Clear;
  cmbMetode.Items.Add('Biseksi');
  cmbMetode.Items.Add('Regula Falsi');
  cmbMetode.Items.Add('Secant');
  cmbMetode.Items.Add('Newton Raphson');
  cmbMetode.ItemIndex := 0;

  edtError.Text := '0.00001';
  edtSelangA.Text := '0';
  edtSelangB.Text := '2';

  StringGrid1.ColCount := 5;
  StringGrid1.FixedRows := 1;
  StringGrid1.RowCount := 1;
  StringGrid1.Cells[0, 0] := 'Metode';
  StringGrid1.Cells[1, 0] := 'Fungsi';
  StringGrid1.Cells[2, 0] := 'Iterasi';
  StringGrid1.Cells[3, 0] := 'Akar Pendekatan';
  StringGrid1.Cells[4, 0] := 'f(Akar)';

  StringGrid1.DefaultColWidth := 100;
  StringGrid1.ColWidths[0] := 130;
  StringGrid1.ColWidths[1] := 140;
  StringGrid1.ColWidths[2] := 70;
  StringGrid1.ColWidths[3] := 170;
  StringGrid1.ColWidths[4] := 200;
end;

procedure TAplikasi.TampilkanHasil(metode, fungsi: string; iterasi: Integer; akar: Double);
var
  row: Integer;
  nilaiFungsi: Double;
begin
  CurrentFunctionIndex := GetFunctionIndex(fungsi);
  nilaiFungsi := EvaluateFunction(akar);
  row := StringGrid1.RowCount;
  StringGrid1.RowCount := row + 1;
  StringGrid1.Cells[0, row] := metode;
  StringGrid1.Cells[1, row] := fungsi;
  StringGrid1.Cells[2, row] := IntToStr(iterasi);
  StringGrid1.Cells[3, row] := FormatFloat('0.00000000', akar);
  StringGrid1.Cells[4, row] := FormatFloat('0.00000000', nilaiFungsi);
  StringGrid1.Refresh;
  ShowMessage(Format('%s - %s selesai. Akar = %.8f (iterasi %d)', [metode, fungsi, akar, iterasi]));
end;

procedure TAplikasi.btnHitungClick(Sender: TObject);
var
  a, b, tol, tebakan, akar: Double;
  iterasi: Integer;
  fungsi: string;
begin
  try
    a := GetIntervalA;
    b := GetIntervalB;
    tol := GetTolerance;
    fungsi := GetSelectedFunctionName;

    if a >= b then
      raise Exception.Create('Nilai A harus lebih kecil dari B');

    case cmbMetode.ItemIndex of
      0: akar := BiseksiMethod(fungsi, a, b, tol, 100, iterasi);
      1: akar := RegulaFalsiMethod(fungsi, a, b, tol, 100, iterasi);
      2: akar := SecantMethod(fungsi, a, b, tol, 100, iterasi);
      3:
      begin
        tebakan := (a + b) / 2;
        akar := NewtonRaphsonMethod(fungsi, tebakan, tol, 100, iterasi);
      end;
    else
      ShowMessage('Pilih metode yang valid');
      Exit;
    end;
    TampilkanHasil(cmbMetode.Text, fungsi, iterasi, akar);
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

procedure TAplikasi.ertutup1Click(Sender: TObject);
begin
  Close;
end;

end.
