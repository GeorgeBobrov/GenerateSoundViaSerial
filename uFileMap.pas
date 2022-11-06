unit uFileMap;
{.$i incl}

interface
uses Windows, classes{, UnitUtils, UnitUtils2}, SysUtils;

type
  TFileMapper=class(TPersistent)
  private
    flag1:boolean;
  protected
    fMapHandle:THandle;
    fMapFilePtr:pointer;
    fMapPtrActive:boolean;
    fMapFileSize:cardinal;
    fMapFileName:WideString;
    fMapFileHandle:THandle;
    procedure SetMapEnabled(en:boolean);virtual;
    procedure OpenMapFileH(aFileH:THandle);
    procedure OpenMapFileName(aFileName:WideString);
    procedure SetMapFileSize(asize:cardinal);
    procedure SetMapFileReadOnly(aValue:boolean);
  public
    MapFileAutoClose:boolean;
    MapError:dword;
    fMapFileReadOnly:boolean;
    property MapFileName:WideString read fMapFileName write OpenMapFileName;
    property MapFileHandle:THandle read fMapFileHandle write OpenMapFileH;
    property MapFilePtr:pointer read fMapFilePtr;
    property MapPtrActive:boolean read fMapPtrActive write SetMapEnabled;
    property MapFileSize:cardinal read fMapFileSize write SetMapFileSize;
    property MapFileReadOnly:boolean read fMapfileReadOnly write SetMapFileReadOnly;
  public

    dwFileOffsetHigh: cardinal;
    dwFileOffsetLow: cardinal;
    dwNumberOfBytesToMap: cardinal;

    constructor Create;
    constructor OpenFile(fFN:string; aReadOnly:boolean);
    destructor Destroy;override;
    Procedure MapDataFile;virtual;
    Procedure UnMapDataFile;virtual;
    procedure ShowMapError;virtual;
//    function SaveFileSign(Sign:StrSignType):integer;
//    function LoadFileSign(const SignArr:array of rSignVerInfo; var VerCode:word):integer;
  end;


implementation

constructor TFileMapper.create;
begin
  Inherited Create;
  fMapFileHandle:=INVALID_HANDLE_VALUE;
end;

destructor TFileMapper.destroy;
begin
  MapFileName:='';
  Inherited Destroy;
end;

constructor TFileMapper.OpenFile(fFN: string; aReadOnly: boolean);
begin
  Create;
  fMapFileReadOnly:=aReadOnly;
  MapFileName:=fFn;
end;

procedure TFileMapper.OpenMapFileH(aFileH:THandle);
begin
  if aFileH<>fMapFileHandle then begin
    UnMapDataFile;
    if MapFileAutoClose then closeHandle(fMapFileHandle);
    MapFileAutoClose:=false;
    fMapFileHandle:=aFileH;
    fMapFileName:='';
    MapDataFile;
  end;
end;

procedure TFileMapper.OpenMapFileName(aFileName:WideString);
var
  dwDesiredAccess, dwCreationDistribution:dWord;
begin
  if fMapFileName<>aFileName then begin
    if fMapfileReadOnly then begin
      dwDesiredAccess:=GENERIC_READ;
      dwCreationDistribution:=OPEN_EXISTING;
    end else begin
      dwDesiredAccess:=GENERIC_READ or GENERIC_WRITE;
      dwCreationDistribution:=OPEN_ALWAYS;
    end;
    UnMapDataFile;
    if MapFileAutoClose then closeHandle(fMapFileHandle);
    fMapFileHandle:=INVALID_HANDLE_VALUE;
    MapFileAutoClose:=true;
    fMapFileName:=aFileName;
    if fMapFileName<>'' then begin
      fMapFileHandle:=createFileW(PWideChar(fMapFileName), dwDesiredAccess, 0, nil, dwCreationDistribution,0,0);
{      aN:=fMapFileName;
      if WideStringSupport then
        fMapFileHandle:=createFileW(PWideChar(fMapFileName), dwDesiredAccess, 0,0, dwCreationDistribution,0,0)
      else begin
        fMapFileHandle:=createFileA(PAnsyChar(aN), dwDesiredAccess, 0,0, dwCreationDistribution,0,0);
      end;}
      if (fMapFileHandle=INVALID_HANDLE_VALUE) or (fMapFileHandle=0) then
        ShowMapError;
    end;
    MapDataFile;
  end;
end;

procedure TFileMapper.SetMapFileReadOnly(aValue:boolean);
var
  n:WideString;
begin
  if fMapFileReadOnly<>aValue then begin
    fMapfileReadOnly:=aValue;
    if MapFileName<>'' then  begin
      n:=MapFileName;
      MapFileName:='';
      MapFileName:=n;
    end;  
  end;
end;

procedure TFileMapper.SetMapFileSize(asize:cardinal);
var ok:boolean;
    res:dword;
begin
  if (fMapFileHandle=INVALID_HANDLE_VALUE) then exit;
  UnMapDataFile;
  if aSize>=$FFFFFFF0 then aSize:=$FFFFFFF0;
  res:=SetFilePointer(fMapFileHandle, aSize, nil, 0);
  if res=aSize then
    ok:=SetEndOfFile(fMapFileHandle)
  else ok:=false;
  if ok then else ShowMapError;
  mapDataFile;
end;

procedure TFileMapper.ShowMapError;
begin
  mapError:=GetLastError;

  if mapError<>0 then raise
//  EFileError.Create(GetErrorText(mapError), mapError);
    Exception.Create('MapFile Error ' + IntToStr(mapError));
end;

Procedure TFileMapper.MapDataFile;
var
  flProtect:dWord;
begin
  mapError:=0;
  if fMapPtrActive or (fMapFileHandle=INVALID_HANDLE_VALUE) then exit;
  fMapFileSize:=GetFileSize(fMapFileHandle, nil);
  fMapPtrActive:=false;
  if fMapFileSize=0 then begin
    if flag1 then
      flag1:=false;
    begin
      flag1:=true;
      MapFileSize:=1;
      exit;
    end;
  end;
  if fMapFileReadOnly then flProtect:=PAGE_READONLY  else flProtect:=PAGE_READWRITE;
  fMapHandle:=CreateFileMapping(fMapFileHandle, nil, flProtect, 0,0, nil);
//  fMapHandle:=CreateFileMapping(fMapFileHandle, nil, flProtect, 0,fMapFileSize, nil);
  if fMapHandle=0 then begin
    ShowMapError;
  end else begin
    SetMapEnabled(true);
  end;
end;

Procedure TFileMapper.UnMapDataFile;
begin
  if fMapFilePtr<>nil then UnMapViewOfFile(fMapFilePtr);
  fMapFilePtr:=nil;
  fMapPtrActive:=false;
  CloseHandle(fMapHandle);
  fMapHandle:=0;
end;

procedure TFileMapper.SetMapEnabled(en:boolean);
var
  dwDesiredAccess:dWord;
begin
  mapError:=0;
  if fMapHandle=0 then fMapPtrActive:=false
  else begin
    if en then begin
      if Not fMapPtrActive then begin
        if fMapFileReadOnly then dwDesiredAccess:=FILE_MAP_READ	 else dwDesiredAccess:=FILE_MAP_WRITE;
        fMapFilePtr:= MapViewOfFile(fMapHandle, dwDesiredAccess,
          dwFileOffsetHigh,dwFileOffsetLow, dwNumberOfBytesToMap);
        if fMapFilePtr=nil then begin
          fMapPtrActive:=false;
          ShowMapError;
        end else fMapPtrActive:=true;
      end;
    end else begin
      if fMapPtrActive then begin
        UnMapViewOfFile(fMapFilePtr);
        fMapFilePtr:=nil;
        fMapPtrActive:=false;
      end;
    end;
  end;
end;

//function TFileMapper.SaveFileSign(Sign:StrSignType):integer;
//var
//  s:shortString;
//  p:pointer;
//  sz:Longword;
//begin
//  result:=0;
//  if MapPtrActive and (MapFileSize>=32) then begin
//    fillChar(s, sizeof(s),0);
//    s:=sign;
//    s[0]:=#30;
//    s:=s+strSignTail;
//    if MApFileSize<length(s) then MapFileSize:=length(s);
//    p:=MapFilePtr;
//    sz:=longword(p)+MapFileSize;
//    CopyDataDump(s[1], p, length(s), sz);
//    result:=length(s);
//  end;
//end;
//
//function TFileMapper.LoadFileSign(const SignArr:array of rSignVerInfo; var VerCode:word):integer;
//var
//  s,asign:shortString;
//  i:integer;
//  p:pointer;
//  sz:longword;
//begin
//  result:=0;
//  VerCode:=0;
//  if MapPtrActive and (MapFileSize>32) then begin
//    sz:=MapFileSize;
//    p:=MapfilePtr;
//    sz:=sz+longword(p);
//    s[0]:=char(FileSignSize);
//    copyDumpData(p, s[1], FileSignSize, sz);
//    for i:=0 to Length(SignArr)-1 do with SignArr[i] do begin
//      aSign:=Sign+strSignTail;
//      s[0]:=aSign[0];
//      if s=aSign then begin
//        VerCode:=Ver;
//        result:=length(aSign);
//        break;
//      end;
//    end;
//  end;
//end;


end.
