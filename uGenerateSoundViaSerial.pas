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
var maxInputSampleValue: Integer;

var scaleSampleCoef: Double;

procedure setupConversionViaSampleRate(a_boud: Integer; a_outputSampleRate: Integer);
procedure setupConversionViaBitCount(a_boud: Integer; a_bitsInSample: byte);
procedure processSample(sample: Double; outputBuffer: PByte);
function processSample3bit(sample3bit: byte): byte;

implementation

//var remainBitsFromPrevSample: Single;
//var remainBitsToCompleteByte: Byte;

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
  maxInputSampleValue := bytesInOutputPacket * 8; // = statesInOutputPacket = bitsInOutputPacket
  scaleSampleCoef := maxInputSampleValue / statesInSample;
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

  maxInputSampleValue := statesInSample;
  scaleSampleCoef := 1;
end;

//procedure processSample(sample: word; outputBuffer: PByte; mapStates: boolean);
//var bitsToSet, bytesToSet, remainBits: Byte;
//    i: integer;
//begin
//    if mapStates then
//    begin
//        if sample > maxInputSampleValue then
//            sample := maxInputSampleValue;
//
//        if maxInputSampleValue <> statesInSample then
//          bitsToSet := Round(sample * scaleSampleCoef)
//        else
//          bitsToSet := sample;
//    end
//    else
//        bitsToSet := sample;
//
//    if useSpread then
//    begin
//      processSampleSpread(bitsToSet, outputBuffer);
//      exit;
//    end;
//
//    bytesToSet := bitsToSet div 8;
//    remainBits := bitsToSet mod 8;
//
//    for i := 0 to bytesToSet - 1 do
//        outputBuffer[i] := MAXBYTE;
//
//    for i := bytesToSet to bytesInOutputPacket - 1 do
//        outputBuffer[i] := 0;
//
//    if remainBits > 0 then
//        outputBuffer[bytesToSet] := (Word(1) shl remainBits) - 1;
//
//end;


procedure processSample(sample: Double; outputBuffer: PByte);
var byteIndex, bitIndex: Byte;
    i: integer;
    loadOnOneBit, remainFromPrevBit: Double;
begin
    for i := 0 to bytesInOutputPacket - 1 do
      outputBuffer[i] := 0;

    loadOnOneBit := sample / maxInputSampleValue;
    remainFromPrevBit := 0;

    // maxInputSampleValue = number of bits in output packet
    for i := 0 to maxInputSampleValue - 1 do
    begin
      remainFromPrevBit := remainFromPrevBit + loadOnOneBit;
      if remainFromPrevBit >= 1 then
      begin
        byteIndex := i div 8;
        bitIndex := i mod 8;
        outputBuffer[byteIndex] := outputBuffer[byteIndex] or (Byte(1) shl bitIndex);

        remainFromPrevBit := remainFromPrevBit - 1;
      end;
    end;

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
