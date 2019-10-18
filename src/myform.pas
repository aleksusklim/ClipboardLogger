unit myform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Inifiles, StdCtrls, Menus, OleCtrls, SHDocVw,
  Spin, Trayicon, myicons;

type
  TForm1 = class(TForm)
    mouse: TTimer;
    colortime: TTimer;
    check: TTimer;
    gui: TPanel;
    viewer: TPanel;
    splitter: TSplitter;
    menu: TPopupMenu;
    menu_show: TMenuItem;
    menu_exit: TMenuItem;
    menu_mode: TMenuItem;
    menu_paste: TMenuItem;
    menu_trim: TMenuItem;
    menu_sep: TMenuItem;
    list: TListBox;
    control: TPanel;
    display: TPanel;
    b_txt: TButton;
    b_htm: TButton;
    b_rtf: TButton;
    b_take: TButton;
    b_delete: TButton;
    e_txt: TMemo;
    menu_reset: TMenuItem;
    e_rtf: TRichEdit;
    p_htm: TPanel;
    e_htm: TWebBrowser;
    b_trim: TButton;
    save_file: TSaveDialog;
    stack: TListBox;
    splitstack: TSplitter;
    open_file: TOpenDialog;
    t_autosave: TTimer;
    p_settings: TPanel;
    p_helper: TPanel;
    l_maxhist: TLabel;
    l_maxline: TLabel;
    l_autosave: TLabel;
    e_maxhist: TSpinEdit;
    e_maxstr: TSpinEdit;
    r_all1: TRadioButton;
    r_all2: TRadioButton;
    r_all3: TRadioButton;
    e_autosave: TSpinEdit;
    c_itxt: TCheckBox;
    c_irtf: TCheckBox;
    c_ihtm: TCheckBox;
    c_saveexit: TCheckBox;
    b_all: TButton;
    b_paste: TButton;
    b_export: TButton;
    b_import: TButton;
    b_reset: TButton;
    b_redo: TButton;
    b_undo: TButton;
    b_quit: TButton;
    b_close: TButton;
    menu_undo: TMenuItem;
    menu_redo: TMenuItem;
    menu_delete: TMenuItem;
    menu_all: TMenuItem;
    menu_save: TMenuItem;
    b_help: TButton;
    b_toggle: TButton;
    menu_toggle: TMenuItem;
    b_min: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mouseTimer(Sender: TObject);
    procedure colortimeTimer(Sender: TObject);
    procedure checkTimer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure menu_exitClick(Sender: TObject);
    procedure menu_showClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure splitterMoved(Sender: TObject);
    procedure b_txtClick(Sender: TObject);
    procedure b_htmClick(Sender: TObject);
    procedure b_rtfClick(Sender: TObject);
    procedure b_takeClick(Sender: TObject);
    procedure b_resetClick(Sender: TObject);
    procedure menu_resetClick(Sender: TObject);
    procedure listClick(Sender: TObject);
    procedure b_deleteClick(Sender: TObject);
    procedure listMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure listDblClick(Sender: TObject);
    procedure b_trimClick(Sender: TObject);
    procedure b_quitClick(Sender: TObject);
    procedure listKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure b_exportClick(Sender: TObject);
    procedure b_pasteClick(Sender: TObject);
    procedure b_undoClick(Sender: TObject);
    procedure b_redoClick(Sender: TObject);
    procedure b_allClick(Sender: TObject);
    procedure b_importClick(Sender: TObject);
    procedure stackEnter(Sender: TObject);
    procedure listEnter(Sender: TObject);
    procedure setsave(Sender: TObject);
    procedure p_helperClick(Sender: TObject);
    procedure setkey(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure setclick(Sender: TObject);
    procedure t_autosaveTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure b_MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure b_closeClick(Sender: TObject);
    procedure menu_trimClick(Sender: TObject);
    procedure menu_pasteClick(Sender: TObject);
    procedure menu_allClick(Sender: TObject);
    procedure menu_saveClick(Sender: TObject);
    procedure menu_undoClick(Sender: TObject);
    procedure menu_redoClick(Sender: TObject);
    procedure menu_deleteClick(Sender: TObject);
    procedure b_helpClick(Sender: TObject);
    procedure b_toggleClick(Sender: TObject);
    procedure menu_toggleClick(Sender: TObject);
    procedure b_minClick(Sender: TObject);
    procedure menu_modeClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure MyOnMinimize(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses DateUtils;

{$R *.dfm}


var CRCTable:array [0..256] of CArdinal;
curdir:string;
shouldsave,firsthit,showtray:boolean;
var tic:TTrayIcon;

procedure makecrctable;
var i,c,k:Cardinal;
begin
i:=0;
repeat
c:=i;
k:=0;
repeat
if (c and 1)=1 then c:=(c shr 1) xor $EDB88320
else c:=c shr 1;
k:=k+1;
until (k>7);
CRCTable[i]:=c;
i:=i+1;
until (i>255);
end;

function getcrc(s:string):cardinal;
var i:Integer;
p:PChar;
begin
p:=PChar(s);
Result:=$FFFFFFFF;
for i:=0 to Length(s) do
Result:=CRCTable[(Result xor ord(p[i]))and 255]xor((Result shr 8)and $00FFFFFF);
Result:=(Result xor $FFFFFFFF);
end;

type entry=record
isText:Boolean;
isHTML:Boolean;
isRTF:Boolean;
srcText:PWChar;
srcHTML:PChar;
srcRTF:PChar;
plainText:WideString;
plainHTML:AnsiString;
lenText:integer;
lenHTML:integer;
lenRTF:integer;
caption:string;
hash:cardinal;
date:TDateTime;
end;

var
stacksize,arrsize,arrmax,memmax,alltype,autosave:integer;
entries,stacks:array of entry;
usestack:boolean;

procedure usestackset(v:boolean);
begin
usestack:=v;
if usestack then begin
Form1.stack.Font.Color:=clBlack;
Form1.stack.Font.Style:=[fsBold];
Form1.list.Font.Color:=clGray;
Form1.list.Font.Style:=[];
end else begin
Form1.stack.Font.Color:=clGray;
Form1.stack.Font.Style:=[];
Form1.list.Font.Color:=clBlack;
Form1.list.Font.Style:=[fsBold];
end;
end;

var HTMLFormat:integer;
RichTextFormat:integer;

const WSize=16;

procedure hideall;
begin
Form1.e_txt.Visible:=false;
Form1.p_htm.Visible:=false;
Form1.e_rtf.Visible:=false;
Form1.p_settings.Visible:=true;
end;

function clipboardAlloc(p:pointer;s:integer):integer;
begin
Result:=GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE,s+2);
CopyMemory(GlobalLock(Result),p,s);
GlobalUnlock(Result);
end;

function AllocWideString(s:PWideChar;var i:integer;nomax:boolean=false):PWideChar;
begin
Result:=nil;
i:=Length(s)+1;
if not nomax then if i>memmax*1024*1024 then begin i:=0;exit;end;
i:=i*SizeOf(WideChar);
GetMem(Result,i+2);
Result[0]:=chr(0);
if s<>nil then CopyMemory(Result,s,i);
end;

function AllocAnsiString(s:PAnsiChar;var i:integer;nomax:boolean=false):PAnsiChar;
begin
Result:=nil;
i:=StrLen(s)+1;
if not nomax then if i>memmax*1024*1024 then begin i:=0;exit;end;
GetMem(Result,i+1);
StrCopy(Result,s);
end;

function ensureOpenClipboard:Boolean;
var i:integer;
begin
Result:=true;
for i:=0 to 100 do if OpenClipboard(Form1.Handle) then exit else Sleep(50);
Result:=false;
ShowMessage('OpenClipboard error!');
end;

procedure freeEntry(var e:entry;new:boolean=false);
begin
if not new then begin
if e.isText then FreeMem(e.srcText);
if e.isHTML then FreeMem(e.srcHTML);
if e.isRTF then FreeMem(e.srcRTF);
end;
e.plainText:='';
e.plainHTML:='';
e.srcText:=nil;
e.srcHTML:=nil;
e.srcRTF:=nil;
e.lenText:=0;
e.lenHTML:=0;
e.lenRTF:=0;
e.isText:=false;
e.isHTML:=false;
e.isRTF:=false;
e.caption:='';
e.hash:=0;
e.date:=Now();
end;

function strprev(s:string):string;
const max=200;
begin
Result:=StringReplace(StringReplace(StringReplace(Copy(s,1,max),chr(10),' ',[rfReplaceAll]),chr(13),'',[rfReplaceAll]),chr(9),' ',[rfReplaceAll]);
if Length(s)>max then Result:=Result+'…';
end;

function getClipboardEntry():entry;
var h:integer;
begin
Result.isText:=false;
Result.isHTML:=false;
Result.isRTF:=false;
freeEntry(Result);
h:=GetClipboardData(HTMLFormat);
if h<>0 then begin
Result.srcHTML:=AllocAnsiString(Pchar(GlobalLock(h)),Result.lenHTML);
if Result.lenHTML>0 then Result.isHTML:=true;
GlobalUnlock(h);
end;
h:=GetClipboardData(RichTextFormat);
if h<>0 then begin
Result.srcRTF:=AllocAnsiString(Pchar(GlobalLock(h)),Result.lenRTF);
if Result.lenRTF>0 then Result.isRTF:=true;
GlobalUnlock(h);
end;
h:=GetClipboardData(CF_UNICODETEXT);
if h<>0 then begin
Result.srcText:=AllocWideString(PWideChar(GlobalLock(h)),Result.lenText);
if Result.lenText>0 then Result.isText:=true;
GlobalUnlock(h);
end;
CloseClipboard;
if Result.isHTML then begin
Result.plainHTML:=Result.srcHTML;
h:=Pos('<html',LowerCase(Result.plainHTML));
if h>0 then begin
Delete(Result.plainHTML,1,h+4);
h:=Pos('</html>',LowerCase(Result.plainHTML));
if h>0 then
SetLength(Result.plainHTML,h-1)
else Result.plainHTML:='';
end else Result.plainHTML:='';
end;
if Result.isText then Result.plainText:=Result.srcText;
if Result.isHTML and Result.isRTF then Result.caption:=Result.caption+'A'
else begin
if Result.isHTML then Result.caption:=Result.caption+'H';
if Result.isRTF then Result.caption:=Result.caption+'R';
end;
if Result.isText then begin
Result.caption:=Result.caption+':'+strprev(Result.plainText);
Result.hash:=getcrc(Result.plainText+Result.plainHTML+copy(string(Result.srcRTF),1,Length(Result.srcRTF)div 8));
end;
end;

procedure setClipboardEntry(e:entry);
begin
if not ensureOpenClipboard then exit;
EmptyClipboard;
if e.isHTML then SetClipboardData(HTMLFormat,clipboardAlloc(e.srcHTML,e.lenHTML));
if e.isRTF then SetClipboardData(RichTextFormat,clipboardAlloc(e.srcRTF,e.lenRTF));
if e.isText then SetClipboardData(CF_UNICODETEXT,clipboardAlloc(e.srcText,e.lenText));
CloseClipboard;
end;

procedure trimEntry(var e:entry);
var s:WideString;
len:integer;
pwc:PWideChar;
begin
s:=Trim(e.plainText);
pwc:=AllocWideString(PWideChar(s),e.lenText,true);
len:=e.lenText;
freeEntry(e);
e.isText:=true;
e.plainText:=s;
e.lenText:=len;
e.srcText:=pwc;
e.caption:=':'+strprev(e.plainText);
e.hash:=getcrc(e.plainText);
end;

function CRLF2BR(s:string):string;
begin
s:=StringReplace(s,chr(13)+chr(10),'<BR />',[rfReplaceAll]);
s:=StringReplace(s,chr(10),'<BR />',[rfReplaceAll]);
s:=StringReplace(s,chr(13),'<BR />',[rfReplaceAll]);
Result:=s;
end;

function leftpad(s:string;c:char;i:integer):string;
var n:integer;
begin
n:=Length(s);
if n>=i then Result:=s
else Result:=stringofchar(c,i-n)+s;
end;

function clipfromhtml(s:string):string;
const N=chr(13)+chr(10);
var i:integer;
begin
i:=length(s);
Result:='Version:0.9'+N;
Result:=Result+'StartHTML:'+leftpad(inttostr(105),'0',10)+N;
Result:=Result+'EndHTML:'+leftpad(inttostr(177+i),'0',10)+N;
Result:=Result+'StartFragment:'+leftpad(inttostr(141),'0',10)+N;
Result:=Result+'EndFragment:'+leftpad(inttostr(141+i),'0',10)+N;
Result:=Result+'<html>'+N;
Result:=Result+'<body>'+N;
Result:=Result+'<!--StartFragment-->'+s;
Result:=Result+'<!--EndFragment-->'+N;
Result:=Result+'</body>'+N;
Result:=Result+'</html>'+N;
end;

type streamdata=record
curr:PChar;
last:PChar;
end;
type pstreamdata=^streamdata;

type EDITSTREAM=record
dwCookie:pstreamdata;
dwError:integer;
pfnCallback:pointer;
end;

function min(a,b:pchar):Pchar;
begin
if a<b then Result:=a else Result:=b;
end;

function EditStreamCallback(
dwCookie:pstreamdata;
pbBuff:PChar;
cb:integer;
pcb:pinteger
):integer;stdcall;
var p:PChar;
i:integer;
begin
Result:=0;
p:=min(dwCookie.last,dwCookie.curr+cb);
i:=p-dwCookie.curr;
CopyMemory(pbBuff,dwCookie.curr,i);
dwCookie.curr:=dwCookie.curr+i;
pcb^:=i
end;

procedure sendRtf(c:TRichEdit;r:PChar;p:boolean);
var s:TMemoryStream;
v:string;
es:EDITSTREAM;
sd:streamdata;
m:integer;
begin
c.Clear;

m:=$4002;
if p then begin
v:=' ';
v:='{\rtf\deff0{\fonttbl{\f0 Arial Unicode MS;}}\fs24'+v+'?}';
s:=TMemoryStream.create();
s.WriteBuffer(Pchar(v)^,Length(v));
s.Position:=0;
c.Lines.LoadFromStream(s);
s.Free;
sd.last:=r+Length(Pwidechar(r))*2;
m:=$0011;
end else sd.last:=r+Length(r);
es.pfnCallback:=@EditStreamCallback;
es.dwCookie:=@sd;
sd.curr:=r;
SendMessage(c.Handle,WM_USER+73,m,Integer(@es));
end;

procedure sendHtm(c:TWebBrowser;r:string;p:boolean);
var s:TFileStream;
n:string;
begin
n:=curdir+'tmp.htm';
if p then r:='<!doctype html><html><head><meta charset="utf-8" /></head><body style="padding:1px;margin:1px;"><pre style="font:normal 12pt Arial;">'+r+'</pre></body></html>'
else r:='<!doctype html><html><head><meta charset="utf-8" /></head><body style="padding:1px;margin:1px;font:normal 12px Arial;"><html '+r+'</html></body></html>';
s:=TFileStream.Create(n,fmCreate);
s.WriteBuffer(PChar(r)^,Length(r));
s.Free;
c.Navigate(n);
end;

procedure sendTxt(c:TMemo;r:string);
begin
c.Clear;
c.Lines.Add(r);
end;

const
HOTX=1;
HOTC=2;
HOTV=3;
HOTZ=4;
HOTSZ=5;
HOTA=6;
HOTS=7;
HOTD=8;
HOTQ=9;

var ox,oy,mx,my,px,py,pw,ph:integer;
format1,format2:cardinal;
inifile:string;

procedure updatemouse;
var p:TPoint;
begin
GetCursorPos(p);
mx:=p.X;
my:=p.Y;
end;

var updatetime,deftime:Cardinal;
defcolor:TColor;
opened:boolean;

procedure loadicon(a:PByteArray;s:integer);
var m:TMemoryStream;
begin
m:=TMemoryStream.Create;
m.Write(a^,s);
m.Position:=0;
Application.Icon.LoadFromStream(m);
m.Position:=0;
tic.Icon.LoadFromStream(m);
tic.SetToolTip('ClipboardLogger');
m.Free;
end;

procedure setcolor(c:tcolor);
var s:string;
begin
case c of
clBlue:loadicon(@i_blue,sizeof(i_blue));
clLime:loadicon(@i_lime,sizeof(i_lime));
clYellow:loadicon(@i_yellow,sizeof(i_yellow));
clFuchsia:loadicon(@i_fuchsia,sizeof(i_fuchsia));
clRed:loadicon(@i_red,sizeof(i_red));
clBlack:loadicon(@i_black,sizeof(i_black));
clAqua:loadicon(@i_aqua,sizeof(i_aqua));
end;
Form1.splitter.Color:=c;
if not opened then begin
Form1.Color:=c;
Form1.Repaint;
end else begin
Form1.splitter.Repaint;
s:='...';
case c of
clBlue:s:='ClipboardLogger';
clLime:s:='OK!';
clYellow:s:='Same!';
clFuchsia:s:='None!';
clRed:s:='Error!';
end;
if (c=defcolor) and not Form1.check.Enabled then s:='[disabled] ClipboardLogger';
Application.Title:=s;
end;
end;

procedure TForm1.colortimeTimer(Sender: TObject);
begin
if Form1.splitter.Color=defcolor then exit;
if GetTickCount-updatetime>=deftime then begin
colortime.Enabled:=false;
setcolor(defcolor);
end
end;

procedure updatecolor(c:TColor);
begin
updatetime:=GetTickCount;
setcolor(c);
Form1.colortime.Enabled:=true;
end;

procedure formpos();
var ini:TIniFile;
begin
if opened and (Form1.WindowState=wsMaximized) then exit;
ini:=TIniFile.Create(inifile);
if opened then begin
ini.WriteInteger('Window','Full_X',Form1.Left);
ini.WriteInteger('Window','Full_Y',Form1.Top);
ini.WriteInteger('Window','Full_W',Form1.Width);
ini.WriteInteger('Window','Full_H',Form1.Height);
ini.WriteInteger('Window','List_S',Form1.list.Width);
ini.WriteInteger('Window','Save_S',Form1.stack.Width);
end else begin
ini.WriteInteger('Window','Pos_X',Form1.Left);
ini.WriteInteger('Window','Pos_Y',Form1.Top);
end;
ini.Free;
end;

procedure formhide();
var ini:TIniFile;
begin
tic.Active:=showtray;
usestackset(false);
opened:=false;
ini:=TIniFile.Create(inifile);
px:=ini.ReadInteger('Window','Pos_X',WSize);
py:=ini.ReadInteger('Window','Pos_Y',WSize);
ini.Free;
Form1.visible:=false;
SetWindowLong(Form1.Handle,GWL_STYLE,0);
SetWindowLong(Form1.Handle,GWL_EXSTYLE,WS_EX_TOPMOST);
SetWindowPos(Form1.Handle,HWND_TOPMOST,Form1.Left,Form1.Top,Form1.Width,Form1.Height,SWP_SHOWWINDOW);
Form1.gui.Visible:=false;
Form1.visible:=true;
Form1.Width:=WSize;
Form1.Height:=WSize;
Form1.Left:=px;
Form1.Top:=py;
ShowWindow(Form1.Handle,SW_SHOW);
ShowWindow(Application.Handle,SW_HIDE);
Application.Title:='ClipboardLogger';
UpdateWindow(Form1.Handle);
Form1.Repaint;
Form1.Visible:=false;
Form1.Visible:=true;
setcolor(defcolor);
hideall;
Form1.Caption:='ClipboardLogger';
if showtray then Form1.visible:=false;
end;

procedure set_validate();
begin
if arrmax<1 then begin arrmax:=1;
Form1.e_maxhist.Value:=arrmax;
end;
if memmax<1 then begin memmax:=1;
Form1.e_maxstr.Value:=memmax;
end;
if autosave<0 then begin autosave:=0;
Form1.e_autosave.Value:=autosave;
end;
if autosave=0 then Form1.t_autosave.Enabled:=false
else begin
Form1.t_autosave.Enabled:=true;
Form1.t_autosave.Interval:=autosave*60000;
end;
end;

var ignoreclick:boolean;
procedure set_save();
var ini:TIniFile;
begin
if ignoreclick then exit;
arrmax:=Form1.e_maxhist.Value;
memmax:=Form1.e_maxstr.Value;
autosave:=Form1.e_autosave.Value;
set_validate();
if Form1.r_all2.Checked then alltype:=2
else if Form1.r_all3.Checked then alltype:=3
else begin alltype:=1;Form1.r_all1.Checked:=true;end;
ini:=TIniFile.Create(inifile);
ini.WriteInteger('Settings','Max_Hist',arrmax);
ini.WriteInteger('Settings','Max_Str',memmax);
ini.WriteInteger('Settings','All_Type',alltype);
ini.WriteInteger('Settings','Autosave',autosave);
ini.WriteBool('Settings','Save_exit',Form1.c_saveexit.Checked);
ini.Free;
end;

procedure set_read();
var ini:TIniFile;
begin
ignoreclick:=true;
ini:=TIniFile.Create(inifile);
arrmax:=ini.ReadInteger('Settings','Max_Hist',2048);
memmax:=ini.ReadInteger('Settings','Max_Str',16);
alltype:=ini.ReadInteger('Settings','All_Type',2);
autosave:=ini.ReadInteger('Settings','Autosave',0);
Form1.c_saveexit.Checked:=ini.ReadBool('Settings','Save_exit',true);
ini.Free;
Form1.e_maxhist.Value:=arrmax;
Form1.e_maxstr.Value:=memmax;
Form1.e_autosave.Value:=autosave;
if alltype=2 then Form1.r_all2.Checked:=true
else if alltype=3 then Form1.r_all3.Checked:=true
else begin alltype:=1;Form1.r_all1.Checked:=true;end;
set_validate();
ignoreclick:=false;
end;

function i2s1(i:integer):string;
begin
Result:=inttostr(i);
end;

function i2s2(i:integer):string;
begin
if i<10 then Result:='0'+inttostr(i)
else Result:=inttostr(i);
end;

function printtime(t:tdatetime):string;
var y,n,d,h,m,s,u:word;
begin
DecodeDateTime(t,y,n,d,h,m,s,u);
Result:=i2s1(h)+':'+i2s2(m)+':'+i2s2(s)+', '+i2s1(d)+'/'+i2s2(n)+'/'+i2s1(y);
end;

procedure showtime(t:tdatetime=0);
const c=' • ClipboardLogger v1.2';
begin
if not opened then exit;
if t<>0
then Form1.Caption:=printtime(t)+c
else Form1.Caption:=c;
end;

procedure formshow();
var ini:TIniFile;
begin
tic.Active:=false;
usestackset(false);
opened:=true;
ini:=TIniFile.Create(inifile);
px:=ini.ReadInteger('Window','Full_X',0);
py:=ini.ReadInteger('Window','Full_Y',0);
pw:=ini.ReadInteger('Window','Full_W',640);
ph:=ini.ReadInteger('Window','Full_H',480);
Form1.list.Width:=ini.ReadInteger('Window','List_S',180);
Form1.stack.Width:=ini.ReadInteger('Window','Save_S',10);
if Form1.list.Width<32 then Form1.list.Width:=32;
if Form1.list.Width>pw-32 then Form1.list.Width:=pw-32;
ini.Free;
Form1.Color:=clBtnFace;
Form1.visible:=false;
SetWindowLong(Form1.Handle,GWL_STYLE,WS_OVERLAPPEDWINDOW);
SetWindowLong(Form1.Handle,GWL_EXSTYLE,0);
ShowWindow(Application.Handle,SW_SHOW);
Form1.gui.Visible:=true;
Form1.Left:=px;
Form1.Top:=py;
Form1.Width:=pw;
Form1.Height:=ph;
SetWindowPos(Form1.Handle,HWND_NOTOPMOST,Form1.Left,Form1.Top,Form1.Width,Form1.Height,SWP_SHOWWINDOW);
Form1.Repaint;
UpdateWindow(Form1.Handle);
Form1.Visible:=true;
Form1.Color:=clBtnFace;
Application.OnMinimize:=Form1.MyOnMinimize;
Form1.list.SetFocus;
showtime();
end;

procedure TForm1.FormCreate(Sender: TObject);
var s:string;
begin
showtray:=false;
tic:=TTrayIcon.create(nil);
tic.Active:=false;
tic.PopupMenu:=menu;
//tic.ShowDesigning:=true;
tic.OnDblClick:=FormClick;
firsthit:=false;
shouldsave:=false;
ignoreclick:=false;
curdir:=GetCurrentDir+'\';
inifile:=curdir+'ClipboardLogger.ini';
HTMLFormat:=RegisterClipboardFormatA(Pchar('HTML Format'));
RichTextFormat:=RegisterClipboardFormatA(Pchar('Rich Text Format'));
format1:=RegisterClipboardFormat(Pchar('ClipboardLoggerDummy1'));
format2:=RegisterClipboardFormat(Pchar('ClipboardLoggerDummy2'));
defcolor:=clBlue;
deftime:=800;
set_read();
formhide();
s:='';
if not RegisterHotKey(Form1.Handle,HOTX,MOD_WIN or MOD_CONTROL,ord('X')) then s:=s+'WIN+CTRL+X'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTC,MOD_WIN or MOD_CONTROL,ord('C')) then s:=s+'WIN+CTRL+C'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTV,MOD_WIN or MOD_CONTROL,ord('V')) then s:=s+'WIN+CTRL+V'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTZ,MOD_WIN or MOD_CONTROL,ord('Z')) then s:=s+'WIN+CTRL+Z'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTSZ,MOD_WIN or MOD_CONTROL or MOD_SHIFT,ord('Z')) then s:=s+'WIN+CTRL+SHIFT+Z'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTA,MOD_WIN or MOD_CONTROL,ord('A')) then s:=s+'WIN+CTRL+A'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTS,MOD_WIN or MOD_CONTROL,ord('S')) then s:=s+'WIN+CTRL+S'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTD,MOD_WIN or MOD_CONTROL,ord('D')) then s:=s+'WIN+CTRL+D'+chr(13)+chr(10);
if not RegisterHotKey(Form1.Handle,HOTQ,MOD_WIN or MOD_CONTROL,ord('Q')) then s:=s+'WIN+CTRL+Q'+chr(13)+chr(10);
if s<>'' then ShowMessage('Can`t register:'+chr(13)+chr(10)+chr(13)+chr(10)+s);
list.Clear;
stack.Clear;
makecrctable;
hideall;
stacksize:=0;
arrsize:=0;
formshow();
end;

function Max(a,b:integer):integer;
begin
if a>b then Result:=a else Result:=b;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if opened then exit;
if Button=mbRight then begin
menu.Popup(Max(0,Form1.Left),Max(0,Form1.Top));
exit;
end;
if Button=mbLeft then begin
mouse.Enabled:=true;
updatemouse;
ox:=Form1.Left-mx;
oy:=Form1.Top-my;
end;
end;

function mini(a,b:integer):integer;
begin
if a<b then Result:=a else Result:=b;
end;

function handleClip():integer;
var e:entry;
i:integer;
b:boolean;
const max=256;
begin
Result:=0;
e:=getClipboardEntry;
if not(e.isText or e.isHTML or e.isRTF) then exit;
b:=false;
for i:=arrsize-1 downto 0 do begin
if e.hash=entries[i].hash then begin
Form1.list.Selected[i]:=true;
Form1.listClick(Form1.list);
b:=true;break;
end;end;
if b then begin
Result:=2;
freeEntry(e);
exit;
end;
if Length(entries)<=arrsize then SetLength(entries,mini(arrmax+1,(arrsize+1)*2));
entries[arrsize]:=e;
Inc(arrsize);
Form1.list.Items.Add(e.caption);
while arrsize>arrmax do begin
freeEntry(entries[0]);
Form1.list.Items.Delete(0);
Dec(arrsize);
for i:=0 to arrsize-1 do entries[i]:=entries[i+1];
end;
Form1.list.Refresh;
Result:=1;
Form1.list.Selected[Form1.list.Count-1]:=true;
Form1.listClick(Form1.list);
if firsthit then begin
shouldsave:=true;
Form1.l_autosave.Enabled:=true;
end;
end;

procedure TForm1.mouseTimer(Sender: TObject);
begin
if GetAsyncKeyState(1)=0 then begin
mouse.Enabled:=false;
formpos();
exit;
end;
updatemouse;
Form1.Left:=ox+mx;
Form1.Top:=oy+my;
end;

procedure TForm1.checkTimer(Sender: TObject);
var c:integer;
begin
c:=-1;
if not OpenClipboard(0) then begin
updatecolor(clRed);
exit;
end;
if (EnumClipboardFormats(format1)<>format2)or(EnumClipboardFormats(format2)<>0) then begin
SetClipboardData(format1,0);
SetClipboardData(format2,0);
setcolor(clBlack);
case handleClip of
0:c:=clFuchsia;
1:c:=clLime;
2:c:=clYellow;
end;
end else CloseClipboard;
if c<>-1 then updatecolor(c);
firsthit:=true;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
if not opened then begin
formpos();
formshow();
end else if Sender<>Form1 then begin
formpos();
formhide();
end;
end;

procedure TForm1.WMSysCommand(var Msg: TWMSysCommand);
begin
if not opened then begin
DefaultHandler(Msg);
if Msg.CmdType=61696 then menu.Popup(Max(0,Form1.Left),Max(0,Form1.Top));
exit;
end;
if(Msg.CmdType=SC_MINIMIZE)or(Msg.CmdType=SC_CLOSE)
then begin
showtray:=(Msg.CmdType=SC_MINIMIZE);
formpos();
formhide();
end else DefaultHandler(Msg);
end;

procedure TForm1.menu_exitClick(Sender: TObject);
begin
formpos;
opened:=false;
Form1.Close;
end;

procedure TForm1.menu_showClick(Sender: TObject);
begin
if not opened then begin
formpos();
formshow();
end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if opened then exit;
if ord(key)=$5D then menu.Popup(Form1.Left,Form1.Top);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if opened then begin
showtray:=false;
formpos();
formhide();
CanClose:=false;
end
end;

procedure TForm1.MyOnMinimize(Sender: TObject);
begin
if opened then begin
showtray:=true;
formpos();
Application.Restore;
formhide();
end;
end;

procedure TForm1.splitterMoved(Sender: TObject);
begin
if list.Width<16 then list.Width:=16;
if Form1.list.Width>Form1.Width-32 then Form1.list.Width:=Form1.Width-32;
end;

procedure TForm1.b_txtClick(Sender: TObject);
begin
e_txt.Visible:=true;
e_rtf.Visible:=false;
p_htm.Visible:=false;
p_settings.Visible:=false;
if usestack then listClick(stack) else listClick(list);
end;

procedure TForm1.b_htmClick(Sender: TObject);
begin
e_txt.Visible:=false;
e_rtf.Visible:=false;
p_htm.Visible:=true;
p_settings.Visible:=false;
if usestack then listClick(stack) else listClick(list);
end;

procedure TForm1.b_rtfClick(Sender: TObject);
begin
e_txt.Visible:=false;
e_rtf.Visible:=true;
p_htm.Visible:=false;
p_settings.Visible:=false;
if usestack then listClick(stack) else listClick(list);
end;

procedure TForm1.b_takeClick(Sender: TObject);
begin
if usestack then begin
if (stack.ItemIndex<0)or(stack.ItemIndex>=stacksize) then begin
hideall;
exit;
end;
setcolor(clAqua);
setClipboardEntry(stacks[stack.ItemIndex]);
setcolor(defcolor);
end else begin
if (list.ItemIndex<0)or(list.ItemIndex>=arrsize) then begin
hideall;
exit;
end;
setcolor(clAqua);
setClipboardEntry(entries[list.ItemIndex]);
updatecolor(clAqua);
end;
end;

procedure TForm1.b_resetClick(Sender: TObject);
var ini:TIniFile;
begin
ini:=TIniFile.Create(inifile);
ini.WriteInteger('Window','Full_X',0);
ini.WriteInteger('Window','Full_Y',0);
ini.WriteInteger('Window','Full_W',640);
ini.WriteInteger('Window','Full_H',480);
ini.WriteInteger('Window','List_S',256);
ini.WriteInteger('Window','Save_S',64);
ini.WriteInteger('Window','Pos_X',WSize);
ini.WriteInteger('Window','Pos_Y',WSize);
ini.Free;
if opened then begin
Form1.Left:=0;
Form1.Top:=0;
Form1.Width:=640;
Form1.Height:=480;
end else begin
Form1.Left:=WSize;
Form1.Top:=WSize;
Form1.Width:=WSize;
Form1.Height:=WSize;
end;
formhide;
formshow;
end;

procedure TForm1.menu_resetClick(Sender: TObject);
begin
b_reset.Click;
end;

function htmlfragment(s:string):string;
var h:integer;
begin
Result:=s;
h:=Pos('<!--StartFragment-->',s);
if h>0 then begin
Delete(s,1,h+19);
h:=Pos('<!--EndFragment-->',s);
if h>0 then begin
SetLength(s,h-1);
Result:=s;
end;end;
end;

function htmlescape(s:string):string;
begin
Result:=StringReplace(StringReplace(StringReplace(s,'&','&amp;',[rfReplaceAll]),'<','&lt;',[rfReplaceAll]),'>','&gt;',[rfReplaceAll]);
end;

procedure TForm1.listClick(Sender: TObject);
var e:entry;
begin
showtime();
if Sender=list then begin
if list.ItemIndex<0 then exit;
if list.ItemIndex>=arrsize then exit;
e:=entries[list.ItemIndex];
usestackset(false);
end else begin
if stack.ItemIndex<0 then exit;
if stack.ItemIndex>=stacksize then exit;
e:=stacks[stack.ItemIndex];
usestackset(true);
end;
setcolor(clAqua);
if e_txt.Visible then begin
if e.isText and not c_itxt.Checked then sendTxt(e_txt,e.plainText)
else if e.isHTML and not c_ihtm.Checked then sendTxt(e_txt,htmlfragment(e.plainHTML))
else if e.isRTF and not c_irtf.Checked then sendTxt(e_txt,string(e.srcRTF));
end;
if e_rtf.Visible then begin
if e.isRTF and not c_irtf.Checked then sendRtf(e_rtf,e.srcRTF,false)
else if e.isText and not c_itxt.Checked then sendRtf(e_rtf,PChar(Pwidechar(e.plainText)),true)
else if e.isHTML and not c_ihtm.Checked then sendRtf(e_rtf,PChar(Pwidechar(UTF8Decode('<html '+e.plainHTML))),true);
end;
if p_htm.Visible then begin
if e.isHTML and not c_ihtm.Checked then sendHtm(e_htm,e.plainHTML,false)
else if e.isText and not c_itxt.Checked then sendHtm(e_htm,htmlescape(UTF8Encode(e.plainText)),true)
else if e.isRTF and not c_irtf.Checked then sendHtm(e_htm,string(e.srcRTF),true);
end;
showtime(e.date);
setcolor(defcolor);
end;

procedure TForm1.b_deleteClick(Sender: TObject);
var i,j:integer;
begin
if usestack then begin
i:=stack.ItemIndex;
if(i<0)or(i>=stacksize)then begin updatecolor(clRed);exit;end;
updatecolor(clAqua);
freeEntry(stacks[i]);
for j:=i+1 to stacksize-1 do stacks[j-1]:=stacks[j];
Dec(stacksize);
stack.Items.Delete(i);
if i>=stack.Items.Count-1 then i:=stack.Items.Count-1;
if stack.Items.Count>0 then stack.Selected[i]:=true;
Form1.listClick(stack);
end else begin
i:=list.ItemIndex;
if(i<0)or(i>=arrsize)then begin updatecolor(clRed);exit;end;
updatecolor(clAqua);
freeEntry(entries[i]);
for j:=i+1 to arrsize-1 do entries[j-1]:=entries[j];
Dec(arrsize);
list.Items.Delete(i);
if i>=list.Items.Count-1 then i:=list.Items.Count-1;
if list.Items.Count>0 then list.Selected[i]:=true;
Form1.listClick(list);
end;
end;

procedure TForm1.listMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Button=mbRight then begin
if (list.ItemIndex<0)or(list.ItemIndex>=arrsize) then begin
hideall();
exit;
end;
list.Selected[list.ItemIndex]:=false;
showtime();
end;
end;

procedure TForm1.listDblClick(Sender: TObject);
begin
b_take.Click;
end;

procedure TForm1.b_trimClick(Sender: TObject);
var e:entry;
begin
usestackset(false);
setcolor(clAqua);
if ensureOpenClipboard then begin
e:=getClipboardEntry;
trimEntry(e);
setClipboardEntry(e);
end;
setcolor(defcolor);
end;

procedure TForm1.b_quitClick(Sender: TObject);
begin
formpos;
opened:=false;
Form1.Close;
end;

procedure TForm1.listKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i:integer;
begin
if key=VK_ESCAPE then begin formpos;formhide;end;
if key=VK_DELETE then b_delete.Click;
if key=VK_BACK then begin
if usestack then begin
i:=Form1.stack.ItemIndex;
b_delete.Click;
if (i>0)and(i<>Form1.stack.Count) then Form1.stack.Selected[Form1.stack.ItemIndex-1]:=true;
Form1.listClick(stack);
end else begin
i:=Form1.list.ItemIndex;
b_delete.Click;
if (i>0)and(i<>Form1.list.Count) then Form1.list.Selected[Form1.list.ItemIndex-1]:=true;
Form1.listClick(list);
end;
end;
if key=VK_RETURN then b_take.Click;
if key=VK_INSERT then begin
if usestack then begin
b_paste.Click;
end else begin
b_take.Click;
b_trim.Click;
end;
end;
if key=VK_LEFT then begin hideall;key:=0;end;
if key=VK_RIGHT then begin
if e_txt.Visible then b_rtf.Click
else if e_rtf.Visible then b_htm.Click
else b_txt.Click;
key:=0;
end;
end;

procedure saveone(s:TFileStream;e:entry);
var j:integer;
begin
j:=length(e.caption)+1;
s.WriteBuffer(j,4);
s.WriteBuffer(PChar(e.caption)^,j);
s.WriteBuffer(e.hash,4);
s.WriteBuffer(e.date,8);
j:=-1;
if e.isText then begin
j:=length(e.srcText)*2+2;
s.WriteBuffer(j,4);
s.WriteBuffer(PWidechar(e.srcText)^,j);
j:=length(e.plainText)*2+2;
s.WriteBuffer(j,4);
s.WriteBuffer(PWidechar(e.plainText)^,j);
end else s.WriteBuffer(j,4);
j:=-1;
if e.isRTF then begin
j:=length(e.srcRTF)+1;
s.WriteBuffer(j,4);
s.WriteBuffer(PChar(e.srcRTF)^,j);
end else s.WriteBuffer(j,4);
j:=-1;
if e.isHTML then begin
j:=length(e.srcHTML)+1;
s.WriteBuffer(j,4);
s.WriteBuffer(PChar(e.srcHTML)^,j);
j:=length(e.plainHTML)+1;
s.WriteBuffer(j,4);
s.WriteBuffer(PChar(e.plainHTML)^,j);
end else s.WriteBuffer(j,4);
end;

procedure loadone(s:TFileStream;var e:entry);
var j:integer;
b:string;
w:widestring;
begin
freeEntry(e,true);
s.ReadBuffer(j,4);
SetLength(e.caption,j);UniqueString(e.caption);
s.ReadBuffer(PChar(e.caption)^,j);SetLength(e.caption,j-1);
s.ReadBuffer(e.hash,4);
s.ReadBuffer(e.date,8);
s.ReadBuffer(j,4);
if j<>-1 then begin
e.isText:=true;
SetLength(w,(j div 2));UniqueString(w);
s.ReadBuffer(PWidechar(w)^,j);
e.srcText:=AllocWideString(PWidechar(w),e.lenText,true);
s.ReadBuffer(j,4);
SetLength(e.plainText,(j div 2));UniqueString(e.plainText);
s.ReadBuffer(PWidechar(e.plainText)^,j);SetLength(e.plainText,(j div 2)-1);
end;
s.ReadBuffer(j,4);
if j<>-1 then begin
e.isRTF:=true;
SetLength(b,j);UniqueString(b);
s.ReadBuffer(PChar(b)^,j);
e.srcRTF:=AllocAnsiString(Pchar(b),e.lenRTF,true);
end;
s.ReadBuffer(j,4);
if j<>-1 then begin
e.isHTML:=true;
SetLength(b,j);UniqueString(b);
s.ReadBuffer(PChar(b)^,j);
e.srcHTML:=AllocAnsiString(Pchar(b),e.lenHTML,true);
s.ReadBuffer(j,4);
SetLength(e.plainHTML,j);UniqueString(e.plainHTML);
s.ReadBuffer(PChar(e.plainHTML)^,j);SetLength(e.plainHTML,j-1);
end;
end;

procedure saveall(s:TFileStream);
var i:integer;
const cl='.ClipboardLogger';
begin
s.WriteBuffer(Pchar(cl)^,length(cl));
i:=0;
s.WriteBuffer(i,1);
s.WriteBuffer(arrsize,4);
for i:=0 to arrsize-1 do saveone(s,entries[i]);
s.WriteBuffer(stacksize,4);
for i:=0 to stacksize-1 do saveone(s,stacks[i]);
end;

procedure loadall(s:TFileStream);
var i:integer;
e:entry;
b:string;
const cl='.ClipboardLogger';
begin
Form1.stack.Clear;
Form1.list.Clear;
for i:=0 to arrsize-1 do freeEntry(entries[i]);
for i:=0 to stacksize-1 do freeEntry(stacks[i]);
stacksize:=0;
arrsize:=0;
SetLength(b,length(cl));UniqueString(b);
s.ReadBuffer(Pchar(b)^,length(cl));
if b<>cl then Abort;
i:=255;
s.ReadBuffer(i,1);
if i<>0 then Abort;
s.ReadBuffer(arrsize,4);
SetLength(entries,arrsize);
for i:=0 to arrsize-1 do begin
loadone(s,e);
entries[i]:=e;
Form1.list.Items.Add(e.caption);
end;
s.ReadBuffer(stacksize,4);
SetLength(stacks,stacksize);
for i:=0 to stacksize-1 do begin
loadone(s,e);
stacks[i]:=e;
Form1.stack.Items.Add(e.caption);
end;;
end;

function savetofile(n:string):boolean;
var stream:TFileStream;
m:string;
begin
m:=n+'.old';
if FileExists(m) then DeleteFile(m);
if FileExists(n) then MoveFile(Pchar(n),Pchar(m));
updatecolor(clAqua);
Result:=false;
stream:=nil;
try try
stream:=TFileStream.Create(n,fmCreate);
saveall(stream);
finally stream.Free;end;
except exit;end;
Result:=true;
end;

procedure TForm1.b_exportClick(Sender: TObject);
const cl='.ClipboardLogger';
begin
usestackset(false);
save_file.Filter:='ClipboardLogger files|*'+cl;
save_file.InitialDir:=curdir;
save_file.DefaultExt:=cl;
if save_file.Execute then begin
if not savetofile(save_file.FileName) then ShowMessage('Export error!');
end;
end;

procedure TForm1.b_pasteClick(Sender: TObject);
var e:entry;
begin
usestackset(false);
setcolor(clAqua);
if not ensureOpenClipboard then begin
updatecolor(clRed);
exit;
end;
e:=getClipboardEntry;
if not e.isText then begin
updatecolor(clFuchsia);
freeEntry(e);
exit;
end;
if e.isRTF then begin
FreeMem(e.srcRTF);
e.isRTF:=false;
end;
if not e.isHTML then begin
trimEntry(e);
e.isHTML:=true;
e.plainHTML:=UTF8Encode(e.plainText);
e.srcHTML:=AllocAnsiString(Pchar(clipfromhtml(e.plainHTML)),e.lenHTML,true);
e.plainHTML:='>'+e.plainHTML;
e.hash:=not e.hash;
end;
if stacksize>0 then if e.hash=stacks[stacksize-1].hash then begin
updatecolor(clYellow);
freeEntry(e);
exit;
end;
if Length(stacks)<=stacksize then SetLength(stacks,stacksize*2+1);
e.caption:='• '+strprev(e.plainText);
stacks[stacksize]:=e;
Inc(stacksize);
stack.Items.Add(e.caption);
updatecolor(clLime);
end;

procedure TForm1.b_undoClick(Sender: TObject);
begin
usestackset(false);
if (list.ItemIndex=0)or(arrsize=0) then begin updatecolor(clRed);exit;end;
if (list.ItemIndex>=arrsize)or(list.ItemIndex<0)
then list.Selected[arrsize-1]:=true
else list.Selected[list.ItemIndex-1]:=true;
listClick(list);
b_take.Click;
end;

procedure TForm1.b_redoClick(Sender: TObject);
begin
usestackset(false);
if (list.ItemIndex=arrsize-1)or(arrsize=0) then begin updatecolor(clRed);exit;end;
if (list.ItemIndex>=arrsize)or(list.ItemIndex<0)
then list.Selected[arrsize-1]:=true
else list.Selected[list.ItemIndex+1]:=true;
listClick(list);
b_take.Click;
end;

procedure TForm1.b_allClick(Sender: TObject);
var i:integer;
txt:widestring;
htm:string;
e:entry;
begin
usestackset(false);
setcolor(clAqua);
txt:='';
htm:='';
for i:=0 to stacksize-1 do begin
if alltype=2 then begin
txt:=txt+stacks[i].plainText+widestring(chr(13)+chr(10));
htm:=htm+htmlfragment(stacks[i].plainHTML)+'<BR />';
end else if alltype=3 then begin
txt:=txt+widestring('• ')+widestring(printtime(stacks[i].date))+widestring(chr(13)+chr(10))+stacks[i].plainText+widestring(chr(13)+chr(10));
htm:=htm+'&bull; <U><I>'+printtime(stacks[i].date)+'</I></U><BR />'+htmlfragment(stacks[i].plainHTML)+'<BR />';
end else begin
txt:=txt+stacks[i].plainText;
htm:=htm+htmlfragment(stacks[i].plainHTML);
end;
end;
freeEntry(e,true);
e.isHTML:=true;
e.isText:=true;
e.srcHTML:=AllocAnsiString(PChar(clipfromhtml(htm)),e.lenHTML,true);
e.srcText:=AllocWideString(PWideChar(txt),e.lenText,true);
e.plainHTML:=htm;
e.plainText:=txt;
setClipboardEntry(e);
updatecolor(clLime);
end;

procedure TForm1.b_importClick(Sender: TObject);
var stream:TFileStream;
const cl='.ClipboardLogger';
begin
usestackset(false);
open_file.Filter:='ClipboardLogger files|*.old;*'+cl;
open_file.InitialDir:=curdir;
open_file.DefaultExt:=cl;
if open_file.Execute then begin
stream:=nil;
try try
stream:=TFileStream.Create(open_file.FileName,fmOpenRead or fmShareDenyNone);
loadall(stream);
finally stream.Free;end;
except ShowMessage('Import error!');end;
end;
end;


procedure TForm1.WMHotkey(var Msg: TWMHotKey);
begin
usestackset(false);
if Msg.HotKey=HOTZ then begin
Form1.b_undo.Click;
end;
if Msg.HotKey=HOTSZ then begin
Form1.b_redo.Click;
end;
if Msg.HotKey=HOTX then begin
if opened then begin
formpos();
formhide();
end else formshow();
end;
if Msg.HotKey=HOTC then begin
Form1.b_trim.Click;
end;
if Msg.HotKey=HOTV then begin
Form1.b_paste.Click;
end;
if Msg.HotKey=HOTA then begin
Form1.b_all.Click;
end;
if Msg.HotKey=HOTS then begin
menu_saveClick(menu_save);
end;
if Msg.HotKey=HOTD then begin
b_delete.Click;
b_take.Click;
end;
if Msg.HotKey=HOTQ then begin
b_toggle.Click;
end;
DefaultHandler(Msg);
end;

procedure TForm1.stackEnter(Sender: TObject);
begin
usestackset(true);
end;

procedure TForm1.listEnter(Sender: TObject);
begin
usestackset(false);
end;

procedure TForm1.setsave(Sender: TObject);
begin
set_save();
end;

procedure TForm1.p_helperClick(Sender: TObject);
begin
Form1.list.SetFocus;
end;

procedure TForm1.setkey(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key=VK_RETURN then begin
Form1.list.SetFocus;
end;
end;

procedure TForm1.setclick(Sender: TObject);
begin
set_save();
end;

procedure TForm1.t_autosaveTimer(Sender: TObject);
begin
if shouldsave then if not savetofile('AUTOSAVE.ClipboardLogger') then ShowMessage('Autosave error!');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
tic.Active:=false;
set_save();
if shouldsave then if c_saveexit.Checked then if not savetofile('LASTCLOSE.ClipboardLogger') then ShowMessage('Save on exit error!');
DeleteFile(curdir+'tmp.htm');
tic.Free;
end;

procedure TForm1.b_MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if button=mbright then begin
hideall();
end;
end;

procedure TForm1.b_closeClick(Sender: TObject);
begin
showtray:=false;
formpos();
formhide();
end;

procedure TForm1.menu_trimClick(Sender: TObject);
begin
b_trim.Click;
end;

procedure TForm1.menu_pasteClick(Sender: TObject);
begin
b_paste.Click;
end;

procedure TForm1.menu_allClick(Sender: TObject);
begin
b_all.Click;
end;

procedure TForm1.menu_saveClick(Sender: TObject);
begin
if not savetofile('MANUAL.ClipboardLogger') then ShowMessage('Manual save error!');
end;

procedure TForm1.menu_undoClick(Sender: TObject);
begin
b_undo.Click;
end;

procedure TForm1.menu_redoClick(Sender: TObject);
begin
b_redo.Click;
end;

procedure TForm1.menu_deleteClick(Sender: TObject);
begin
b_delete.Click;
b_take.Click;
end;

procedure TForm1.b_helpClick(Sender: TObject);
begin
ShowMessage(string(PChar(@t_help)));
end;

procedure TForm1.b_toggleClick(Sender: TObject);
begin
if check.Enabled then begin
check.Enabled:=false;
b_toggle.Caption:='ENABLE';
b_toggle.Font.Style:=[fsBold];
defcolor:=clBlack;
menu_sep.Caption:='--- Logging DISABLED ---';
end else begin
check.Enabled:=true;
b_toggle.Caption:='DISABLE';
b_toggle.Font.Style:=[];
defcolor:=clBlue;
menu_sep.Caption:='--- Logging enabled ---';
end;
setcolor(defcolor);
end;

procedure TForm1.menu_toggleClick(Sender: TObject);
begin
b_toggle.Click;
end;

procedure TForm1.b_minClick(Sender: TObject);
begin
showtray:=true;
formpos();
formhide();
end;

procedure TForm1.menu_modeClick(Sender: TObject);
begin
if opened then exit;
formshow;
showtray:=not showtray;
formhide;
end;

end.

