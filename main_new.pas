unit main_new;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  evaluator, bissection, regulafalsi, secant, newtonrhapson;

type
  TMain = class(TForm)
    rgMetode: TRadioGroup;
    rbTertutup: TRadioButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtError: TEdit;
    edtMaksimumIterasi: TEdit;
    btnHitung: TButton;
    StringGrid1: TStringGrid;
    gbTertutup: TGroupBox;
    gbTerbuka: TGroupBox;
    rbTerbuka: TRadioButton;
    rbBisection: TRadioButton;
    rbNewton: TRadioButton;
    rbRegulaFalsi: TRadioButton;
    rbSecant: TRadioButton;
    Label5: TLabel;
    Label6: TLabel;
    z: TLabel;
    edtBatasAtas: TEdit;
    edtBatasBawah: TEdit;
    edtTebakanAwal: TEdit;
    Label3: TLabel;
    edtFungsi: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure rbTertutupClick(Sender: TObject);
    procedure rbTerbukaClick(Sender: TObject);
    procedure rbBisectionClick(Sender: TObject);
    procedure rbRegulaFalsiClick(Sender: TObject);
    procedure rbSecantClick(Sender: TObject);
    procedure rbNewtonClick(Sender: TObject);
    procedure btnHitungClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SetupGridForMethod(metode: string);
    procedure TampilkanHasil(metode, fungsi: string; iterasi: Integer; akar: Double);
    function GetTolerance: Double;
    function GetMaxIterasi: Integer;
    function GetFungsi: string;
    // Untuk metode tertutup
    function GetBatasBawah: Double;
    function GetBatasAtas: Double;
    // Untuk Secant
    function GetX0: Double;
    function GetX1: Double;
    // Untuk Newton
    function GetTebakanAwal: Double;
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
  Result := edtFungsi.Text;
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

function TMain.GetX0: Double;
begin
  Result := GetBatasBawah; // untuk Secant, X0 dari batas bawah
end;

function TMain.GetX1: Double;
begin
  Result := GetBatasAtas;  // untuk Secant, X1 dari batas atas
end;

function TMain.GetTebakanAwal: Double;
begin
  if not StrToDoubleSafe(edtTebakanAwal.Text, Result) then
    raise Exception.Create('Tebakan awal tidak valid: ' + edtTebakanAwal.Text);
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
var
  isTertutup: Boolean;
  isSecant: Boolean;
begin
  isTertutup := rbTertutup.Checked;
  isSecant := rbSecant.Checked;

  // Tampilkan groupbox sesuai jenis metode
  gbTertutup.Visible := isTertutup;
  gbTerbuka.Visible := not isTertutup;

  // Atur label untuk batas bawah/atas
  if isTertutup then
  begin
    Label5.Caption := 'Batas Bawah (A)';
    Label6.Caption := 'Batas Atas (B)';
  end
  else
  begin
    if isSecant then
    begin
      Label5.Caption := 'X0 (tebakan 1)';
      Label6.Caption := 'X1 (tebakan 2)';
    end
    else
    begin
      Label5.Caption := '(tidak dipakai)';
      Label6.Caption := '(tidak dipakai)';
    end;
  end;

  // Untuk Newton, tebakan awal aktif
  edtTebakanAwal.Enabled := (not isTertutup) and (rbNewton.Checked);
  // Untuk Secant, kita pakai batas bawah/atas sebagai X0, X1
  edtBatasBawah.Enabled := isTertutup or isSecant;
  edtBatasAtas.Enabled := isTertutup or isSecant;
  // Jika bukan tertutup dan bukan Secant (yaitu Newton), nonaktifkan batas
  if not isTertutup and not isSecant then
  begin
    edtBatasBawah.Enabled := False;
    edtBatasAtas.Enabled := False;
  end;
end;

procedure TMain.rbTertutupClick(Sender: TObject);
begin
  UpdateUIForMethod;
end;

procedure TMain.rbTerbukaClick(Sender: TObject);
begin
  UpdateUIForMethod;
end;

procedure TMain.rbBisectionClick(Sender: TObject);
begin
  rbTertutup.Checked := True;
  UpdateUIForMethod;
end;

procedure TMain.rbRegulaFalsiClick(Sender: TObject);
begin
  rbTertutup.Checked := True;
  UpdateUIForMethod;
end;

procedure TMain.rbSecantClick(Sender: TObject);
begin
  rbTerbuka.Checked := True;
  UpdateUIForMethod;
end;

procedure TMain.rbNewtonClick(Sender: TObject);
begin
  rbTerbuka.Checked := True;
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
    // Tentukan metode berdasarkan radio button yang dipilih
    if rbBisection.Checked then
      metode := 'Biseksi'
    else if rbRegulaFalsi.Checked then
      metode := 'Regula Falsi'
    else if rbSecant.Checked then
      metode := 'Secant'
    else if rbNewton.Checked then
      metode := 'Newton Raphson'
    else
      raise Exception.Create('Pilih metode terlebih dahulu');

    fungsi := GetFungsi;
    tol := GetTolerance;
    maxIter := GetMaxIterasi;

    // Setup grid header
    SetupGridForMethod(metode);

    // Validasi awal fungsi (coba evaluasi di x=0 untuk deteksi error)
    try
      EvaluateExpression(fungsi, 0);
    except
      on E: Exception do
        raise Exception.Create('Fungsi tidak valid: ' + E.Message);
    end;

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
    // ========== METODE SECANT ==========
    else if metode = 'Secant' then
    begin
      x0 := GetX0;
      x1 := GetX1;
      if x0 = x1 then
        raise Exception.Create('X0 dan X1 tidak boleh sama');
      akar := SecantMethodWithGrid(fungsi, x0, x1, tol, maxIter, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end
    // ========== METODE NEWTON-RAPHSON ==========
    else if metode = 'Newton Raphson' then
    begin
      tebakan := GetTebakanAwal;
      akar := NewtonRaphsonMethodWithGrid(fungsi, tebakan, tol, maxIter, iterasi, StringGrid1);
      TampilkanHasil(metode, fungsi, iterasi, akar);
    end;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

// ======================== FORM INIT ========================
procedure TMain.FormCreate(Sender: TObject);
begin
  // Inisialisasi nilai default
  edtError.Text := '0.00001';
  edtMaksimumIterasi.Text := '100';
  edtFungsi.Text := 'x^2 - 4';
  edtBatasBawah.Text := '0';
  edtBatasAtas.Text := '2';
  edtTebakanAwal.Text := '1';

  // Atur UI awal
  rbBisection.Checked := True;
  UpdateUIForMethod;
end;

procedure TMain.FormActivate(Sender: TObject);
begin
  edtFungsi.SetFocus;
end;

end.
