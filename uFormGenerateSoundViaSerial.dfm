object FormComSound: TFormComSound
  Left = 296
  Top = 278
  Caption = 'Generate Sound Via Serial'
  ClientHeight = 372
  ClientWidth = 808
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 808
    Height = 121
    Align = alTop
    TabOrder = 0
    OnDblClick = PanelMainDblClick
    object PanelCom: TPanel
      Left = 1
      Top = 1
      Width = 806
      Height = 27
      Align = alTop
      TabOrder = 0
      object Label4: TLabel
        Left = 449
        Top = 6
        Width = 36
        Height = 13
        Caption = 'Bytes/s'
      end
      object LabelBytesTransmitted: TLabel
        Left = 390
        Top = 6
        Width = 4
        Height = 13
        Caption = '-'
      end
      object Label5: TLabel
        Left = 323
        Top = 6
        Width = 61
        Height = 13
        Caption = 'Transmitted:'
      end
      object Label1: TLabel
        Left = 128
        Top = 6
        Width = 28
        Height = 13
        Caption = 'Boud:'
      end
      object ComboBoxPorts: TComboBox
        Left = 8
        Top = 2
        Width = 105
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
      object ButtonConnect: TButton
        Left = 234
        Top = 1
        Width = 75
        Height = 23
        Caption = 'Connect'
        TabOrder = 1
        OnClick = ButtonConnectClick
      end
      object FloatEditBoud: TFloatEdit
        AlignWithMargins = True
        Left = 162
        Top = 2
        Width = 55
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 2
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 3000000
        ValueInt = 2000000
        ValueFloat = 2000000.000000000000000000
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 1.000000000000000000
        Increment = 1.000000000000000000
        IncrementPg = 10.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
      end
      object FloatEditBoudMeasured: TFloatEdit
        AlignWithMargins = True
        Left = 644
        Top = 2
        Width = 55
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 3
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 3000000
        ValueInt = 1527000
        ValueFloat = 1527000.000000000000000000
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 1.000000000000000000
        Increment = 1.000000000000000000
        IncrementPg = 10.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
      end
      object CheckBoxSetBoudMeasured: TCheckBox
        Left = 504
        Top = 4
        Width = 136
        Height = 17
        Caption = 'Set real measured boud:'
        TabOrder = 4
      end
    end
    object ButtonStop: TButton
      Left = 733
      Top = 34
      Width = 50
      Height = 81
      Caption = 'Stop'
      TabOrder = 1
      OnClick = ButtonStopClick
    end
    object GroupBoxConversionSettings: TGroupBox
      Left = 9
      Top = 30
      Width = 302
      Height = 85
      Caption = 'Conversion Settings'
      TabOrder = 2
      object RadioButtonBitPerSample: TRadioButton
        Left = 8
        Top = 16
        Width = 89
        Height = 17
        Caption = 'Bit per Sample:'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = ButtonSetupClick
      end
      object RadioButtonSampleRate: TRadioButton
        Left = 8
        Top = 38
        Width = 89
        Height = 17
        Caption = 'Sample Rate:'
        TabOrder = 1
        OnClick = ButtonSetupClick
      end
      object FloatEditBitPerSample: TFloatEdit
        AlignWithMargins = True
        Left = 103
        Top = 14
        Width = 36
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 2
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 8
        MinValueInt = 3
        ValueInt = 3
        ValueFloat = 3.000000000000000000
        ValueDefaultInt = 3
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 1.000000000000000000
        Increment = 1.000000000000000000
        IncrementPg = 10.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
        OnValidate = ButtonSetupClick
      end
      object FloatEditSampleRate: TFloatEdit
        AlignWithMargins = True
        Left = 96
        Top = 36
        Width = 43
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 3
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 16000
        MinValueInt = 1000
        ValueInt = 8000
        ValueFloat = 8000.000000000000000000
        ValueDefaultInt = 1000
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 100.000000000000000000
        Increment = 1000.000000000000000000
        IncrementPg = 10000.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
        OnValidate = ButtonSetupClick
      end
      object MemoSettings: TMemo
        Left = 145
        Top = 10
        Width = 152
        Height = 71
        BorderStyle = bsNone
        Color = clBtnFace
        TabOrder = 4
      end
    end
    object GroupBoxGenerator: TGroupBox
      Left = 320
      Top = 30
      Width = 73
      Height = 85
      Caption = 'Generator'
      TabOrder = 3
      object Label2: TLabel
        Left = 8
        Top = 15
        Width = 55
        Height = 13
        Caption = 'Frequency:'
      end
      object FloatEditFrequency: TFloatEdit
        AlignWithMargins = True
        Left = 8
        Top = 32
        Width = 55
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 0
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 20000
        ValueInt = 1000
        ValueFloat = 1000.000000000000000000
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 1.000000000000000000
        Increment = 100.000000000000000000
        IncrementPg = 10.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
        OnValidate = FloatEditFrequencyValidate
      end
      object ButtonGeneratorStart: TButton
        Left = 8
        Top = 57
        Width = 55
        Height = 23
        Caption = 'Start'
        TabOrder = 1
        OnClick = ButtonGeneratorStartClick
      end
    end
    object GroupBoxPWM: TGroupBox
      Left = 402
      Top = 30
      Width = 91
      Height = 85
      Caption = 'PWM'
      TabOrder = 4
      object LabelFloatEditSample: TLabel
        Left = 8
        Top = 15
        Width = 30
        Height = 13
        Caption = 'Value:'
      end
      object ButtonPWMStart: TButton
        Left = 8
        Top = 58
        Width = 55
        Height = 23
        Caption = 'Start'
        TabOrder = 0
        OnClick = ButtonPWMStartClick
      end
      object FloatEditSample: TFloatEdit
        AlignWithMargins = True
        Left = 8
        Top = 32
        Width = 55
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 1
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 255
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 1.000000000000000000
        Increment = 1.000000000000000000
        IncrementPg = 10.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
        OnValidate = FloatEditSampleValidate
      end
    end
    object GroupBoxWAV: TGroupBox
      Left = 502
      Top = 30
      Width = 222
      Height = 85
      Caption = 'Play WAV'
      TabOrder = 5
      object Label8: TLabel
        Left = 91
        Top = 62
        Width = 64
        Height = 13
        Caption = 'Downsample:'
      end
      object ButtonOpenWAV: TButton
        Left = 8
        Top = 14
        Width = 75
        Height = 23
        Caption = 'Open'
        TabOrder = 0
        OnClick = ButtonOpenWAVClick
      end
      object ButtonPlayWAV: TButton
        Left = 8
        Top = 58
        Width = 75
        Height = 23
        Caption = 'Play'
        TabOrder = 1
        OnClick = ButtonPlayWAVClick
      end
      object MemoWAVInfo: TMemo
        Left = 89
        Top = 10
        Width = 128
        Height = 45
        BorderStyle = bsNone
        Color = clBtnFace
        TabOrder = 2
      end
      object FloatEditDownsample: TFloatEdit
        AlignWithMargins = True
        Left = 161
        Top = 58
        Width = 20
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 3
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 8
        MinValueInt = 1
        ValueInt = 1
        ValueFloat = 1.000000000000000000
        ValueDefaultInt = 3
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 1.000000000000000000
        Increment = 1.000000000000000000
        IncrementPg = 10.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
      end
    end
  end
  object PanelClient: TPanel
    Left = 0
    Top = 121
    Width = 808
    Height = 251
    Align = alClient
    TabOrder = 1
    ExplicitTop = 72
    ExplicitWidth = 457
    ExplicitHeight = 265
    object MemoDebug: TMemo
      AlignWithMargins = True
      Left = 4
      Top = 30
      Width = 800
      Height = 217
      Align = alClient
      Lines.Strings = (
        'MemoDebug')
      ScrollBars = ssVertical
      TabOrder = 0
      Visible = False
    end
    object PanelMelodies: TPanel
      Left = 1
      Top = 27
      Width = 806
      Height = 223
      Align = alClient
      TabOrder = 1
      ExplicitTop = 1
      ExplicitWidth = 852
      ExplicitHeight = 240
      object Label7: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 798
        Height = 13
        Align = alTop
        Caption = 'Melodies:'
        ExplicitWidth = 45
      end
      object LabelDelay: TLabel
        Left = 183
        Top = 4
        Width = 52
        Height = 13
        Caption = 'LabelDelay'
        Visible = False
      end
      object ListBoxMelodies: TListBox
        AlignWithMargins = True
        Left = 4
        Top = 23
        Width = 798
        Height = 196
        Align = alClient
        ItemHeight = 13
        Items.Strings = (
          
            'The Simpsons:d=4,o=5,b=160:c.6,e6,f#6,8a6,g.6,e6,c6,8a,8f#,8f#,8' +
            'f#,2g,8p,8p,8f#,8f#,8f#,8g,a#.,8c6,8c6,8c6,c6'
          
            'Indiana:d=4,o=5,b=250:e,8p,8f,8g,8p,1c6,8p.,d,8p,8e,1f,p.,g,8p,8' +
            'a,8b,8p,1f6,p,a,8p,8b,2c6,2d6,2e6,e,8p,8f,8g,8p,1c6,p,d6,8p,8e6,' +
            '1f.6,g,8p,8g,e.6,8p,d6,8p,8g,e.6,8p,d6,8p,8g,f.6,8p,e6,8p,8d6,2c' +
            '6'
          
            'Entertainer:d=4,o=5,b=140:8d,8d#,8e,c6,8e,c6,8e,2c.6,8c6,8d6,8d#' +
            '6,8e6,8c6,8d6,e6,8b,d6,2c6,p,8d,8d#,8e,c6,8e,c6,8e,2c.6,8p,8a,8g' +
            ',8f#,8a,8c6,e6,8d6,8c6,8a,2d6'
          
            'Looney:d=4,o=5,b=140:32p,c6,8f6,8e6,8d6,8c6,a.,8c6,8f6,8e6,8d6,8' +
            'd#6,e.6,8e6,8e6,8c6,8d6,8c6,8e6,8c6,8d6,8a,8c6,8g,8a#,8a,8f'
          
            'Bond:d=4,o=5,b=80:32p,16c#6,32d#6,32d#6,16d#6,8d#6,16c#6,16c#6,1' +
            '6c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16d#6,16d#6,16c#6,32d#6,32d#' +
            '6,16d#6,8d#6,16c#6,16c#6,16c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16' +
            'd6,16c#6,16c#7,c.7,16g#6,16f#6,g#.6'
          
            'MASH:d=8,o=5,b=140:4a,4g,f#,g,p,f#,p,g,p,f#,p,2e.,p,f#,e,4f#,e,f' +
            '#,p,e,p,4d.,p,f#,4e,d,e,p,d,p,e,p,d,p,2c#.,p,d,c#,4d,c#,d,p,e,p,' +
            '4f#,p,a,p,4b,a,b,p,a,p,b,p,2a.,4p,a,b,a,4b,a,b,p,2a.,a,4f#,a,b,p' +
            ',d6,p,4e.6,d6,b,p,a,p,2b'
          
            'StarWars:d=4,o=5,b=45:32p,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32' +
            'c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#' +
            '.6,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32' +
            'd#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#6'
          
            'GoodBad:d=4,o=5,b=56:32p,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,' +
            'd#,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,c#6,32a#,32d#6,32a#,32' +
            'd#6,8a#.,16f#.,32f.,32d#.,c#,32a#,32d#6,32a#,32d#6,8a#.,16g#.,d#'
          
            'TopGun:d=4,o=4,b=31:32p,16c#,16g#,16g#,32f#,32f,32f#,32f,16d#,16' +
            'd#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,16f,d#,16c#,16g#,16g#,32' +
            'f#,32f,32f#,32f,16d#,16d#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,g' +
            '#'
          
            'A-Team:d=8,o=5,b=125:4d#6,a#,2d#6,16p,g#,4a#,4d#.,p,16g,16a#,d#6' +
            ',a#,f6,2d#6,16p,c#.6,16c6,16a#,g#.,2a#'
          
            'Flinstones:d=4,o=5,b=40:32p,16f6,16a#,16a#6,32g6,16f6,16a#.,16f6' +
            ',32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,d6,16f6,16a#.,16a#6,32g6,1' +
            '6f6,16a#.,32f6,32f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,a#,16a6' +
            ',16d.6,16a#6,32a6,32a6,32g6,32f#6,32a6,8g6,16g6,16c.6,32a6,32a6,' +
            '32g6,32g6,32f6,32e6,32g6,8f6,16f6,16a#.,16a#6,32g6,16f6,16a#.,16' +
            'f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c.6,32d6,32d#6,32f6,16a#,16' +
            'c.6,32d6,32d#6,32f6,16a#6,16c7,8a#.6'
          
            'Jeopardy:d=4,o=6,b=125:c,f,c,f5,c,f,2c,c,f,c,f,a.,8g,8f,8e,8d,8c' +
            '#,c,f,c,f5,c,f,2c,f.,8d,c,a#5,a5,g5,f5,p,d#,g#,d#,g#5,d#,g#,2d#,' +
            'd#,g#,d#,g#,c.7,8a#,8g#,8g,8f,8e,d#,g#,d#,g#5,d#,g#,2d#,g#.,8f,d' +
            '#,c#,c,p,a#5,p,g#.5,d#,g#'
          
            'MahnaMahna:d=16,o=6,b=125:c#,c.,b5,8a#.5,8f.,4g#,a#,g.,4d#,8p,c#' +
            ',c.,b5,8a#.5,8f.,g#.,8a#.,4g,8p,c#,c.,b5,8a#.5,8f.,4g#,f,g.,8d#.' +
            ',f,g.,8d#.,f,8g,8d#.,f,8g,d#,8c,a#5,8d#.,8d#.,4d#,8d#.'
          
            'MissionImp:d=16,o=6,b=95:32d,32d#,32d,32d#,32d,32d#,32d,32d#,32d' +
            ',32d,32d#,32e,32f,32f#,32g,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,' +
            'p,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,p,a#,g,2d,32p,a#,g,2c#,32' +
            'p,a#,g,2c,a#5,8c,2p,32p,a#5,g5,2f#,32p,a#5,g5,2f,32p,a#5,g5,2e,d' +
            '#,8d'
          
            'KnightRider:d=4,o=5,b=125:16e,16p,16f,16e,16e,16p,16e,16e,16f,16' +
            'e,16e,16e,16d#,16e,16e,16e,16e,16p,16f,16e,16e,16p,16f,16e,16f,1' +
            '6e,16e,16e,16d#,16e,16e,16e,16d,16p,16e,16d,16d,16p,16e,16d,16e,' +
            '16d,16d,16d,16c,16d,16d,16d,16d,16p,16e,16d,16d,16p,16e,16d,16e,' +
            '16d,16d,16d,16c,16d,16d,16d')
        TabOrder = 0
        OnDblClick = ListBoxMelodiesDblClick
        ExplicitWidth = 844
        ExplicitHeight = 167
      end
    end
    object PanelDebug: TPanel
      Left = 1
      Top = 1
      Width = 806
      Height = 26
      Align = alTop
      TabOrder = 2
      Visible = False
      object Label3: TLabel
        Left = 8
        Top = 5
        Width = 56
        Height = 13
        Caption = 'Buffer Size:'
      end
      object LabelBufferSize: TLabel
        Left = 72
        Top = 5
        Width = 4
        Height = 13
        Caption = '-'
      end
      object CheckBoxCustomBufferSize: TCheckBox
        Left = 114
        Top = 4
        Width = 111
        Height = 17
        Caption = 'Custom Buffer Size:'
        TabOrder = 0
      end
      object FloatEditCustomBufferSize: TFloatEdit
        AlignWithMargins = True
        Left = 231
        Top = 2
        Width = 55
        Height = 21
        Alignment = taRightJustify
        CharCase = ecLowerCase
        TabOrder = 1
        MaxValueFloat = 5.000000000000000000
        MaxValueInt = 4000
        MinValueInt = 1
        ValueInt = 96
        ValueFloat = 96.000000000000000000
        ValueDefaultInt = 1
        Precision = 10
        Digits = 2
        IntegerMode = True
        EnableEmpty = False
        IncrementSM = 1.000000000000000000
        Increment = 100.000000000000000000
        IncrementPg = 10.000000000000000000
        AutoCorretion = True
        AutoCorretionAsk = True
        SoftValidate = False
        OnValidate = FloatEditCustomBufferSizeValidate
      end
    end
  end
  object ComPort: TComPort
    CustomBaudRate = 9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evTxEmpty]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    SyncMethod = smNone
    OnAfterOpen = ComPortAfterOpen
    OnAfterClose = ComPortAfterClose
    Left = 760
    Top = 8
  end
  object TimerBytesTransmitted: TTimer
    OnTimer = TimerBytesTransmittedTimer
    Left = 808
    Top = 8
  end
  object TimerPlayTone: TTimer
    Interval = 0
    OnTimer = TimerPlayToneTimer
    Left = 808
    Top = 72
  end
  object OpenDialogRecords: TOpenDialog
    Filter = 'Wave Files (*.wav)|*.wav'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 813
    Top = 133
  end
end
