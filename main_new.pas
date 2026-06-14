unit main_new;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  evaluator, bissection, regulafalsi, secant, newtonrhapson;

type
  TMain = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtError: TEdit;
    edtMaksimumIterasi: TEdit;
    btnHitung: TButton;
    StringGrid1: TStringGrid;
    gbTertutup: TGroupBox;
    gbTerbuka: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    lblX0: TLabel;
    edtBatasAtas: TEdit;
    edtBatasBawah: TEdit;
    edtX0: TEdit;
    Label3: TLabel;
    lblX1: TLabel;
    edtX1: TEdit;
    cmbTertutup: TComboBox;
    cmbTerbuka: TComboBox;
    RadioGroup1: TRadioGroup;
    cmbFungsi: TComboBox;
    procedure btnHitungClick(Sender: TObject);
    procedure cmbTertutupChange(Sender: TObject);
    procedure cmbTerbukaChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FCurrentMethod: string;
    procedure SetupGridForMethod(metode: string);
    procedure TampilkanHasil(metode, fungsi: string; iterasi: Integer; akar: Double);
    function GetTolerance: Double;
    function GetMaxIterasi: Integer;
    function GetFungsi: string;
    function GetBatasBawah: Double;
    function GetBatasAtas: Double;
    function GetSecantX0: Double;
    function GetSecantX1: Double;
    function GetNewtonX0: Double;
    function ValidateClosedInterval(var a, b, fa, fb: Double): Boolean;
    procedure UpdateUIForMethod;
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses System.Math;

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
function TMain.GetTolerance: Double;
begin
  if not StrToDoubleSafe(edtError.Text, Result) then
    raise Exception.Create('Toleransi tidak valid: ' + edtError.Text);
end;

function TMain.GetMaxIterasi: Integer;
begin
  if not TryStrToInt(edtMaksimumIterasi.Text, Result) then
    raise Exception.Create('Maksimum iterasi tidak valid: ' + edtMaksimumIterasi.Text);
end;

function TMain.GetFungsi: string;
begin
  Result := cmbFungsi.Text;
  if Result = '' then
    raise Exception.Create('Fungsi tidak boleh kosong');
end;

function TMain.GetBatasBawah: Double;
begin
  if not StrToDoubleSafe(edtBatasBawah.Text, Result) then
    raise Exception.Create('Batas bawah tidak valid: ' + edtBatasBawah.Text);
end;

function TMain.GetBatasAtas: Double;
begin
  if not StrToDoubleSafe(edtBatasAtas.Text, Result) then
    raise Exception.Create('Batas atas tidak valid: ' + edtBatasAtas.Text);
end;

function TMain.GetSecantX0: Double;
begin
  if not StrToDoubleSafe(edtX0.Text, Result) then
    raise Exception.Create('X0 tidak valid: ' + edtX0.Text);
end;

function TMain.GetSecantX1: Double;
begin
  if not StrToDoubleSafe(edtX1.Text, Result) then
    raise Exception.Create('X1 tidak valid: ' + edtX1.Text);
end;

function TMain.GetNewtonX0: Double;
begin
  if not StrToDoubleSafe(edtX0.Text, Result) then
    raise Exception.Create('Tebakan awal tidak valid: ' + edtX0.Text);
end;

// ======================== VALIDASI METODE TERTUTUP ========================
function TMain.ValidateClosedInterval(var a, b, fa, fb: Double): Boolean;
var
  expr: string;
begin
  a := GetBatasBawah;
  b := GetBatasAtas;
  if a >= b then
    raise Exception.Create('Batas bawah harus lebih kecil dari batas atas');

  expr := GetFungsi;
  fa := EvaluateExpression(expr, a);
  fb := EvaluateExpression(expr, b);

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

  if fa * fb >= 0 then
    raise Exception.Create(Format('Interval [%g, %g] tidak mengurung akar (f(A)=%g, f(B)=%g)', [a, b, fa, fb]));

  Result := False;
end;

// ======================== MANAJEMEN GRID ========================
procedure TMain.SetupGridForMethod(metode: string);
var
  i: Integer;
begin
  StringGrid1.FixedRows := 1;
  StringGrid1.RowCount := 2; // header + satu baris kosong
  if (metode = 'Biseksi') or (metode = 'Regula Falsi') then
  begin
    StringGrid1.ColCount := 9;
    StringGrid1.Cells[0,0] := 'Iterasi';
    StringGrid1.Cells[1,0] := 'A';
    StringGrid1.Cells[2,0] := 'B';
    StringGrid1.Cells[3,0] := 'C';
    StringGrid1.Cells[4,0] := 'f(A)';
    StringGrid1.Cells[5,0] := 'f(B)';
    StringGrid1.Cells[6,0] := 'f(C)';
    StringGrid1.Cells[7,0] := 'Selang';
    StringGrid1.Cells[8,0] := 'Error';
    for i := 0 to 8 do StringGrid1.ColWidths[i] := 80;
    StringGrid1.ColWidths[0] := 60;
    StringGrid1.ColWidths[7] := 100;
  end
  else if metode = 'Secant' then
  begin
    StringGrid1.ColCount := 5;
    StringGrid1.Cells[0,0] := 'Iterasi';
    StringGrid1.Cells[1,0] := 'X0';
    StringGrid1.Cells[2,0] := 'X1';
    StringGrid1.Cells[3,0] := 'X2';
    StringGrid1.Cells[4,0] := 'Error';
    for i := 0 to 4 do StringGrid1.ColWidths[i] := 80;
    StringGrid1.ColWidths[0] := 60;
  end
  else if metode = 'Newton Raphson' then
  begin
    StringGrid1.ColCount := 5;
    StringGrid1.Cells[0,0] := 'Iterasi';
    StringGrid1.Cells[1,0] := 'Xn';
    StringGrid1.Cells[2,0] := 'f(Xn)';
    StringGrid1.Cells[3,0] := 'Xn+1';
    StringGrid1.Cells[4,0] := 'Error';
    for i := 0 to 4 do StringGrid1.ColWidths[i] := 80;
    StringGrid1.ColWidths[0] := 60;
  end;
  StringGrid1.Refresh;
end;

procedure TMain.TampilkanHasil(metode, fungsi: string; iterasi: Integer; akar: Double);
begin
  ShowMessage(Format('%s - %s selesai. Akar = %.8f (iterasi %d)', [metode, fungsi, akar, iterasi]));
end;

// ======================== UI LOGIC ========================
procedure TMain.UpdateUIForMethod;
begin
  btnHitung.Enabled := False;

  if cmbTertutup.ItemIndex >= 0 then
  begin
    btnHitung.Enabled := True;
    if cmbTertutup.Text = 'Biseksi' then
      FCurrentMethod := 'Biseksi'
    else if cmbTertutup.Text = 'Regula Falsi' then
      FCurrentMethod := 'Regula Falsi'
    else
      FCurrentMethod := '';

    Label5.Caption := 'Batas Atas (B)';
    Label6.Caption := 'Batas Bawah (A)';
    Label5.Visible := True;
    Label6.Visible := True;
    edtBatasBawah.Visible := True;
    edtBatasAtas.Visible := True;
    // Sembunyikan input terbuka
    edtX0.Visible := False;
    edtX1.Visible := False;
    lblX0.Visible := False;
    lblX1.Visible := False;
  end
  else if cmbTerbuka.ItemIndex >= 0 then
  begin
    btnHitung.Enabled := True;
    if cmbTerbuka.Text = 'Secant' then
    begin
      FCurrentMethod := 'Secant';
      lblX0.Visible := True;
      lblX1.Visible := True;
      edtX0.Visible := True;
      edtX1.Visible := True;
      edtX0.Enabled := True;
      edtX1.Enabled := True;
      lblX0.Caption := 'X0';
      lblX1.Caption := 'X1';
    end
    else if cmbTerbuka.Text = 'Newton Raphson' then
    begin
      FCurrentMethod := 'Newton Raphson';
      lblX0.Visible := True;
      lblX1.Visible := False;
      edtX0.Visible := True;
      edtX1.Visible := False;
      edtX0.Enabled := True;
      lblX0.Caption := 'Tebakan Awal';
    end;
    // Sembunyikan input tertutup
    edtBatasBawah.Visible := False;
    edtBatasAtas.Visible := False;
    Label5.Visible := False;
    Label6.Visible := False;
  end
  else
  begin
    FCurrentMethod := '';
    btnHitung.Enabled := False;
  end;
end;

procedure TMain.cmbTertutupChange(Sender: TObject);
begin
  if cmbTertutup.ItemIndex >= 0 then
    cmbTerbuka.ItemIndex := -1;
  UpdateUIForMethod;
end;

procedure TMain.cmbTerbukaChange(Sender: TObject);
begin
  if cmbTerbuka.ItemIndex >= 0 then
    cmbTertutup.ItemIndex := -1;
  UpdateUIForMethod;
end;

// ======================== PROSES PERHITUNGAN ========================
procedure TMain.btnHitungClick(Sender: TObject);
var
  metode, fungsi: string;
  tol: Double;
  maxIter: Integer;
  akar: Double;
  iterasi: Integer;
  a, b, fa, fb, x0, x1, tebakan: Double;
  langsungAkar: Boolean;
begin
  try
    if FCurrentMethod = '' then
      raise Exception.Create('Pilih metode terlebih dahulu (dari combobox tertutup atau terbuka)');

    metode := FCurrentMethod;
    fungsi := GetFungsi;
    tol := GetTolerance;
    maxIter := GetMaxIterasi;

    SetupGridForMethod(metode);

    // Validasi awal fungsi (coba evaluasi di x=0 untuk deteksi error)
    try
      EvaluateExpression(fungsi, 0);
    except
      on E: Exception do
        raise Exception.Create('Fungsi tidak valid: ' + E.Message);
    end;

    if (metode = 'Biseksi') or (metode = 'Regula Falsi') then
    begin
      langsungAkar := ValidateClosedInterval(a, b, fa, fb);
      if langsungAkar then
      begin
        if Abs(fa) < tol then
          akar := a
        else
          akar := b;
        // Tulis ke grid langsung
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
          StringGrid1.Cells[7,1] := 'Akar';
          StringGrid1.Cells[8,1] := '0';
        end
        else
        begin
          StringGrid1.Cells[1,1] := FormatFloat('0.00000000', a);
          StringGrid1.Cells[2,1] := FormatFloat('0.00000000', b);
          StringGrid1.Cells[3,1] := FormatFloat('0.00000000', b);
          StringGrid1.Cells[4,1] := FormatFloat('0.00000000', fa);
          StringGrid1.Cells[5,1] := FormatFloat('0.00000000', fb);
          StringGrid1.Cells[6,1] := FormatFloat('0.00000000', fb);
          StringGrid1.Cells[7,1] := 'Akar';
          StringGrid1.Cells[8,1] := '0';
        end;
        TampilkanHasil(metode, fungsi, 1, akar);
        Exit;
      end;

      if metode = 'Biseksi' then
        akar := BiseksiMethodWithGrid(fungsi, a, b, tol, maxIter, iterasi, StringGrid1)
      else
        akar := RegulaFalsiMethodWithGrid(fungsi, a, b, tol, maxIter, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end
    else if metode = 'Secant' then
    begin
      x0 := GetSecantX0;
      x1 := GetSecantX1;
      if x0 = x1 then
        raise Exception.Create('X0 dan X1 tidak boleh sama');
      akar := SecantMethodWithGrid(fungsi, x0, x1, tol, maxIter, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end
    else if metode = 'Newton Raphson' then
    begin
      tebakan := GetNewtonX0;
      akar := NewtonRaphsonMethodWithGrid(fungsi, tebakan, tol, maxIter, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

// ======================== FORM INIT & ACTIVATE ========================
procedure TMain.FormActivate(Sender: TObject);
begin
  cmbFungsi.SetFocus;

  // Isi combo fungsi dengan preset
  cmbFungsi.Items.Clear;
  cmbFungsi.Items.Add('x^2 - 4');
  cmbFungsi.Items.Add('x^3 - x - 2');
  cmbFungsi.Items.Add('exp(-x) - x^2');
  cmbFungsi.Items.Add('sin(x) - 0.5');
  cmbFungsi.Style := csDropDown;

  // Isi combobox tertutup dan terbuka
  cmbTertutup.Items.Clear;
  cmbTertutup.Items.Add('Biseksi');
  cmbTertutup.Items.Add('Regula Falsi');
  cmbTertutup.ItemIndex := -1;

  cmbTerbuka.Items.Clear;
  cmbTerbuka.Items.Add('Secant');
  cmbTerbuka.Items.Add('Newton Raphson');
  cmbTerbuka.ItemIndex := -1;

  // Nilai default
  edtError.Text := '0.000005';
  edtMaksimumIterasi.Text := '100';
  edtBatasBawah.Text := '0';
  edtBatasAtas.Text := '1';
  edtX0.Text := '1';
  edtX1.Text := '2';

  // Sembunyikan semua input (akan diatur oleh UpdateUI)
  edtBatasBawah.Visible := False;
  edtBatasAtas.Visible := False;
  edtX0.Visible := False;
  edtX1.Visible := False;
  lblX0.Visible := False;
  lblX1.Visible := False;
  Label5.Visible := False;
  Label6.Visible := False;
  btnHitung.Enabled := False;
end;

end.
