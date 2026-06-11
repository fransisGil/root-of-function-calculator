object Aplikasi: TAplikasi
  Left = 0
  Top = 0
  Caption = 'Akar Persamaan Non-Linear'
  ClientHeight = 611
  ClientWidth = 913
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = [fsBold]
  Menu = MainMenu1
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 28
  object Label1: TLabel
    Left = 0
    Top = 154
    Width = 134
    Height = 28
    Caption = 'Batas Error    :'
  end
  object Label2: TLabel
    Left = 0
    Top = 120
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
  end
  object edtError: TEdit
    Left = 140
    Top = 151
    Width = 385
    Height = 36
    TabOrder = 1
    OnKeyPress = edtErrorKeyPress
  end
  object cmbFungsi: TComboBox
    Left = 140
    Top = 109
    Width = 385
    Height = 36
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 193
    Width = 241
    Height = 136
    Caption = 'Selang'
    TabOrder = 3
    object Label4: TLabel
      Left = 19
      Top = 40
      Width = 25
      Height = 28
      Caption = 'A :'
    end
    object Label5: TLabel
      Left = 19
      Top = 88
      Width = 24
      Height = 28
      Caption = 'B :'
    end
    object edtSelangA: TEdit
      Left = 50
      Top = 40
      Width = 121
      Height = 36
      TabOrder = 0
    end
    object edtSelangB: TEdit
      Left = 49
      Top = 90
      Width = 124
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
