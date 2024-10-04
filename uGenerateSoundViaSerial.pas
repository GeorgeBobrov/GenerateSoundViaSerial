unit uGenerateSoundViaSerial;

interface

uses
  Windows;

var outputSampleRate: Cardinal;
var bytesPerSec: Cardinal;
var bytesInOutputPacket: Double;
var maxInputSampleValue: Cardinal;
var needBuffersToIntegerSize: Cardinal;

var shiftFromStart: Cardinal;

procedure setupConversionViaSampleRate(boud: Cardinal; a_outputSampleRate: Cardinal);
procedure setupConversionViaBitCount(boud: Cardinal; bitsInSample: byte);
function processSample(sample: Double; outputBuffer: PByte): Cardinal;

implementation

const bitsInComByte = 10; // one start and one stop bit


// calculate bytesInOutputPacket and maxInputSampleValue from given SampleRate
procedure setupConversionViaSampleRate(boud: Cardinal; a_outputSampleRate: Cardinal);
var bitsInOutputPacket: Cardinal;
    meaningfulBitsPerSecond: Cardinal;
begin
  outputSampleRate := a_outputSampleRate;
  bytesPerSec := boud div bitsInComByte;
  meaningfulBitsPerSecond := bytesPerSec * 8;
  bitsInOutputPacket := Round(meaningfulBitsPerSecond / outputSampleRate);
//  needBuffersToIntegerSize := 8 div (bitsInOutputPacket mod 8);

  maxInputSampleValue := bitsInOutputPacket;

  bytesInOutputPacket := bitsInOutputPacket / 8;
  shiftFromStart := 0;
end;



procedure setupConversionViaBitCount(boud: Cardinal; bitsInSample: byte);
begin
  bytesPerSec := boud div bitsInComByte;
  maxInputSampleValue := Word(1) shl bitsInSample;
  bytesInOutputPacket := maxInputSampleValue div 8;

  outputSampleRate := bytesPerSec div Trunc(bytesInOutputPacket);
  shiftFromStart := 0;
end;

//var remainBitsFromPrevSample: Single;
//var remainBitsToCompleteByte: Byte;


// sample in range 0..maxInputSampleValue
// outputBuffer have to be at least ceil(bytesInOutputPacket) size, and zeroed

//Added the ability to use packages with a fractional number of bytes in them.
//It is assumed that these packets will be written to one large buffer sequentially.

//Returns whole number of bytes written.
//Also, in other words, returns the offset to set for the next packet in the buffer.
//If a fractional number of bytes was written in the current function call,
//then the offset points to the partially written byte,
//so the next call can finish writing this byte.
//In this case the value of this offset is equal to trunc(bytesInOutputPacket).
//If an integer number of bytes was written in the current function call
//(all fractional pieces of bytes from previous packets were added to one whole byte),
//then the offset in this case is equal to ceil(bytesInOutputPacket).

function processSample(sample: Double; outputBuffer: PByte): Cardinal;
var byteIndex, bitIndex: Cardinal;
    i: integer;
    loadOnOneBit, remainFromPrevBit: Double;
begin
//    for i := 0 to bytesInOutputPacket - 1 do
//      outputBuffer[i] := 0;

    loadOnOneBit := sample / maxInputSampleValue;
    remainFromPrevBit := 0;

    // maxInputSampleValue = number of bits in output packet
    for i := shiftFromStart to shiftFromStart + maxInputSampleValue - 1 do
    begin
      remainFromPrevBit := remainFromPrevBit + loadOnOneBit;
      // to exclude error in calculations with floating point numbers
      if remainFromPrevBit + 1E-13 >= 1 then
      begin
        byteIndex := i div 8;
        bitIndex := i mod 8;
        outputBuffer[byteIndex] := outputBuffer[byteIndex] or (Byte(1) shl bitIndex);

        remainFromPrevBit := remainFromPrevBit - 1;
      end;
    end;

    Inc(shiftFromStart, maxInputSampleValue); // add number of bits writen
    result := shiftFromStart div 8;           // return whole number of bytes written
    shiftFromStart := shiftFromStart mod 8;   // left only fraction of byte writen
end;




end.
