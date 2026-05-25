object Aplikasi: TAplikasi
  Left = 0
  Top = 0
  Caption = 'Akar Persamaan Non-Linear'
  ClientHeight = 591
  ClientWidth = 913
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Segoe UI'
  Font.Style = [fsBold]
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
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
  object StringGrid1: TStringGrid
    Left = -8
    Top = 336
    Width = 889
    Height = 245
    TabOrder = 0
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
    Width = 241
    Height = 137
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
  object btnHitung: TButton
    Left = 328
    Top = 256
    Width = 97
    Height = 53
    Caption = 'Hitung'
    TabOrder = 4
    OnClick = btnHitungClick
  end
  object cmbMetode: TComboBox
    Left = 148
    Top = 137
    Width = 385
    Height = 36
    TabOrder = 5
  end
  object MainMenu1: TMainMenu
    OwnerDraw = True
    Left = 888
    Top = 65528
    object Metode1: TMenuItem
      Break = mbBarBreak
      Caption = 'Metode'
      object Metode2: TMenuItem
        Caption = 'Terbuka'
        object NewtonRaphson1: TMenuItem
          Caption = 'Newton Raphson'
        end
        object NewtonRaphson2: TMenuItem
          Caption = 'Secant'
        end
      end
      object ertutup1: TMenuItem
        Caption = 'Tertutup'
        object Bisection1: TMenuItem
          Caption = 'Bisection'
        end
        object Bisection2: TMenuItem
          Caption = 'Regula Falsi'
        end
      end
    end
  end
end
