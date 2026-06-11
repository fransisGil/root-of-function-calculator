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
    Label3: TLabel;
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
    // Getter untuk metode tertutup
    function GetIntervalA: Double;
    function GetIntervalB: Double;
    // Getter untuk Secant
    function GetSecantX0: Double;
    function GetSecantX1: Double;
    // Getter untuk Newton
    function GetInitialGuess: Double;
    // Validasi interval untuk metode tertutup (return True jika akar langsung di ujung)
    function ValidateClosedInterval(var a, b, fa, fb: Double): Boolean;
  public
    { Public declarations }
  end;

var
  Aplikasi: TAplikasi;

implementation

{$R *.dfm}

// ======================== KONVERSI ANGKA ========================
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

// ======================== GETTER INPUT ========================
function TAplikasi.GetTolerance: Double;
begin
  if not StrToDoubleSafe(edtError.Text, Result) then
    raise Exception.Create('Toleransi tidak valid: ' + edtError.Text);
end;


function TAplikasi.GetSelectedFunctionName: string;
begin
  Result := cmbFungsi.Text;
end;

function TAplikasi.GetIntervalA: Double;
begin
  if not StrToDoubleSafe(edtSelangA.Text, Result) then
    raise Exception.Create('Nilai A tidak valid: ' + edtSelangA.Text);
end;

function TAplikasi.GetIntervalB: Double;
begin
  if not StrToDoubleSafe(edtSelangB.Text, Result) then
    raise Exception.Create('Nilai B tidak valid: ' + edtSelangB.Text);
end;

function TAplikasi.GetSecantX0: Double;
begin
  if not StrToDoubleSafe(edtSelangA.Text, Result) then
    raise Exception.Create('X0 tidak valid: ' + edtSelangA.Text);
end;

function TAplikasi.GetSecantX1: Double;
begin
  if not StrToDoubleSafe(edtSelangB.Text, Result) then
    raise Exception.Create('X1 tidak valid: ' + edtSelangB.Text);
end;

function TAplikasi.GetInitialGuess: Double;
begin
  if not StrToDoubleSafe(edtSelangA.Text, Result) then
    raise Exception.Create('Tebakan awal tidak valid: ' + edtSelangA.Text);
end;

// ======================== VALIDASI METODE TERTUTUP ========================
function TAplikasi.ValidateClosedInterval(var a, b, fa, fb: Double): Boolean;
var
  expr: string;
begin
  a := GetIntervalA;
  b := GetIntervalB;
  if a >= b then
    raise Exception.Create('A harus lebih kecil dari B');

  expr := GetSelectedFunctionName;
  fa := EvaluateExpression(expr, a);
  fb := EvaluateExpression(expr, b);

  // Cek apakah A atau B sudah merupakan akar (dalam toleransi)
  if Abs(fa) < GetTolerance then
  begin
    Result := True;
    Exit;
  end;
  if Abs(fb) < GetTolerance then
  begin
    Result := True;
    Exit;
  end;

  // Jika tidak ada yang nol, periksa apakah interval mengurung akar
  if fa * fb >= 0 then
    raise Exception.Create(Format('Interval [%g, %g] tidak mengurung akar (f(A)=%g, f(B)=%g)', [a, b, fa, fb]));

  Result := False;
end;

// ======================== MANAJEMEN GRID ========================
procedure TAplikasi.ClearGrid;
begin
  StringGrid1.RowCount := 2; // baris 0 header, baris 1 kosong
  StringGrid1.FixedRows := 1;
  StringGrid1.Rows[1].Clear;
  StringGrid1.Refresh;
end;

procedure TAplikasi.SetupGridForMethod;
var
  metode: string;
  i: Integer;
begin
  metode := cmbMetode.Text;
  if (metode = 'Biseksi') or (metode = 'Regula Falsi') then
  begin
    StringGrid1.ColCount := 9;
    StringGrid1.Cells[0,0] := 'I';
    StringGrid1.Cells[1,0] := 'A';
    StringGrid1.Cells[2,0] := 'B';
    StringGrid1.Cells[3,0] := 'C';
    StringGrid1.Cells[4,0] := 'f(A)';
    StringGrid1.Cells[5,0] := 'f(B)';
    StringGrid1.Cells[6,0] := 'f(C)';
    StringGrid1.Cells[7,0] := 'Selang';
    StringGrid1.Cells[8,0] := 'Error';
    for i := 0 to 8 do StringGrid1.ColWidths[i] := 200;
    StringGrid1.ColWidths[0] := 40;
    StringGrid1.ColWidths[7] := 100;
  end
  else if metode = 'Secant' then
  begin
    StringGrid1.ColCount := 5;
    StringGrid1.Cells[0,0] := 'I';
    StringGrid1.Cells[1,0] := 'X0';
    StringGrid1.Cells[2,0] := 'X1';
    StringGrid1.Cells[3,0] := 'X2';
    StringGrid1.Cells[4,0] := 'Error';
    for i := 0 to 4 do StringGrid1.ColWidths[i] := 200;
    StringGrid1.ColWidths[0] := 40;
  end
  else if metode = 'Newton Raphson' then
  begin
    StringGrid1.ColCount := 5;
    StringGrid1.Cells[0,0] := 'I';
    StringGrid1.Cells[1,0] := 'Xn';
    StringGrid1.Cells[2,0] := 'f(Xn)';
    StringGrid1.Cells[3,0] := 'Xn+1';
    StringGrid1.Cells[4,0] := 'Error';
    for i := 0 to 4 do StringGrid1.ColWidths[i] := 200;
    StringGrid1.ColWidths[0] := 40;
  end;
  StringGrid1.FixedRows := 1;
  StringGrid1.RowCount := 2;
  StringGrid1.Refresh;
end;

// ======================== UI DINAMIS SAAT METODE BERUBAH ========================
procedure TAplikasi.cmbMetodeChange(Sender: TObject);
var
  metode: string;
  i, j: Integer;
begin

  for i := 0 to StringGrid1.ColCount - 1 do
    for j := 1 to StringGrid1.RowCount - 1 do
      StringGrid1.Cells[i, j] := '';

  metode := cmbMetode.Text;


  if (metode = 'Biseksi') or (metode = 'Regula Falsi') then
  begin
    Label4.Caption := 'Batas bawah (A)';
    Label5.Caption := 'Batas atas (B)';
    edtSelangB.Enabled := True;
    edtSelangB.Color := clWindow;
  end
  else if metode = 'Secant' then
  begin
    Label4.Caption := 'X0 (tebakan 1)';
    Label5.Caption := 'X1 (tebakan 2)';
    edtSelangB.Enabled := True;
    edtSelangB.Color := clWindow;
  end
  else if metode = 'Newton Raphson' then
  begin
    Label4.Caption := 'Tebakan awal (X0)';
    Label5.Caption := '(tidak dipakai)';
    edtSelangB.Enabled := False;
    edtSelangB.Color := clBtnFace;
  end;
  SetupGridForMethod;
end;

// ======================== TAMPILKAN HASIL AKHIR ========================
procedure TAplikasi.TampilkanHasil(metode, fungsi: string; iterasi: Integer; akar: Double);
begin
  ShowMessage(Format('%s - %s selesai. Akar = %.8f (iterasi %d)', [metode, fungsi, akar, iterasi]));
end;

procedure TAplikasi.btnHitungClick(Sender: TObject);
var
  metode, fungsi: string;
  tol, a, b, x0, x1, tebakan, akar: Double;
  iterasi: Integer;
  langsungAkar: Boolean;
  fa, fb: Double;
begin
  try
    metode := cmbMetode.Text;
    fungsi := GetSelectedFunctionName;
    tol := GetTolerance;
    SetupGridForMethod;

    // ========== METODE TERTUTUP ==========
    if (metode = 'Biseksi') or (metode = 'Regula Falsi') then
    begin
      langsungAkar := ValidateClosedInterval(a, b, fa, fb);
      if langsungAkar then
      begin
        if Abs(fa) < tol then
          akar := a
        else
          akar := b;

        if StringGrid1.RowCount = 2 then
          StringGrid1.RowCount := 3;
        StringGrid1.Cells[0,1] := '1';
        if Abs(fa) < tol then
        begin
          StringGrid1.Cells[1,1] := FormatFloat('0.00000000', a);
          StringGrid1.Cells[2,1] := FormatFloat('0.00000000', b);
          StringGrid1.Cells[3,1] := FormatFloat('0.00000000', a);
          StringGrid1.Cells[4,1] := FormatFloat('0.00000000', fa);
          StringGrid1.Cells[5,1] := FormatFloat('0.00000000', fb);
          StringGrid1.Cells[6,1] := FormatFloat('0.00000000', fa);
          StringGrid1.Cells[7,1] := '0';
        end
        else
        begin
          StringGrid1.Cells[1,1] := FormatFloat('0.00000000', a);
          StringGrid1.Cells[2,1] := FormatFloat('0.00000000', b);
          StringGrid1.Cells[3,1] := FormatFloat('0.00000000', b);
          StringGrid1.Cells[4,1] := FormatFloat('0.00000000', fa);
          StringGrid1.Cells[5,1] := FormatFloat('0.00000000', fb);
          StringGrid1.Cells[6,1] := FormatFloat('0.00000000', fb);
          StringGrid1.Cells[7,1] := '0';
        end;
        TampilkanHasil(metode, fungsi, 1, akar);
        Exit;
      end;

      if metode = 'Biseksi' then
        akar := BiseksiMethodWithGrid(fungsi, a, b, tol, 100, iterasi, StringGrid1)
      else
        akar := RegulaFalsiMethodWithGrid(fungsi, a, b, tol, 100, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end
    // ========== METODE SECANT ==========
    else if metode = 'Secant' then
    begin
      x0 := GetSecantX0;
      x1 := GetSecantX1;
      if x0 = x1 then
        raise Exception.Create('X0 dan X1 tidak boleh sama untuk metode Secant');
      akar := SecantMethodWithGrid(fungsi, x0, x1, tol, 100, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end
    // ========== METODE NEWTON-RAPHSON ==========
    else if metode = 'Newton Raphson' then
    begin
      tebakan := GetInitialGuess;
      akar := NewtonRaphsonMethodWithGrid(fungsi, tebakan, tol, 100, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end
    else
      raise Exception.Create('Metode tidak dikenal');
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

// ======================== FORM INIT & CLOSE ========================
procedure TAplikasi.FormCreate(Sender: TObject);
begin

  WindowState := wsMaximized;


  // preset fungsi
  cmbFungsi.Items.Clear;
  cmbFungsi.Items.Add('x^2 - 4');
  cmbFungsi.Items.Add('x^3 - x - 2');
  cmbFungsi.Items.Add('exp(x) - 3*x');
  cmbFungsi.Items.Add('sin(x) - 0.5');
  cmbFungsi.Style := csDropDown;
  cmbFungsi.Text := 'x^2 - 4';

  cmbMetode.Items.Clear;
  cmbMetode.Items.Add('Biseksi');
  cmbMetode.Items.Add('Regula Falsi');
  cmbMetode.Items.Add('Secant');
  cmbMetode.Items.Add('Newton Raphson');
  cmbMetode.ItemIndex := 0;

  edtError.Text := '0.00001';
  edtSelangA.Text := '0';
  edtSelangB.Text := '2';

  cmbMetodeChange(nil);
end;

procedure TAplikasi.ertutup1Click(Sender: TObject);
begin
  Close;
end;

end.
