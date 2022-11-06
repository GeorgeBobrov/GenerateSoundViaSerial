unit uGenerateSoundViaSerial;

interface

uses
  Windows, BitConstants;

var boud: Integer;
var bitsInByte: Byte;
var bitsInSample: Byte;
var outputSampleRate: Integer;
var bytesPerSec: Integer;
var bytesInOutputPacket: Integer;
var statesInSample: Integer;
var statesInOutput: Integer;

procedure setupConversionViaSampleRate(a_boud: Integer; a_outputSampleRate: Integer);
procedure setupConversionViaBitCount(a_boud: Integer; a_bitsInSample: byte);
procedure processSample(sample: word; outputBuffer: PByte; mapStates: boolean);
function processSample3bit(sample3bit: byte): byte;

implementation

var remainBitsFromPrevSample: Single;
var remainBitsToCompleteByte: Byte;
var statesCoef: Double;

// Fixed 8 bit sample
procedure setupConversionViaSampleRate(a_boud: Integer; a_outputSampleRate: Integer);
begin
  boud := a_boud;
  bitsInByte := 10; // one start and one stop bit
  bitsInSample := 8;
  statesInSample := MAXBYTE; // bits in 8 bit sample
  outputSampleRate := a_outputSampleRate;
  bytesPerSec := boud div bitsInByte;
  bytesInOutputPacket := Trunc(bytesPerSec / outputSampleRate);
  statesInOutput := bytesInOutputPacket * 8; // 25 * 8 = 200 for 2000000 Mbit
  statesCoef := statesInOutput / statesInSample;
end;

procedure setupConversionViaBitCount(a_boud: Integer; a_bitsInSample: byte);
begin
  boud := a_boud;
  bitsInByte := 10; // one start and one stop bit
  bytesPerSec := boud div bitsInByte;
  bitsInSample := a_bitsInSample;
  statesInSample := Word(1) shl bitsInSample;
  bytesInOutputPacket := statesInSample div 8;

  outputSampleRate := bytesPerSec div bytesInOutputPacket;

  statesInOutput := statesInSample;
  statesCoef := statesInOutput / statesInSample;
end;

procedure processSample(sample: word; outputBuffer: PByte; mapStates: boolean);
var bitsToSet, bytesToSet, remainBits: Byte;
    i: integer;
begin
    if mapStates then
    begin
        if sample > statesInOutput then
            sample := statesInOutput;

        if statesInOutput <> statesInSample then
          bitsToSet := Round(sample * statesCoef)
        else
          bitsToSet := sample;
    end
    else
        bitsToSet := sample;

    bytesToSet := bitsToSet div 8;
    remainBits := bitsToSet mod 8;

    for i := 0 to bytesToSet - 1 do
        outputBuffer[i] := MAXBYTE;

    for i := bytesToSet to bytesInOutputPacket - 1 do
        outputBuffer[i] := 0;

    if remainBits > 0 then
        outputBuffer[bytesToSet] := (Word(1) shl remainBits) - 1;

//    case (remainBits) of
//        1: outputBuffer[bytesToSet] := B00000001;
//        2: outputBuffer[bytesToSet] := B00000011;
//        3: outputBuffer[bytesToSet] := B00000111;
//        4: outputBuffer[bytesToSet] := B00001111;
//        5: outputBuffer[bytesToSet] := B00011111;
//        6: outputBuffer[bytesToSet] := B00111111;
//        7: outputBuffer[bytesToSet] := B01111111;
//    end;

//   result := remainBitsForNextSample;
end;

function processSample3bit(sample3bit: byte): byte;
begin
  case (sample3bit) of
      0: Result := 0;
      1: Result := B00000001;
      2: Result := B00000011;
      3: Result := B00000111;
      4: Result := B00001111;
      5: Result := B00011111;
      6: Result := B00111111;
      7: Result := B01111111;
      else
         Result := B11111111;
  end;
end;

end.
