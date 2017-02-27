Unit DemoMain;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Main, cxPCdxBarPopupMenu, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, DB, cxDBData, cxLabel, cxProgressBar,
  cxTimeEdit, ComCtrls, Menus, cxContainer, IdBaseComponent, IdAntiFreezeBase,
  IdAntiFreeze, dxTaskbarProgress, ImgList, JvAppStorage, JvAppIniStorage,
  JvComponentBase, JvFormPlacement, dxStatusBar, StdCtrls, cxButtons,
  cxListView, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, cxPC, uLkJSON,
  Settings, uNZBGetAPI, JvCipher;

Type
  TfmDemoMain = Class(TfmMain)
    cxbtSettings: TcxButton;
    jvxorcCrypt: TJvXORCipher;
    Procedure cxbtSettingsClick(Sender: TObject);
    Procedure jvfs1AfterRestorePlacement(Sender: TObject);
    Procedure miActualiserstatus1Click(Sender: TObject);
    Procedure miActualiserlistedattente1Click(Sender: TObject);
    Procedure miActualiserhistorique1Click(Sender: TObject);
    Procedure miActualiserlog1Click(Sender: TObject);
    Procedure btRefreshClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    procedure jvaifs1EncryptPropertyValue(var Value: string);
    procedure jvaifs1DecryptPropertyValue(var Value: string);
  Private
    Function CheckSettings: Boolean;
    { Déclarations privées }
  Public
    { Déclarations publiques }
  End;

Var
  fmDemoMain: TfmDemoMain;

Implementation

{$R *.dfm}


Procedure TfmDemoMain.btRefreshClick(Sender: TObject);
Begin
  If Not Assigned(NG) Then
  Begin
    cxbtSettingsClick(cxbtSettings);
    Exit;
  End;

  Inherited;
End;

Procedure TfmDemoMain.cxbtSettingsClick(Sender: TObject);
Begin
  With TfmSettings.Create(Self) Do
    Try
      eHost.Text                    := jvfs1.StoredValue['Host'];
      eUser.Text                    := jvfs1.StoredValue['User'];
      ePass.Text                    := jvfs1.StoredValue['Pass'];
      cbUseSSL.Checked              := jvfs1.StoredValue['UseSSL'];
      If ShowModal = mrOk Then
      Begin
        jvfs1.StoredValue['Host']   := eHost.Text;
        jvfs1.StoredValue['User']   := eUser.Text;
        jvfs1.StoredValue['Pass']   := ePass.Text;
        jvfs1.StoredValue['UseSSL'] := cbUseSSL.Checked;

        jvfs1.WriteBoolean('firstlaunch', False); // ensure not ask settings again
        jvfs1AfterRestorePlacement(jvfs1);
      End;
    Finally
      Free;
    End;
End;

Procedure TfmDemoMain.FormCreate(Sender: TObject);
Begin
  Inherited;
  NG := Nil;
End;

procedure TfmDemoMain.jvaifs1DecryptPropertyValue(var Value: string);
begin
  inherited;

Value:=  jvxorcCrypt.DecodeString(jvxorcCrypt.Key, Value);
end;

procedure TfmDemoMain.jvaifs1EncryptPropertyValue(var Value: string);
begin
  inherited;

Value:=  jvxorcCrypt.EncodeString(jvxorcCrypt.Key, Value);
end;

Procedure TfmDemoMain.jvfs1AfterRestorePlacement(Sender: TObject);
Begin
  Inherited;

  If jvfs1.ReadBoolean('firstlaunch', True) Then
  Begin
    cxbtSettingsClick(cxbtSettings);
  End;

  With jvfs1 Do
  Begin
    If Assigned(NG) Then
      FreeAndNil(NG);

    NG := TNZBGet.Create(StoredValue['Host'], StoredValue['User'], StoredValue['Pass'], StoredValue['UseSSL']);
  End;
End;

Function TfmDemoMain.CheckSettings: Boolean;
Begin
  If Not Assigned(NG) Then
  Begin
    cxbtSettingsClick(cxbtSettings);
    Result := False;
  End
  Else
  Begin
    Result := True;
  End;
End;

Procedure TfmDemoMain.miActualiserhistorique1Click(Sender: TObject);
Begin
  If CheckSettings Then
    Inherited;
End;

Procedure TfmDemoMain.miActualiserlistedattente1Click(Sender: TObject);
Begin
  If CheckSettings Then
    Inherited;
End;

Procedure TfmDemoMain.miActualiserlog1Click(Sender: TObject);
Begin
  If CheckSettings Then
    Inherited;
End;

Procedure TfmDemoMain.miActualiserstatus1Click(Sender: TObject);
Begin
  If CheckSettings Then
    Inherited;
End;

End.
