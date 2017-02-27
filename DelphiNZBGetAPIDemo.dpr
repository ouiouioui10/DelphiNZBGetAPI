Program DelphiNZBGetAPIDemo;

uses
  Forms,
  Main in 'Main.pas' {fmMain},
  uNZBGetAPI in 'uNZBGetAPI.pas',
  DemoMain in 'DemoMain.pas' {fmDemoMain},
  Settings in 'Settings.pas' {fmSettings};

{$R *.res}


Begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown   := True;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmDemoMain, fmDemoMain);
  Application.CreateForm(TfmSettings, fmSettings);
  Application.Run;

End.
