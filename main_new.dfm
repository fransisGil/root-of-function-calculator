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
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 20
  object RadioGroup1: TRadioGroup
    Left = 399
    Top = 39
    Width = 666
    Height = 226
    Caption = 'Pilih Metode :'
    TabOrder = 6
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 39
    Width = 369
    Height = 170
    Caption = 'Input Persamaan'
    TabOrder = 0
    object Label1: TLabel
      Left = 11
      Top = 36
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
      Top = 80
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
      Top = 77
      Width = 209
      Height = 28
      TabOrder = 0
    end
    object edtMaksimumIterasi: TEdit
      Left = 142
      Top = 125
      Width = 209
      Height = 28
      NumbersOnly = True
      TabOrder = 1
    end
    object cmbFungsi: TComboBox
      Left = 142
      Top = 35
      Width = 211
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
    TabOrder = 1
    WordWrap = True
    OnClick = btnHitungClick
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 384
    Width = 1079
    Height = 317
    Align = alBottom
    TabOrder = 2
  end
  object gbTertutup: TGroupBox
    Left = 416
    Top = 74
    Width = 300
    Height = 177
    Caption = 'Metode Tertutup'
    TabOrder = 3
    object Label5: TLabel
      Left = 19
      Top = 94
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
    object edtBatasAtas: TEdit
      Left = 144
      Top = 94
      Width = 121
      Height = 28
      TabOrder = 0
    end
    object edtBatasBawah: TEdit
      Left = 144
      Top = 128
      Width = 121
      Height = 28
      TabOrder = 1
    end
  end
  object gbTerbuka: TGroupBox
    Left = 730
    Top = 74
    Width = 321
    Height = 177
    Caption = 'Metode Terbuka'
    TabOrder = 4
    object lblX0: TLabel
      Left = 16
      Top = 88
      Width = 17
      Height = 20
      Caption = 'X0'
    end
    object lblX1: TLabel
      Left = 16
      Top = 130
      Width = 17
      Height = 20
      Caption = 'X1'
    end
    object edtX0: TEdit
      Left = 136
      Top = 88
      Width = 121
      Height = 28
      TabOrder = 0
    end
    object edtX1: TEdit
      Left = 136
      Top = 122
      Width = 121
      Height = 28
      TabOrder = 1
    end
    object cmbTerbuka: TComboBox
      Left = 16
      Top = 36
      Width = 145
      Height = 28
      TabOrder = 2
      OnChange = cmbTerbukaChange
    end
  end
  object cmbTertutup: TComboBox
    Left = 435
    Top = 110
    Width = 145
    Height = 28
    TabOrder = 5
    OnChange = cmbTertutupChange
  end
end
