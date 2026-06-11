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
  object lblMetode: TLabel
    Left = 8
    Top = 16
    Width = 84
    Height = 28
    Caption = 'Metode :'
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 366
    Width = 913
    Height = 245
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
    OnKeyPress = edtErrorKeyPress
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
    Width = 241
    Height = 136
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
  object cmbMetode: TComboBox
    Left = 8
    Top = 50
    Width = 247
    Height = 36
    TabOrder = 4
  end
  object MainMenu1: TMainMenu
    Left = 744
    Top = 8
    object Metode1: TMenuItem
      Caption = 'Metode'
      object metodeTerbuka: TMenuItem
        Action = pilihTerbuka
        Caption = 'Terbuka'
        Default = True
      end
      object metodeTertutup: TMenuItem
        Action = pilihTertutup
        Caption = 'Tertutup'
      end
    end
  end
  object ActionList1: TActionList
    Left = 744
    Top = 64
    object pilihTerbuka: TAction
      Caption = 'pilihTerbuka'
      OnExecute = pilihTerbukaExecute
    end
    object pilihTertutup: TAction
      Caption = 'pilihTertutup'
      OnExecute = pilihTertutupExecute
    end
  end
end
