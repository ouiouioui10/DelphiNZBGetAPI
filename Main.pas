Unit Main;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBXJSON, StdCtrls, uNZBGetAPI, ComCtrls, JvAppStorage, JvAppIniStorage,
  JvComponentBase, JvFormPlacement, cxPCdxBarPopupMenu, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxListView, cxPC, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView, cxGrid,
  cxProgressBar, DateUtils, cxLabel, cxTimeEdit, Menus, cxButtons, ImgList,
  dxTaskbarProgress, dxStatusBar, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdAntiFreezeBase, IdAntiFreeze;

Type
  TfmMain = Class(TForm)
    lState: TLabel;
    jvfs1: TJvFormStorage;
    jvaifs1: TJvAppIniFileStorage;
    cxpcInfos: TcxPageControl;
    cxtsLog: TcxTabSheet;
    lvLog: TListView;
    cxtsQueue: TcxTabSheet;
    cxlvQueue: TcxListView;
    cxtsHistory: TcxTabSheet;
    cxlvHistory: TcxListView;
    cxtsFiles: TcxTabSheet;
    cxtsGroups: TcxTabSheet;
    cxtsURLQueue: TcxTabSheet;
    cxlvURLQueue: TcxListView;
    lSpeed: TLabel;
    cxGridDBTableViewGroups: TcxGridDBTableView;
    cxglGridLevelGroups: TcxGridLevel;
    cxgGroups: TcxGrid;
    cxgdbcGridDBTableViewGroupsColumnID: TcxGridDBColumn;
    cxgrdtblvwGroupsTableViewGroup: TcxGridTableView;
    cxgrdclmnGroupsTableViewGroupColumnID: TcxGridColumn;
    cxgrdclmnGroupsTableViewGroupColumnNZBName: TcxGridColumn;
    cxgrdclmnGroupsTableViewGroupColumnProgress: TcxGridColumn;
    cxlvFiles: TcxListView;
    cxgrdtblvwGroupsTableViewGroupColumnState: TcxGridColumn;
    cxgrdtblvwGroupsTableViewGroupColumnAge: TcxGridColumn;
    cxgrdtblvwGroupsTableViewGroupColumnSize: TcxGridColumn;
    cxgrdtblvwGroupsTableViewGroupColumnTimeLeft: TcxGridColumn;
    cxil1: TcxImageList;
    cxbtRefresh: TcxButton;
    PopupMenu1: TPopupMenu;
    miActualiserstatus1: TMenuItem;
    miActualiserlistedattente1: TMenuItem;
    miActualiserhistorique1: TMenuItem;
    miActualiserlog1: TMenuItem;
    miousactualiser1: TMenuItem;
    cxbtSend: TcxButton;
    dxsbState: TdxStatusBar;
    dxsbccStateContainer: TdxStatusBarContainerControl;
    dxtbpProgress: TdxTaskbarProgress;
    cxpbProgress: TcxProgressBar;
    IdAntiFreeze: TIdAntiFreeze;
    Procedure btRefreshClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Procedure miActualiserstatus1Click(Sender: TObject);
    Procedure miActualiserlistedattente1Click(Sender: TObject);
    Procedure miActualiserhistorique1Click(Sender: TObject);
    Procedure miActualiserlog1Click(Sender: TObject);
    Procedure cxbtSendClick(Sender: TObject);
    Procedure idHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    Procedure idHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    Procedure idHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
  Private
    Function AffTime(Ts: Integer): String;
  Public
    NG: TNZBGet;
    Procedure ListGroups;
    Procedure History;
    Procedure Log;
    Procedure Status;
  End;

Var
  fmMain: TfmMain;

Implementation

{$R *.dfm}


Function TfmMain.AffTime(Ts: Integer): String;
Var
  Th: TTimeStamp;
Begin
  If Ts < 0 Then
    Ts    := 0;
  Th.Time := Ts * 1000;
  Th.Date := 1;
  DateTimeToString(Result, 'hh:nn:ss', TimeStampToDateTime(Th));
End;

Procedure TfmMain.btRefreshClick(Sender: TObject);
Begin
  If Not cxbtRefresh.Enabled Then
    Exit;

  cxbtRefresh.Enabled := False;
  Try
    Status;
    ListGroups;
    History;
    Log;
  Finally
    cxbtRefresh.Enabled := True;
  End;
End;

Procedure TfmMain.cxbtSendClick(Sender: TObject);
Begin
  cxbtSend.Enabled := False;
  Try
    With TOpenDialog.Create(Self) Do
      Try
        DefaultExt                 := 'nzb';
        Filter                     := 'Fichier NZB|*.nzb';
        Options                    := [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent];
        Title                      := 'Selectionner un fichier NZB';
        If Execute(Handle) Then
        Begin
          NG.IdHTTP.OnWorkBegin    := idHTTPWorkBegin;
          NG.IdHTTP.OnWork         := idHTTPWork;
          NG.IdHTTP.OnWorkEnd      := idHTTPWorkEnd;
          IdAntiFreeze.Active      := True;

          dxsbState.Panels[0].Text := Format('Envoie NZB %s', [ExtractFileName(FileName)]);

          If NG.Append(ChangeFileExt(ExtractFileName(FileName), ''), '', 0, False, FileName) Then
          Begin
            dxsbState.Panels[1].Visible := False;
            Status;
            ListGroups;
            Log;
          End;
        End;
      Finally
        Free;
        dxsbState.Panels[0].Text    := '';
        NG.IdHTTP.OnWorkBegin       := Nil;
        NG.IdHTTP.OnWork            := Nil;
        NG.IdHTTP.OnWorkEnd         := Nil;
        dxsbState.Panels[1].Visible := False;
        IdAntiFreeze.Active         := False;
      End;
  Finally
    cxbtSend.Enabled                := True;
  End;
End;

Procedure TfmMain.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
  If Assigned(NG) Then
    FreeAndNil(NG);
End;

Procedure TfmMain.FormCreate(Sender: TObject);
Begin
  cxpcInfos.ActivePageIndex := 0;
  dxsbState.Panels[1].Visible    := False;
    NG                             := Nil;
End;

Procedure TfmMain.History;
Var
  I: Integer;
Begin
  IdAntiFreeze.Active      := True;
  cxlvHistory.Items.Clear;
  dxsbState.Panels[0].Text := 'Récupération historique ...';
  Try
    With NG.History Do
      Try
        If Not NG.Error Then
        Begin
          For I := 0 To Count - 1 Do
          Begin
            With cxlvHistory.Items.Add Do
            Begin
              Caption := IntToStr(Items[I].ID);
              SubItems.Add(Items[I].Kind);
              SubItems.Add(Items[I].NZBNicename);
              SubItems.Add(DateTimeToStr(Items[I].HistoryTime));
              SubItems.Add(Items[I].ParStatus);
              SubItems.Add(Format('%u Mo', [Items[I].FileSizeMB]));
            End;
          End;
        End
        Else
          MessageDlg(NG.ErrorText, mtError, [mbOK], 0);
      Finally
        Free;
      End;

  Finally
    IdAntiFreeze.Active      := False;
    dxsbState.Panels[0].Text := '';
  End;
End;

Procedure TfmMain.idHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
Begin
  cxpbProgress.Position := AWorkCount;
  Application.ProcessMessages;
End;

Procedure TfmMain.idHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
Begin
  cxpbProgress.Properties.Max := AWorkCountMax;
  dxsbState.Panels[1].Visible := True;
  dxtbpProgress.Active        := True;
End;

Procedure TfmMain.idHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
Begin
  NG.IdHTTP.OnWorkBegin       := Nil;
  NG.IdHTTP.OnWork            := Nil;
  NG.IdHTTP.OnWorkEnd         := Nil;
  cxpbProgress.Position       := 0;
  dxsbState.Panels[1].Visible := False;
  dxtbpProgress.Active        := False;
End;

Procedure TfmMain.ListGroups;
Var
  I, DownloadRate, TimeLeft, GroupColumnIDIndex, GroupColumnNZBNameIndex,
    GroupColumnProgressIndex, GroupColumnState, GroupColumnAge,
    GroupColumnSize, GroupColumnTimeLeft: Integer;
  TotalSize: Int64;
Begin
  IdAntiFreeze.Active                                       := True;
  cxgrdtblvwGroupsTableViewGroup.DataController.RecordCount := 0;
  dxsbState.Panels[0].Text                                  := 'Récupération Liste NZB ...';
  Try

    With NG.ListGroups Do
      Try
        If Not NG.Error Then
        Begin
          TimeLeft                   := 0;
          With cxgrdtblvwGroupsTableViewGroup.DataController Do
          Begin
            GroupColumnIDIndex       := cxgrdclmnGroupsTableViewGroupColumnID.Index;
            GroupColumnState         := cxgrdtblvwGroupsTableViewGroupColumnState.Index;
            GroupColumnNZBNameIndex  := cxgrdclmnGroupsTableViewGroupColumnNZBName.Index;
            GroupColumnProgressIndex := cxgrdclmnGroupsTableViewGroupColumnProgress.Index;
            GroupColumnAge           := cxgrdtblvwGroupsTableViewGroupColumnAge.Index;
            GroupColumnSize          := cxgrdtblvwGroupsTableViewGroupColumnSize.Index;
            GroupColumnTimeLeft      := cxgrdtblvwGroupsTableViewGroupColumnTimeLeft.Index;

            BeginFullUpdate;
            Try
              DownloadRate                    := NG.Status.DownloadRate;
              RecordCount                     := Count;
              For I                           := 0 To Count - 1 Do
              Begin
                Values[I, GroupColumnIDIndex] := Items[I].NZBID;

                Try
                  If Items[I].ActiveDownloads > 0 Then
                    Values[I, GroupColumnState]       := 'Téléchargement'
                  Else
                    Values[I, GroupColumnState]       := 'Queue';
                Except
                  Values[I, GroupColumnState]         := 'Inconnu';
                End;

                Values[I, GroupColumnNZBNameIndex]    := Items[I].NZBNicename;

                Try
                  Values[I, GroupColumnProgressIndex] := Round(100 - (100 / Items[I].FileSizeMB * Items[I].RemainingSizeMB));
                Except
                  Values[I, GroupColumnProgressIndex] := 0;
                End;

                Try
                  Values[I, GroupColumnAge] := IntToStr(Round(DateOf(Now) - DateOf(Items[I].MaxPostTime))) + ' Jours';
                Except
                  Values[I, GroupColumnAge] := '';
                End;

                Try
                  Values[I, GroupColumnSize] := Format('%d Mo/%d Mo', [Items[I].FileSizeMB - Items[I].RemainingSizeMB,
                    Items[I].FileSizeMB]);
                Except
                  Values[I, GroupColumnSize] := '';
                End;

                If DownloadRate > 0 Then
                Begin
                  Try
                    TotalSize                    := Items[I].RemainingSizeMB * 1024 * 1024;
                    TimeLeft                     := TimeLeft + (TotalSize Div DownloadRate);
                  Except
                    TimeLeft                     := TimeLeft + 0;
                  End;
                  Values[I, GroupColumnTimeLeft] := AffTime(TimeLeft);
                End
                Else
                  Values[I, GroupColumnTimeLeft] := 0;
              End;
            Finally
              EndFullUpdate;
            End;
          End;
        End
        Else
          MessageDlg(NG.ErrorText, mtError, [mbOK], 0);
      Finally
        Free;
      End;

  Finally
    IdAntiFreeze.Active      := False;
    dxsbState.Panels[0].Text := '';
  End;
End;

Procedure TfmMain.Log;
Var
  I: Integer;
Begin
  IdAntiFreeze.Active      := True;
  lvLog.Items.Clear;
  dxsbState.Panels[0].Text := 'Récupération log ...';
  Try

    With NG.Log(0, 100) Do
      Try
        If Not NG.Error Then
        Begin

          For I := 0 To Count - 1 Do
          Begin
            With lvLog.Items.Add Do
            Begin
              Caption := IntToStr(Items[I].ID);
              SubItems.Add(Items[I].Kind);
              SubItems.Add(DateTimeToStr(Items[I].Time));
              SubItems.Add(Items[I].Text);
            End;
          End;
          If lvLog.Items.Count > 0 Then
            lvLog.Items[lvLog.Items.Count - 1].MakeVisible(True);
        End
        Else
          MessageDlg(NG.ErrorText, mtError, [mbOK], 0);
      Finally
        Free;
      End;

  Finally
    IdAntiFreeze.Active      := False;
    dxsbState.Panels[0].Text := '';
  End;
End;

Procedure TfmMain.miActualiserhistorique1Click(Sender: TObject);
Begin
  If Not cxbtRefresh.Enabled Then
    Exit;

  cxbtRefresh.Enabled := False;
  Try
    History;
  Finally
    cxbtRefresh.Enabled := True;
  End;
End;

Procedure TfmMain.miActualiserlistedattente1Click(Sender: TObject);
Begin
  If Not cxbtRefresh.Enabled Then
    Exit;

  cxbtRefresh.Enabled := False;
  Try
    ListGroups;
  Finally
    cxbtRefresh.Enabled := True;
  End;
End;

Procedure TfmMain.miActualiserlog1Click(Sender: TObject);
Begin
  If Not cxbtRefresh.Enabled Then
    Exit;

  cxbtRefresh.Enabled := False;
  Try
    Log;
  Finally
    cxbtRefresh.Enabled := True;
  End;
End;

Procedure TfmMain.miActualiserstatus1Click(Sender: TObject);
Begin
  If Not cxbtRefresh.Enabled Then
    Exit;

  cxbtRefresh.Enabled := False;
  Try
    Status;
  Finally
    cxbtRefresh.Enabled := True;
  End;
End;

Procedure TfmMain.Status;
Var
  Version: String;
  I: Integer;
Begin
  IdAntiFreeze.Active      := True;
  dxsbState.Panels[0].Text := 'Récupération status ...';
  lState.Caption           := 'État : ' + NG.ErrorText;
  lSpeed.Caption           := '';
  Try

    Version                := NG.Version;
    If Not NG.Error Then
    Begin
      lState.Caption       := Format('État : en ligne, (version %s)', [Version]);

      Try
        I                  := NG.Status.DownloadRate Div 1024;
      Except
        I                  := 0;
      End;
      lSpeed.Caption       := Format('Vitesse %s Ko/sec...', [FormatFloat('0.00', I)]);
    End
    Else
      MessageDlg(NG.ErrorText, mtError, [mbOK], 0);

  Finally
    IdAntiFreeze.Active      := False;
    dxsbState.Panels[0].Text := '';
  End;
End;

End.

// NG.Rate(1000);
// NG.Rate(0);

// With NG.ListFiles(0, 0, 0) Do
// Try
// cxlvFiles.Items.Clear;
// For I := 0 To Count - 1 Do
// Begin
// With cxlvFiles.Items.Add Do
// Begin
// Caption := IntToStr(Items[I].ID);
// SubItems.Add(Items[I].NZBFilename);
// End;
// End;
// Finally
// Free;
// End;

// With NG.UrlQueue Do
// Try
// cxlvURLQueue.Items.Clear;
// For I := 0 To Count - 1 Do
// Begin
// With cxlvURLQueue.Items.Add Do
// Begin
// Caption := IntToStr(Items[I].ID);
// SubItems.Add(Items[I].NZBFilename);
// End;
// End;
// Finally
// Free;
// End;

// With NG.PostQueue(50) Do
// Try
// cxlvQueue.Items.Clear;
// For I := 0 To Count - 1 Do
// Begin
// With cxlvQueue.Items.Add Do
// Begin
// Caption := IntToStr(Items[I].NZBID);
// SubItems.Add(Items[I].InfoName);
// SubItems.Add(Items[I].NZBFilename);
// End;
// End;
// Finally
// Free;
// End;
