program GenerateSoundViaSerial;

uses
  Forms,
  uFormGenerateSoundViaSerial in 'uFormGenerateSoundViaSerial.pas' {FormComSound},
  uGenerateSoundViaSerial in 'uGenerateSoundViaSerial.pas',
  uGetComPortList in 'uGetComPortList.pas',
  uRTTTL_Parser in 'uRTTTL_Parser.pas',
  uWAV in 'uWAV.pas',
  uFileMap in 'uFileMap.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormComSound, FormComSound);
  Application.Run;
end.
