object Aplikasi: TAplikasi
  Left = 0
  Top = 0
  Caption = 'Akar Persamaan Non-Linear'
  ClientHeight = 679
  ClientWidth = 939
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 28
  object Label1: TLabel
    Left = 8
    Top = 98
    Width = 134
    Height = 28
    Caption = 'Batas Error    :'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 134
    Height = 28
    Caption = 'f(x)                :'
  end
  object Label3: TLabel
    Left = 8
    Top = 140
    Width = 132
    Height = 28
    Caption = 'Metode         :'
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 374
    Width = 939
    Height = 305
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 354
  end
  object edtError: TEdit
    Left = 148
    Top = 95
    Width = 385
    Height = 36
    TabOrder = 1
  end
  object cmbFungsi: TComboBox
    Left = 148
    Top = 53
    Width = 385
    Height = 36
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 193
    Width = 361
    Height = 137
    Caption = 'Selang'
    TabOrder = 3
    object Label4: TLabel
      Left = 19
      Top = 40
      Width = 154
      Height = 28
      Caption = 'Batas bawah (A)'
    end
    object Label5: TLabel
      Left = 19
      Top = 88
      Width = 130
      Height = 28
      Caption = 'Batas atas (B)'
    end
    object edtSelangA: TEdit
      Left = 219
      Top = 40
      Width = 121
      Height = 36
      TabOrder = 0
    end
    object edtSelangB: TEdit
      Left = 219
      Top = 82
      Width = 121
      Height = 36
      TabOrder = 1
    end
  end
  object btnHitung: TButton
    Left = 408
    Top = 228
    Width = 125
    Height = 81
    Caption = 'Hitung'
    TabOrder = 4
    OnClick = btnHitungClick
  end
  object cmbMetode: TComboBox
    Left = 146
    Top = 137
    Width = 385
    Height = 36
    TabOrder = 5
    OnChange = cmbMetodeChange
  end
end
