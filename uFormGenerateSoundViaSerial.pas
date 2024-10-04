unit uFormGenerateSoundViaSerial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CompFloatEdit, ExtCtrls, uGenerateSoundViaSerial, CPort,
  uGetComPortList, uPlayMelody, uWAV, uFileMap, IoUtils, Math;

type
  TFormComSound = class(TForm)
    MemoDebug: TMemo;
    PanelMain: TPanel;
    FloatEditSample: TFloatEdit;
    FloatEditBoud: TFloatEdit;
    Label1: TLabel;
    FloatEditFrequency: TFloatEdit;
    Label2: TLabel;
    ComPort: TComPort;
    PanelCom: TPanel;
    ComboBoxPorts: TComboBox;
    ButtonConnect: TButton;
    ButtonGeneratorStart: TButton;
    ButtonStop: TButton;
    ButtonPWMStart: TButton;
    Label4: TLabel;
    LabelBytesTransmitted: TLabel;
    TimerBytesTransmitted: TTimer;
    Label5: TLabel;
    TimerPlayTone: TTimer;
    PanelClient: TPanel;
    PanelMelodies: TPanel;
    Label7: TLabel;
    ListBoxMelodies: TListBox;
    LabelDelay: TLabel;
    GroupBoxConversionSettings: TGroupBox;
    GroupBoxGenerator: TGroupBox;
    GroupBoxPWM: TGroupBox;
    LabelFloatEditSample: TLabel;
    RadioButtonBitPerSample: TRadioButton;
    RadioButtonSampleRate: TRadioButton;
    FloatEditBitPerSample: TFloatEdit;
    FloatEditSampleRate: TFloatEdit;
    MemoSettings: TMemo;
    FloatEditBoudMeasured: TFloatEdit;
    GroupBoxWAV: TGroupBox;
    ButtonOpenWAV: TButton;
    OpenDialogRecords: TOpenDialog;
    ButtonPlayWAV: TButton;
    MemoWAVInfo: TMemo;
    Label8: TLabel;
    FloatEditDownsample: TFloatEdit;
    PanelDebug: TPanel;
    Label3: TLabel;
    CheckBoxCustomBufferSize: TCheckBox;
    FloatEditCustomBufferSize: TFloatEdit;
    LabelBufferSize: TLabel;
    CheckBoxSetBoudMeasured: TCheckBox;
    ButtonSetSR: TButton;
    procedure ButtonProcessClick(Sender: TObject);
    procedure ButtonSetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonGenerateSinusClick(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
    procedure ComPortAfterOpen(Sender: TObject);
    procedure ComPortAfterClose(Sender: TObject);
    procedure ComPortTxEmptyGenerator(Sender: TObject);
    procedure ComPortTxEmptyPWM(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonGeneratorStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FloatEditFrequencyValidate(Sender: TObject);
    procedure FloatEditSampleValidate(Sender: TObject);
    procedure ButtonPWMStartClick(Sender: TObject);
    procedure RefreshPorts;
    procedure CheckComPortExist;
    procedure FloatEditCustomBufferSizeValidate(Sender: TObject);
    procedure TimerBytesTransmittedTimer(Sender: TObject);
    procedure TimerPlayToneTimer(Sender: TObject);
    procedure ListBoxMelodiesDblClick(Sender: TObject);
    procedure ComboBoxBitsChange(Sender: TObject);
    procedure PanelMainDblClick(Sender: TObject);
    procedure ButtonOpenWAVClick(Sender: TObject);
    procedure ButtonPlayWAVClick(Sender: TObject);
    procedure ComPortTxEmptyPlayWAV(Sender: TObject);
    procedure ButtonSetSRClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    frequency: Integer;
    lastGenIndex: UInt64;
    BytesTransmitted: Cardinal;
    PlayToneDelayEnd: Boolean;
    outputBuffer: array of byte;
    BreakPlaying: Boolean;
    FileMapper: TFileMapper;
    WaveHeader: TWaveHeader;
    PSample16bit: PSmallInt;
    PSample8bit: PByte;
    FileSampleCount: integer;
    WAVSampleIndex: integer;
    Downsample: byte;
    scaleSampleCoef: Double;

    procedure SetControlsEnable;
    procedure PlayTone(frequency: Integer);
    procedure NoTone;
    function Delay(duration_ms: Integer): boolean;
    function TakeWAVSample: Double;

    procedure WMDeviceChange(var Message: TMessage); message WM_DEVICECHANGE;
  end;

var
  FormComSound: TFormComSound;

const
  preferredOutputBufferSize = 96;  // on CH340


implementation

{$R *.dfm}

function IntToBinByte(Value: byte): string;
var
  i: Integer;
begin
  SetLength(Result, 8);
  for i := 1 to 8 do
    if (Value shr (8 - i)) and 1 = 0 then
      Result[i] := '0'
    else
      Result[i] := '1';
end;


procedure TFormComSound.ButtonSetupClick(Sender: TObject);
var
  boud: Integer;
  s: String;
  a, b: TNotifyEvent;
begin
  if CheckBoxSetBoudMeasured.Checked then
    boud := FloatEditBoudMeasured.ValueInt
  else
    boud := FloatEditBoud.ValueInt;

  // real measured max bitrate on CH340
//  if (boud = 2000000) then
//    boud := 1527000;
//  if (boud = 1000000) then
//    boud := 935000;
//  if (boud = 500000) then
//    boud := 510000;

  if RadioButtonSampleRate.Checked then
    setupConversionViaSampleRate(boud, FloatEditSampleRate.ValueInt);

  if RadioButtonBitPerSample.Checked then
    setupConversionViaBitCount(boud, FloatEditBitPerSample.ValueInt);

  FloatEditSample.MaxValueInt := maxInputSampleValue;
  LabelFloatEditSample.Caption := 'Value (max ' + IntToStr(maxInputSampleValue) + '):';


  MemoSettings.Clear;
  MemoSettings.Lines.Add('boud: ' + IntToStr(boud));
  MemoSettings.Lines.Add('sampleRate: ' + IntToStr(outputSampleRate));
  if RadioButtonBitPerSample.Checked then
    MemoSettings.Lines.Add('input: ' + IntToStr(FloatEditBitPerSample.ValueInt) + ' bit');
  MemoSettings.Lines.Add('output: ' + FloatToStr(bytesInOutputPacket) + ' bytes, ' +
    IntToStr(maxInputSampleValue + 1) + ' states'); 

  s := MemoSettings.Text;
  SetLength(s, Length(s) - 2);
  MemoSettings.Text := s;

  a := ComPort.OnTxEmpty;
  b := ComPortTxEmptyPWM;
  if (@a = @b) then
    FloatEditSampleValidate(nil);
end;


procedure TFormComSound.ComboBoxBitsChange(Sender: TObject);
begin
  ButtonSetupClick(nil);
end;

procedure TFormComSound.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ComPort.Connected := false;
end;

procedure TFormComSound.FormCreate(Sender: TObject);
var
  msg: TMessage;
begin
  ComPortAfterClose(nil);
  ButtonSetupClick(nil);
  WMDeviceChange(msg);
  frequency := FloatEditFrequency.ValueInt;
end;

 // ----------------------------         ComPort controls     -------------------------------------------

procedure TFormComSound.TimerBytesTransmittedTimer(Sender: TObject);
begin
  LabelBytesTransmitted.Caption := IntToStr(BytesTransmitted);
  BytesTransmitted := 0;
end;


procedure TFormComSound.ButtonConnectClick(Sender: TObject);
begin
  if not ComPort.Connected then
  begin
    ComPort.Port := ComboBoxPorts.Items[ComboBoxPorts.ItemIndex];
    ComPort.CustomBaudRate := FloatEditBoud.ValueInt;
    ButtonSetupClick(nil);
    ComPort.Connected := true;
  end
  else
  begin
    ComPort.Connected := false;
  end;
end;

procedure TFormComSound.ComPortAfterOpen(Sender: TObject);
begin
  SetControlsEnable;

  ButtonConnect.Caption := 'Disconnect';
end;


procedure TFormComSound.ComPortAfterClose(Sender: TObject);
begin
  SetControlsEnable;

  ButtonConnect.Caption := 'Connect';
end;

procedure TFormComSound.SetControlsEnable;
var ComPortConnected: boolean;
begin
  ComPortConnected := ComPort.Connected;

  ComboBoxPorts.Enabled := not ComPortConnected;
  FloatEditBoud.Enabled := not ComPortConnected;

  ButtonPWMStart.Enabled := ComPortConnected;
  ButtonGeneratorStart.Enabled := ComPortConnected;
  ButtonPlayWAV.Enabled := ComPortConnected and Assigned(FileMapper) and FileMapper.MapPtrActive;
end;


procedure TFormComSound.RefreshPorts;
var
  ListComPorts: TStringList;
  FindIndex: Integer;
  SelectedPort: string;
begin
  if (ComboBoxPorts.ItemIndex = -1) then
    SelectedPort := ''
  else
    SelectedPort := ComboBoxPorts.Items[ComboBoxPorts.ItemIndex];

  ListComPorts := TStringList.Create;
  GetComPortListEx(ListComPorts, false, nil);

  ComboBoxPorts.Items.Assign(ListComPorts);

  FreeAndNil(ListComPorts);

  FindIndex := ComboBoxPorts.Items.IndexOf(SelectedPort);

  if (FindIndex = -1) and (ComboBoxPorts.Items.Count > 0) then
    ComboBoxPorts.ItemIndex := 0
  else
  begin
    ComboBoxPorts.ItemIndex := FindIndex;
  end;

  if (FindIndex = -1) and ComPort.Connected then
    ComPort.Connected := false;

end;

procedure TFormComSound.CheckComPortExist;
begin
//  try
//    ComPort.Signals
//  except
//    ComPortAfterClose(nil);
//  end;
end;

procedure TFormComSound.WMDeviceChange(var Message: TMessage);
begin
//  if ComPort.Connected then
//    CheckComPortExist;

  RefreshPorts;
end;

// ----------------------------         Test / Debug     -------------------------------------------


procedure TFormComSound.PanelMainDblClick(Sender: TObject);
begin
  MemoDebug.Visible := not MemoDebug.Visible;
  PanelMelodies.Visible := not PanelMelodies.Visible;
  PanelDebug.Visible := not PanelDebug.Visible;
end;


procedure TFormComSound.ButtonProcessClick(Sender: TObject);
var
  curSample: word;
  outputBuffer: array of byte;
  i: Integer;
  str: string;
begin
  curSample := FloatEditSample.ValueInt;

  SetLength(outputBuffer, Ceil(bytesInOutputPacket));
  shiftFromStart := 0;
  processSample(curSample, PByte(outputBuffer));

  for i := 0 to Length(outputBuffer) - 1 do
    str := str + ' ' + IntToBinByte(outputBuffer[i]);

  MemoDebug.Lines.Add('curSample: ' + IntToStr(curSample) + ', outputBuffer (' +
    IntToStr(Ceil(bytesInOutputPacket)) + 'bytes): ' + str);
end;


procedure TFormComSound.ButtonGenerateSinusClick(Sender: TObject);
var
  i: Integer;
  generatorBuffer: array of byte;
  period: Double;
  curSampleSin: Double;
  str: string;
begin
  period := (outputSampleRate / frequency);
  SetLength(generatorBuffer, 80);


  for i := 0 to Length(generatorBuffer) - 1 do
  begin
    curSampleSin := sin(((i / period) * 2 * Pi) + (Pi / 2));  // -1..1
    curSampleSin := (curSampleSin + 1) / 2;                   //  0..1
    generatorBuffer[i] := Round(curSampleSin * maxInputSampleValue);
  end;

  for i := 0 to Length(generatorBuffer) - 1 do
    str := str + ' ' + IntToStr(generatorBuffer[i]);

  MemoDebug.Lines.Add('inputBuffer for ' + IntToStr(FloatEditFrequency.ValueInt)
      + ' Hz: ' + str);
end;


// ----------------------------         PWM       -------------------------------------------

procedure TFormComSound.FloatEditSampleValidate(Sender: TObject);
var
  outputBufferSize: Integer;
  PWM_Value: word;
  curPacketSize: Integer;
  bufferOffset: Integer;
  i: Integer;
  str: string;
begin
  if MemoDebug.Visible then
    ButtonProcessClick(nil);

  PWM_Value := FloatEditSample.ValueInt;
  if CheckBoxCustomBufferSize.Checked then
    outputBufferSize := FloatEditCustomBufferSize.ValueInt
  else
    if Frac(preferredOutputBufferSize / bytesInOutputPacket) = 0 then
      outputBufferSize := preferredOutputBufferSize
    else
      outputBufferSize := Round(32 * bytesInOutputPacket);

  LabelBufferSize.Caption := IntToStr(outputBufferSize);

  SetLength(outputBuffer, outputBufferSize);
  ZeroMemory(outputBuffer, outputBufferSize);

  bufferOffset := 0;
  shiftFromStart := 0;
  while bufferOffset < Length(outputBuffer) do
  begin
    curPacketSize := processSample(PWM_Value, @outputBuffer[bufferOffset]);
    Inc(bufferOffset, curPacketSize)
  end;

  if MemoDebug.Visible then
  begin
    for i := 0 to Length(outputBuffer) - 1 do
      str := str + ' ' + IntToStr(outputBuffer[i]);

    MemoDebug.Lines.Add('outputBuffer PWM for ' + IntToStr(PWM_Value)
        + ': ' + str);
  end;

end;


procedure TFormComSound.FloatEditCustomBufferSizeValidate(Sender: TObject);
begin
  FloatEditSampleValidate(nil);
end;


procedure TFormComSound.ButtonPWMStartClick(Sender: TObject);
begin
  ComPort.OnTxEmpty := ComPortTxEmptyPWM;
  ComPort.WriteStr('A');
end;


procedure TFormComSound.ComPortTxEmptyPWM(Sender: TObject);
begin
  ComPort.Write(outputBuffer[0], Length(outputBuffer));
  Inc(BytesTransmitted, Length(outputBuffer));
end;


// ----------------------------         Generator     -------------------------------------------

procedure TFormComSound.FloatEditFrequencyValidate(Sender: TObject);
begin
  frequency := FloatEditFrequency.ValueInt;
  if frequency = 0 then
    ButtonStopClick(nil);

  if MemoDebug.Visible then
    ButtonGenerateSinusClick(nil);
end;

procedure TFormComSound.ButtonGeneratorStartClick(Sender: TObject);
begin
  shiftFromStart := 0;
  ComPort.OnTxEmpty := ComPortTxEmptyGenerator;
  ComPort.WriteStr('A');
end;


//procedure TFormComSound.ComPortTxEmptyGeneratorOld(Sender: TObject);
//var
//  period: Double;
//  curSampleSin: Double; // -1..1
//  curSample: byte;
//
//  outputBuffer: array of byte;
//  halfStatesInOutput: Double;
//begin
//  period := (outputSampleRate / frequency);
//
//  halfStatesInOutput := maxInputSampleValue / 2;
//  curSampleSin := sin(((lastGenIndex / period) * 2 * Pi) + (Pi / 2));
//  curSample := Round((curSampleSin * halfStatesInOutput) + halfStatesInOutput);
//
//  Inc(lastGenIndex);
//
//  SetLength(outputBuffer, bytesInOutputPacket);
//  processSample(curSample, PByte(outputBuffer), false);
//
//  ComPort.Write(outputBuffer[0], Length(outputBuffer));
//  Inc(BytesTransmitted, Length(outputBuffer));
//end;


procedure TFormComSound.ComPortTxEmptyGenerator(Sender: TObject);
var
  period: Double;
  curSampleSin: Double;
  curSample: Double;
  outputBufferSize: Integer;
  outputBuffer: array of byte;
  curPacketSize: Integer;
  bufferOffset: Integer;
begin
  period := (outputSampleRate / frequency);

  if Frac(preferredOutputBufferSize / bytesInOutputPacket) = 0 then
    outputBufferSize := preferredOutputBufferSize
  else
    outputBufferSize := Round(32 * bytesInOutputPacket);

  SetLength(outputBuffer, outputBufferSize);

  bufferOffset := 0;
  while bufferOffset < Length(outputBuffer) do
  begin
    curSampleSin := sin(((lastGenIndex / period) * 2 * Pi) + (Pi / 2));  // -1..1
    curSampleSin := (curSampleSin + 1) / 2;                   //  0..1
    curSample := curSampleSin * maxInputSampleValue;

    Inc(lastGenIndex);

    curPacketSize := processSample(curSample, @outputBuffer[bufferOffset]);
    Inc(bufferOffset, curPacketSize)
  end;

  ComPort.Write(outputBuffer[0], Length(outputBuffer));
  Inc(BytesTransmitted, Length(outputBuffer));
end;


procedure TFormComSound.ButtonStopClick(Sender: TObject);
begin
  ComPort.OnTxEmpty := nil;
  if Sender <> nil then
    BreakPlaying := true;
end;


// ----------------------------         PlayMelody     -------------------------------------------

procedure TFormComSound.ListBoxMelodiesDblClick(Sender: TObject);
var
  melody: AnsiString;
begin
  melody := ListBoxMelodies.Items[ListBoxMelodies.ItemIndex];

  uPlayMelody.playTone := PlayTone;
  uPlayMelody.delay := Delay;
  uPlayMelody.noTone := NoTone;
  BreakPlaying := false;

  if ButtonGeneratorStart.Enabled then
    playMelody(PAnsiChar(melody));
end;


procedure TFormComSound.PlayTone(frequency: Integer);
begin
  FloatEditFrequency.ValueInt := frequency;
  FloatEditFrequencyValidate(nil);

  if not Assigned(ComPort.OnTxEmpty) then
    ButtonGeneratorStartClick(nil);
end;

procedure TFormComSound.NoTone;
begin
  ButtonStopClick(nil);
end;

function TFormComSound.Delay(duration_ms: Integer): boolean;
begin
  PlayToneDelayEnd := false;
  TimerPlayTone.Interval := 0;
  TimerPlayTone.Interval := duration_ms;
  LabelDelay.Caption := IntToStr(TimerPlayTone.Interval);

  while not PlayToneDelayEnd and not BreakPlaying do
  begin
    Application.ProcessMessages;
    Sleep(0);
  end;
  Result := BreakPlaying;
end;

procedure TFormComSound.TimerPlayToneTimer(Sender: TObject);
begin
  PlayToneDelayEnd := true;
  TimerPlayTone.Interval := 0;
end;



// ----------------------------        Play WAV       -------------------------------------------



procedure TFormComSound.ButtonOpenWAVClick(Sender: TObject);
var FName: string;
    FPWaveHeader: PWaveHeader;
    RecordSize: integer;
    s: string;
begin

  if OpenDialogRecords.Execute then
  begin
    ButtonPlayWAV.Enabled := false;
    FName := OpenDialogRecords.FileName;

    if Assigned(FileMapper) then
    begin
      FileMapper.UnMapDataFile;
      FreeAndNil(FileMapper);
    end;

    FileMapper := TFileMapper.OpenFile(FName, true);
    FileMapper.MapDataFile;

    if (FileMapper.MapPtrActive) then
    begin
      FPWaveHeader := FileMapper.MapFilePtr;
      WaveHeader := FPWaveHeader^;

      MemoWAVInfo.Clear;
      with WaveHeader do
      begin
        if (idRiff <> 'RIFF') or
          (idWave <> 'WAVE') or
          (idFmt <> 'fmt ') or
          (InfoSize <> 16) or
          (wFormatTag <> 1) or
          (idData <> 'data') then
          begin
            MemoWAVInfo.Lines.Add('Invalid WAV');
            FileMapper.UnMapDataFile;

            SetControlsEnable;
            exit;
          end;
      end;



      MemoWAVInfo.Lines.Add(TPath.GetFileName(FName));
      MemoWAVInfo.Lines.Add(IntToStr(WaveHeader.nSamplesPerSec) + ' Hz, ' +
        IntToStr(WaveHeader.wBitsPerSample) + ' bit, ' +
        IntToStr(WaveHeader.nChannels) + ' ch');

      s := MemoWAVInfo.Text;
      SetLength(s, Length(s) - 2);
      MemoWAVInfo.Text := s;

      RecordSize := WaveHeader.DataSize;
      if (FileMapper.MapFileSize - SizeOf(TWaveHeader) < WaveHeader.DataSize)
        then RecordSize := FileMapper.MapFileSize - SizeOf(TWaveHeader);

      FileSampleCount := ((RecordSize div (WaveHeader.wBitsPerSample div 8)) div WaveHeader.nChannels);

      FloatEditDownsample.ValueInt := (WaveHeader.nSamplesPerSec div 10000) + 1;
    end;

    SetControlsEnable;
  end;

end;

procedure TFormComSound.ButtonSetSRClick(Sender: TObject);
begin
  FloatEditSampleRate.ValueInt := WaveHeader.nSamplesPerSec div FloatEditDownsample.ValueInt;
  ButtonSetupClick(nil);
end;

procedure TFormComSound.ButtonPlayWAVClick(Sender: TObject);
var    FPWaveHeader: PWaveHeader;
begin
  Downsample := FloatEditDownsample.ValueInt;
  RadioButtonSampleRate.Checked := true;
  ButtonSetupClick(nil);

  FPWaveHeader := FileMapper.MapFilePtr;
  Inc(FPWaveHeader);
  PSample16bit := PSmallInt(FPWaveHeader);
  PSample8bit := PByte(FPWaveHeader);

  if WaveHeader.wBitsPerSample = 8 then
    scaleSampleCoef := maxInputSampleValue / MAXBYTE;
  if WaveHeader.wBitsPerSample = 16 then
    scaleSampleCoef := maxInputSampleValue / MAXWORD;

//  scaleSampleCoef := maxInputSampleValue / ((1 shl WaveHeader.wBitsPerSample) - 1);

  WAVSampleIndex := 0;
  shiftFromStart := 0;

  ComPort.OnTxEmpty := ComPortTxEmptyPlayWAV;
  ComPort.WriteStr('A');
end;


function TFormComSound.TakeWAVSample: Double;
begin
  if WAVSampleIndex >= FileSampleCount then
    ButtonStopClick(nil);

  if WaveHeader.wBitsPerSample = 16 then
  begin
  {$POINTERMATH ON}
    Result := PSample16bit[WAVSampleIndex * WaveHeader.nChannels];
  {$POINTERMATH OFF}
    Result := Result + 32768;
  end;

  if WaveHeader.wBitsPerSample = 8 then
  begin
    Result := PSample8bit[WAVSampleIndex * WaveHeader.nChannels];
  end;

  Inc(WAVSampleIndex);
end;


procedure TFormComSound.ComPortTxEmptyPlayWAV(Sender: TObject);
var
  outputBufferSize: Integer;
  outputBuffer: array of byte;
  di, curPacketSize: Integer;
  curSample: Double;
  sumOfSamples: Double;
  bufferOffset: Integer;

begin
  if Frac(preferredOutputBufferSize / bytesInOutputPacket) = 0 then
    outputBufferSize := preferredOutputBufferSize
  else
    outputBufferSize := Round(32 * bytesInOutputPacket);

  SetLength(outputBuffer, outputBufferSize);

  bufferOffset := 0;
  while bufferOffset < Length(outputBuffer) do
  begin
    sumOfSamples := 0;
    for di := 1 to Downsample do
      sumOfSamples := sumOfSamples + TakeWAVSample;

    curSample := (sumOfSamples / Downsample) * scaleSampleCoef;

    curPacketSize := processSample(curSample, @outputBuffer[bufferOffset]);
    Inc(bufferOffset, curPacketSize)
  end;

  ComPort.Write(outputBuffer[0], Length(outputBuffer));
  Inc(BytesTransmitted, Length(outputBuffer));
end;



end.
