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
    procedure cmbMetodeChange(Sender: TObject);
  private
    procedure ClearGrid;
    procedure SetupGridForMethod;
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

procedure TAplikasi.ClearGrid;
begin
  // Hapus semua baris data, sisakan header
  if StringGrid1.RowCount > 1 then
    StringGrid1.RowCount := 2; // baris 0 header, baris 1 kosong
  StringGrid1.FixedRows := 1;
  // Kosongkan baris data (baris 1)
  if StringGrid1.ColCount > 0 then
    StringGrid1.Rows[1].Clear;
  StringGrid1.Refresh;
end;

procedure TAplikasi.SetupGridForMethod;
var
  metode: string;
  i: Integer;
begin
  metode := cmbMetode.Text;
  // Atur jumlah kolom dan header
  if metode = 'Biseksi' then
  begin
    StringGrid1.ColCount := 8;
    StringGrid1.Cells[0,0] := 'Iterasi';
    StringGrid1.Cells[1,0] := 'A';
    StringGrid1.Cells[2,0] := 'B';
    StringGrid1.Cells[3,0] := 'C';
    StringGrid1.Cells[4,0] := 'f(A)';
    StringGrid1.Cells[5,0] := 'f(B)';
    StringGrid1.Cells[6,0] := 'f(C)';
    StringGrid1.Cells[7,0] := 'Error';
    for i := 0 to 7 do StringGrid1.ColWidths[i] := 80;
    StringGrid1.ColWidths[0] := 60;
  end
  else if metode = 'Regula Falsi' then
  begin
    StringGrid1.ColCount := 8;
    StringGrid1.Cells[0,0] := 'Iterasi';
    StringGrid1.Cells[1,0] := 'A';
    StringGrid1.Cells[2,0] := 'B';
    StringGrid1.Cells[3,0] := 'C';
    StringGrid1.Cells[4,0] := 'f(A)';
    StringGrid1.Cells[5,0] := 'f(B)';
    StringGrid1.Cells[6,0] := 'f(C)';
    StringGrid1.Cells[7,0] := 'Error';
    for i := 0 to 7 do StringGrid1.ColWidths[i] := 80;
    StringGrid1.ColWidths[0] := 60;
  end
  else if metode = 'Secant' then
  begin
    StringGrid1.ColCount := 8;
    StringGrid1.Cells[0,0] := 'Iterasi';
    StringGrid1.Cells[1,0] := 'X0';
    StringGrid1.Cells[2,0] := 'X1';
    StringGrid1.Cells[3,0] := 'X2';
    StringGrid1.Cells[4,0] := 'f(X0)';
    StringGrid1.Cells[5,0] := 'f(X1)';
    StringGrid1.Cells[6,0] := 'f(X2)';
    StringGrid1.Cells[7,0] := 'Error';
    for i := 0 to 7 do StringGrid1.ColWidths[i] := 80;
    StringGrid1.ColWidths[0] := 60;
  end
  else if metode = 'Newton Raphson' then
  begin
    StringGrid1.ColCount := 6;
    StringGrid1.Cells[0,0] := 'Iterasi';
    StringGrid1.Cells[1,0] := 'Xn';
    StringGrid1.Cells[2,0] := 'f(Xn)';
    StringGrid1.Cells[3,0] := 'f''(Xn)';
    StringGrid1.Cells[4,0] := 'Xn+1';
    StringGrid1.Cells[5,0] := 'Error';
    StringGrid1.ColWidths[0] := 60;
    StringGrid1.ColWidths[1] := 80;
    StringGrid1.ColWidths[2] := 80;
    StringGrid1.ColWidths[3] := 80;
    StringGrid1.ColWidths[4] := 80;
    StringGrid1.ColWidths[5] := 80;
  end;

  StringGrid1.FixedRows := 1;
  StringGrid1.RowCount := 2; // baris 0 header, baris 1 kosong (data pertama akan menimpa)
  StringGrid1.Refresh;
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

  SetupGridForMethod;
end;

procedure TAplikasi.cmbMetodeChange(Sender: TObject);
begin
  SetupGridForMethod;
end;

procedure TAplikasi.TampilkanHasil(metode, fungsi: string; iterasi: Integer; akar: Double);
begin
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

    // Bersihkan grid dan setup ulang header (biarkan baris 1 kosong)
    SetupGridForMethod;

    case cmbMetode.ItemIndex of
      0: akar := BiseksiMethodWithGrid(fungsi, a, b, tol, 100, iterasi, StringGrid1);
      1: akar := RegulaFalsiMethodWithGrid(fungsi, a, b, tol, 100, iterasi, StringGrid1);
      2: akar := SecantMethodWithGrid(fungsi, a, b, tol, 100, iterasi, StringGrid1);
      3:
      begin
        tebakan := (a + b) / 2;
        akar := NewtonRaphsonMethodWithGrid(fungsi, tebakan, tol, 100, iterasi, StringGrid1);
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
