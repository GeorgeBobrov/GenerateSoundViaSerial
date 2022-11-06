unit uWAV;

interface

type
  PWaveHeader = ^TWaveHeader;
  TWaveHeader = packed record
    idRiff: packed array[0..3] of AnsiChar;
    RiffSize: cardinal;

    idWave: packed array[0..3] of AnsiChar;
    idFmt: packed array[0..3] of AnsiChar;
    InfoSize: cardinal;
    wFormatTag: word;
    nChannels: word;
    nSamplesPerSec: cardinal;
    nAvrgBytesPerSec: cardinal;
    nBlockAlign: word;
    wBitsPerSample: word;

    idData: packed array[0..3] of AnsiChar;
    DataSize: cardinal;
  end;




implementation

end.
