object Main: TMain
  Left = 0
  Top = 0
  Caption = 'Kalkulator Akar Persamaan Non-Linear'
  ClientHeight = 701
  ClientWidth = 1079
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  TextHeight = 20
  object rgMetode: TRadioGroup
    Left = 408
    Top = 39
    Width = 663
    Height = 242
    Caption = 'Pilih Metode :   '
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 39
    Width = 369
    Height = 170
    Caption = 'Input Persamaan'
    TabOrder = 2
    object Label1: TLabel
      Left = 13
      Top = 29
      Width = 125
      Height = 23
      Caption = 'f(x)                  ='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 13
      Top = 75
      Width = 123
      Height = 20
      Caption = 'Batas Error            :'
    end
    object Label3: TLabel
      Left = 13
      Top = 126
      Width = 123
      Height = 20
      Caption = 'Maksimum Iterasi :'
    end
    object edtError: TEdit
      Left = 142
      Top = 72
      Width = 209
      Height = 28
      TabOrder = 0
    end
    object edtMaksimumIterasi: TEdit
      Left = 142
      Top = 123
      Width = 209
      Height = 28
      NumbersOnly = True
      TabOrder = 1
    end
    object edtFungsi: TEdit
      Left = 144
      Top = 28
      Width = 209
      Height = 28
      TabOrder = 2
    end
  end
  object btnHitung: TButton
    Left = 680
    Top = 312
    Width = 113
    Height = 57
    Caption = 'HITUNG'
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    WordWrap = True
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 384
    Width = 1079
    Height = 317
    Align = alBottom
    TabOrder = 4
  end
  object gbTertutup: TGroupBox
    Left = 419
    Top = 77
    Width = 305
    Height = 177
    TabOrder = 5
    object Label5: TLabel
      Left = 19
      Top = 87
      Width = 69
      Height = 20
      Caption = 'Batas Atas'
    end
    object Label6: TLabel
      Left = 19
      Top = 129
      Width = 84
      Height = 20
      Caption = 'Batas Bawah'
    end
    object rbBisection: TRadioButton
      Left = 19
      Top = 17
      Width = 113
      Height = 17
      Caption = 'Bisection'
      TabOrder = 0
    end
    object rbRegulaFalsi: TRadioButton
      Left = 19
      Top = 40
      Width = 113
      Height = 25
      Caption = 'Regula Falsi'
      TabOrder = 1
    end
    object edtBatasAtas: TEdit
      Left = 128
      Top = 87
      Width = 121
      Height = 28
      TabOrder = 2
    end
    object edtBatasBawah: TEdit
      Left = 128
      Top = 128
      Width = 121
      Height = 28
      TabOrder = 3
    end
  end
  object rbTertutup: TRadioButton
    Left = 419
    Top = 72
    Width = 145
    Height = 17
    Caption = 'Metode Tertutup'
    TabOrder = 1
  end
  object gbTerbuka: TGroupBox
    Left = 742
    Top = 77
    Width = 321
    Height = 177
    TabOrder = 6
    object z: TLabel
      Left = 16
      Top = 88
      Width = 92
      Height = 20
      Caption = 'Tebakan Awal'
    end
    object rbNewton: TRadioButton
      Left = 19
      Top = 18
      Width = 145
      Height = 17
      Caption = 'Newton-Raphson'
      TabOrder = 0
    end
    object rbSecant: TRadioButton
      Left = 19
      Top = 41
      Width = 113
      Height = 17
      Caption = 'Secant'
      TabOrder = 1
    end
    object edtTebakanAwal: TEdit
      Left = 136
      Top = 88
      Width = 121
      Height = 28
      TabOrder = 2
    end
  end
  object rbTerbuka: TRadioButton
    Left = 742
    Top = 72
    Width = 137
    Height = 17
    Caption = 'Metode TerBuka'
    TabOrder = 7
  end
end
