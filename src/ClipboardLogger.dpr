program ClipboardLogger;

uses Windows,
  Forms,
  myform in 'myform.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
