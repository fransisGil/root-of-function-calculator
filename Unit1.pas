unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids;

type
  TForm1 = class(TForm)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormActivate(Sender: TObject);
begin
  edtfungsi.SetFocus;
end;

end.
