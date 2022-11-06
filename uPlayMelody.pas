unit uPlayMelody;

interface

const
  OCTAVE_OFFSET = 0;
  NOTE_C4       = 262;
  NOTE_CS4      = 277;
  NOTE_D4       = 294;
  NOTE_DS4      = 311;
  NOTE_E4       = 330;
  NOTE_F4       = 349;
  NOTE_FS4      = 370;
  NOTE_G4       = 392;
  NOTE_GS4      = 415;
  NOTE_A4       = 440;
  NOTE_AS4      = 466;
  NOTE_B4       = 494;
  NOTE_C5       = 523;
  NOTE_CS5      = 554;
  NOTE_D5       = 587;
  NOTE_DS5      = 622;
  NOTE_E5       = 659;
  NOTE_F5       = 698;
  NOTE_FS5      = 740;
  NOTE_G5       = 784;
  NOTE_GS5      = 831;
  NOTE_A5       = 880;
  NOTE_AS5      = 932;
  NOTE_B5       = 988;
  NOTE_C6       = 1047;
  NOTE_CS6      = 1109;
  NOTE_D6       = 1175;
  NOTE_DS6      = 1245;
  NOTE_E6       = 1319;
  NOTE_F6       = 1397;
  NOTE_FS6      = 1480;
  NOTE_G6       = 1568;
  NOTE_GS6      = 1661;
  NOTE_A6       = 1760;
  NOTE_AS6      = 1865;
  NOTE_B6       = 1976;
  NOTE_C7       = 2093;
  NOTE_CS7      = 2217;
  NOTE_D7       = 2349;
  NOTE_DS7      = 2489;
  NOTE_E7       = 2637;
  NOTE_F7       = 2794;
  NOTE_FS7      = 2960;
  NOTE_G7       = 3136;
  NOTE_GS7      = 3322;
  NOTE_A7       = 3520;
  NOTE_AS7      = 3729;
  NOTE_B7       = 3951;


const // 1d arrays
  notes : array[0..48] of integer = (
    0, NOTE_C4, NOTE_CS4, NOTE_D4, NOTE_DS4, NOTE_E4, NOTE_F4, NOTE_FS4,
    NOTE_G4, NOTE_GS4, NOTE_A4, NOTE_AS4, NOTE_B4, NOTE_C5, NOTE_CS5,
    NOTE_D5, NOTE_DS5, NOTE_E5, NOTE_F5, NOTE_FS5, NOTE_G5, NOTE_GS5,
    NOTE_A5, NOTE_AS5, NOTE_B5, NOTE_C6, NOTE_CS6, NOTE_D6, NOTE_DS6,
    NOTE_E6, NOTE_F6, NOTE_FS6, NOTE_G6, NOTE_GS6, NOTE_A6, NOTE_AS6,
    NOTE_B6, NOTE_C7, NOTE_CS7, NOTE_D7, NOTE_DS7, NOTE_E7, NOTE_F7,
    NOTE_FS7, NOTE_G7, NOTE_GS7, NOTE_A7, NOTE_AS7, NOTE_B7 );


//const song1 = 'The Simpsons:d=4,o=5,b=160:c.6,e6,f#6,8a6,g.6,e6,c6,8a,8f#,8f#,8f#,2g,8p,8p,8f#,8f#,8f#,8g,a#.,8c6,8c6,8c6,c6';
//const song2 = 'Indiana:d=4,o=5,b=250:e,8p,8f,8g,8p,1c6,8p.,d,8p,8e,1f,p.,g,8p,8a,8b,8p,1f6,p,a,8p,8b,2c6,2d6,2e6,e,8p,8f,8g,8p,1c6,p,d6,8p,8e6,1f.6,g,8p,8g,e.6,8p,d6,8p,8g,e.6,8p,d6,8p,8g,f.6,8p,e6,8p,8d6,2c6';
//const song3 = 'Entertainer:d=4,o=5,b=140:8d,8d#,8e,c6,8e,c6,8e,2c.6,8c6,8d6,8d#6,8e6,8c6,8d6,e6,8b,d6,2c6,p,8d,8d#,8e,c6,8e,c6,8e,2c.6,8p,8a,8g,8f#,8a,8c6,e6,8d6,8c6,8a,2d6';
//const song4 = 'Looney:d=4,o=5,b=140:32p,c6,8f6,8e6,8d6,8c6,a.,8c6,8f6,8e6,8d6,8d#6,e.6,8e6,8e6,8c6,8d6,8c6,8e6,8c6,8d6,8a,8c6,8g,8a#,8a,8f';
//const song5 = 'Bond:d=4,o=5,b=80:32p,16c#6,32d#6,32d#6,16d#6,8d#6,16c#6,16c#6,16c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16d#6,16d#6,16c#6,32d#6,32d#6,16d#6,8d#6,16c#6,16c#6,16c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16d6,16c#6,16c#7,c.7,16g#6,16f#6,g#.6';
//const song6 = 'MASH:d=8,o=5,b=140:4a,4g,f#,g,p,f#,p,g,p,f#,p,2e.,p,f#,e,4f#,e,f#,p,e,p,4d.,p,f#,4e,d,e,p,d,p,e,p,d,p,2c#.,p,d,c#,4d,c#,d,p,e,p,4f#,p,a,p,4b,a,b,p,a,p,b,p,2a.,4p,a,b,a,4b,a,b,p,2a.,a,4f#,a,b,p,d6,p,4e.6,d6,b,p,a,p,2b';
//const song7 = 'StarWars:d=4,o=5,b=45:32p,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#.6,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#6';
//const song8 = 'GoodBad:d=4,o=5,b=56:32p,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,d#,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,c#6,32a#,32d#6,32a#,32d#6,8a#.,16f#.,32f.,32d#.,c#,32a#,32d#6,32a#,32d#6,8a#.,16g#.,d#';
//const song9 = 'TopGun:d=4,o=4,b=31:32p,16c#,16g#,16g#,32f#,32f,32f#,32f,16d#,16d#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,16f,d#,16c#,16g#,16g#,32f#,32f,32f#,32f,16d#,16d#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,g#';
//const song10 = 'A-Team:d=8,o=5,b=125:4d#6,a#,2d#6,16p,g#,4a#,4d#.,p,16g,16a#,d#6,a#,f6,2d#6,16p,c#.6,16c6,16a#,g#.,2a#';
//const song11 = 'Flinstones:d=4,o=5,b=40:32p,16f6,16a#,16a#6,32g6,16f6,16a#.,16f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,d6,16f6,16a#.,16a#6,32g6,16f6,16a#.,32f6,32f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,a#,16a6,16d.6,16a#6,32a6,32a6,32g6,32f#6,32a6,8g6,16g6,16c.6,32a6' + ',32a6,32g6,32g6,32f6,32e6,32g6,8f6,16f6,16a#.,16a#6,32g6,16f6,16a#.,16f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c.6,32d6,32d#6,32f6,16a#,16c.6,32d6,32d#6,32f6,16a#6,16c7,8a#.6';
//const song12 = 'Jeopardy:d=4,o=6,b=125:c,f,c,f5,c,f,2c,c,f,c,f,a.,8g,8f,8e,8d,8c#,c,f,c,f5,c,f,2c,f.,8d,c,a#5,a5,g5,f5,p,d#,g#,d#,g#5,d#,g#,2d#,d#,g#,d#,g#,c.7,8a#,8g#,8g,8f,8e,d#,g#,d#,g#5,d#,g#,2d#,g#.,8f,d#,c#,c,p,a#5,p,g#.5,d#,g#';
//const song13 = 'MahnaMahna:d=16,o=6,b=125:c#,c.,b5,8a#.5,8f.,4g#,a#,g.,4d#,8p,c#,c.,b5,8a#.5,8f.,g#.,8a#.,4g,8p,c#,c.,b5,8a#.5,8f.,4g#,f,g.,8d#.,f,g.,8d#.,f,8g,8d#.,f,8g,d#,8c,a#5,8d#.,8d#.,4d#,8d#.';
//const song14 = 'MissionImp:d=16,o=6,b=95:32d,32d#,32d,32d#,32d,32d#,32d,32d#,32d,32d,32d#,32e,32f,32f#,32g,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,p,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,p,a#,g,2d,32p,a#,g,2c#,32p,a#,g,2c,a#5,8c,2p,32p,a#5,g5,2f#,32p,a#5,g5,2f,32p,a#5,g5,2e' + ',d#,8d';
//const song15 = 'KnightRider:d=4,o=5,b=125:16e,16p,16f,16e,16e,16p,16e,16e,16f,16e,16e,16e,16d#,16e,16e,16e,16e,16p,16f,16e,16e,16p,16f,16e,16f,16e,16e,16e,16d#,16e,16e,16e,16d,16p,16e,16d,16d,16p,16e,16d,16e,16d,16d,16d,16c,16d,16d,16d,16d,16p,16e,16d,16d,16p,16e,16d,16e' + ',16d,16d,16d,16c,16d,16d,16d';
//
//const songs : array[0..14] of String = (
//    song1, song2, song3, song4, song5, song6, song7, song8, song9, song10,
//    song11, song12, song13, song14, song15 );


procedure playMelody(p: PAnsiChar);

var   playTone: procedure(frequency: integer) of object;
      delay: function(duration_ms: integer): boolean of object; // return true to break;
      noTone: procedure of object;


implementation

function isdigit(c: AnsiChar): boolean;
begin
  result := (c >= '0') and (c <= '9')
end;

function getdigit(c: AnsiChar): byte;
begin
  result := Byte(c) - Byte('0')
end;


procedure playMelody(p: PAnsiChar);
var
  default_dur,
  default_oct : byte;
  bpm,
  num         : integer;
  wholenote,
  duration    : integer;
  note,
  scale       : byte;
  breakPlaying: boolean;
begin
  // Absolutely no error checking in here
  default_dur := 4;
  default_oct := 6;
  bpm := 63;
  // format: d=N,o=N,b=NNN:

  // find the start (skip name, etc)
  while p^ <> ':' do Inc(p) ;    // ignore name
  Inc(p);                     // skip ':'

  // get default duration
  if p^ = 'd' then
  begin
    Inc(p); Inc(p);              // skip 'd='
    num := 0;
    while isdigit( p^) do
    begin
      num := (num * 10) + getdigit(p^);
      Inc(p);
    end;
    if num > 0 then default_dur := num;
    Inc(p);                   // skip comma
  end;
//  Serial.print('ddur: '); Serial.println(default_dur, 10);

  // get default octave
  if p^ = 'o' then
  begin
    Inc(p); Inc(p);              // skip 'o='
    num := getdigit(p^);
    Inc(p);
    if (num >= 3)  and  (num <=7) then
      default_oct := num;
    Inc(p);                   // skip comma
  end;
//  Serial.print('doct: '); Serial.println(default_oct, 10);

  // get BPM
  if p^ = 'b' then
  begin
    Inc(p); Inc(p);              // skip 'b='
    num := 0;
    while isdigit( p^) do
    begin
      num := (num * 10) + getdigit(p^);
      Inc(p);
    end;
    bpm := num;
    Inc(p);                   // skip colon
  end;
//  Serial.print('bpm: '); Serial.println(bpm, 10);

  // BPM usually expresses the number of quarter notes per minute
  wholenote := Round(60 * 1000 / bpm) * 4;  // this is the time for whole note (in milliseconds)
//  Serial.print('wn: '); Serial.println(wholenote, 10);

  // now begin note loop
  while p^ <> #0 do
  begin
    // first, get note duration, if available
    num := 0;
    while isdigit(p^) do
    begin
      num := (num * 10) + getdigit(p^);
      Inc(p);
    end;
    if num <> 0 then
      duration := wholenote div num
    else
      duration := wholenote div default_dur;

    // now get the note
    note := 0;
    case p^ of
      'c':
        note := 1;
      'd':
        note := 3;
      'e':
        note := 5;
      'f':
        note := 6;
      'g':
        note := 8;
      'a':
        note := 10;
      'b':
        note := 12;
      'p':
      else
        note := 0;
    end;
    Inc(p);

    // now, get optional '#' sharp
    if p^ = '#' then
    begin
      Inc(note);
      Inc(p);
    end;

    // now, get optional '.' dotted note
    if p^ = '.' then
    begin
      duration  := duration + (duration div 2);
      Inc(p);
    end;

    // now, get scale
    if isdigit(p^) then
    begin
      scale := getdigit(p^);
      Inc(p);
    end
    else
    begin
      scale := default_oct;
    end;
    scale  := scale + OCTAVE_OFFSET;
    if p^ = ',' then Inc(p);       // skip comma for next note (or we may be at the end)

    // now play the note
    if note <> 0 then
    begin
//      Serial.print('Playing: ');
//      Serial.print(scale, 10); Serial.print(' ');
//      Serial.print(note, 10); Serial.print(' (');
//      Serial.print(notes[(scale - 4) * 12 + note], 10);
//      Serial.print(') ');
//      Serial.println(duration, 10);
      playTone( notes[(scale - 4) * 12 + note]);
      breakPlaying := delay(duration);
      noTone;
    end
    else
    begin
//      Serial.print('Pausing: ');
//      Serial.println(duration, 10);
      breakPlaying := delay(duration);
    end;

    if breakPlaying then break;
  end;
end;




end.

