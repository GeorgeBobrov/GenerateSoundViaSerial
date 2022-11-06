unit uGetComPortList;

interface

uses Windows, Classes, Generics.Collections,
  Generics.Defaults, Registry, StrUtils, SysUtils;

type
  TComNameDescription = record
    ComName: string;
    ComDescription: string;
  end;

procedure GetComPortListEx(ListComNames: TStringList; FilterOnlyUSB: Boolean;
  ListComNamesDescriptions: TList<TComNameDescription>);

implementation

function CompareVCPFirst(const Left, Right: TComNameDescription): Integer;
begin
  Result := Ord(ContainsText(Right.ComDescription, 'VCP')) -
            Ord(ContainsText(Left.ComDescription, 'VCP'));

  if Result = 0 then
    Result := Ord(ContainsText(Right.ComDescription, 'Silabser')) -
              Ord(ContainsText(Left.ComDescription, 'Silabser'));

  if Result = 0 then
    Result := Ord(ContainsText(Right.ComDescription, 'Serial')) -
              Ord(ContainsText(Left.ComDescription, 'Serial'));

  if Result = 0 then
    Result := Length(Left.ComName) - Length(Right.ComName);

  if Result = 0 then
    Result := CompareText(Left.ComName, Right.ComName);

end;

procedure GetComPortListEx(ListComNames: TStringList; FilterOnlyUSB: Boolean;
  ListComNamesDescriptions: TList<TComNameDescription>);
var
  reg: TRegistry;
  LValueNames:tStrings;
  i: integer;
  AddPort: Boolean;

var sComName: string;
    ValueNameComDescription: string;

  CurComNameDescription: TComNameDescription;
  FreeListComNamesDescriptions: Boolean;
begin
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.Access:=KEY_READ;

  reg.OpenKey('HARDWARE\DEVICEMAP\SERIALCOMM', false);
  LValueNames := TStringList.Create;

  FreeListComNamesDescriptions := false;
  if (ListComNamesDescriptions = nil) then
  begin
    ListComNamesDescriptions := TList<TComNameDescription>.Create;
    FreeListComNamesDescriptions := true;
  end;

  if (LValueNames<>nil) and (ListComNames<>nil) then
  begin
    reg.GetValueNames(LValueNames);
    ListComNames.Clear;
    ListComNamesDescriptions.Clear;
    for i := 0 to LValueNames.Count - 1 do
    begin
      ValueNameComDescription := LValueNames[i];

      AddPort := true;
      if FilterOnlyUSB then
        AddPort := ContainsText(ValueNameComDescription, 'Silabser') or
                   ContainsText(ValueNameComDescription, 'VCP') or
                   ContainsText(ValueNameComDescription, 'Serial');

      if AddPort then
      begin
        sComName := reg.ReadString(ValueNameComDescription);
//        ListComNames.Add(sComName);
        CurComNameDescription.ComName := sComName;
        CurComNameDescription.ComDescription := ValueNameComDescription;
        ListComNamesDescriptions.Add(CurComNameDescription);
      end;
    end;

    ListComNamesDescriptions.Sort(TComparer<TComNameDescription>.Construct(CompareVCPFirst));

  end;

  for CurComNameDescription in ListComNamesDescriptions do
    ListComNames.Add(CurComNameDescription.ComName);

  LValueNames.Free;
  if FreeListComNamesDescriptions then
    ListComNamesDescriptions.Free;
  reg.CloseKey;
  reg.free;
end;



end.
