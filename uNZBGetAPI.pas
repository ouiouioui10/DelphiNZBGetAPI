// --------------------------------------------
//    DelphiNZBGetAPI for communicate with NZBGet API JSON
//    Copyright (C) 2017 Alexandre <ouioui_c_moi@hotmail.com>
//
//    This library is free software; you can redistribute it and/or
//    modify it under the terms of the GNU Lesser General Public
//    License as published by the Free Software Foundation; either
//    version 2.1 of the License, or (at your option) any later version.
//
//    This library is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//    Lesser General Public License for more details.
//
//    You should have received a copy of the GNU Lesser General Public
//    License along with this library; if not, write to the Free Software
//    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
//    USA
//
//    1.0   2013/11/04 - Initial version
//    2.0   2013/11/06 - Rewrite as class
//    2.0.1 2013/11/12 - Better handling error in SendCWMD
//
//    TODO: add
//    Method "editqueue"
//    Method "appendurl"
//    Method "writelog"
//    Method "scan"
//    Method "config"
//    Method "loadconfig"
//    Method "saveconfig"
//    Method "configtemplates"
// --------------------------------------------
Unit uNZBGetAPI;

Interface

Uses Classes, Forms, SysUtils, IdAntiFreezeBase, IdAntiFreeze, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, StdCtrls,
  IdGlobal, Generics.Collections, uLkJSON, EncdDecd, IdIOHandlerStream;

Type
  TItemLog = Class
    ID: Integer;     // ID of log-entry.
    Kind: String;    // Class of log-entry, one of the following strings: INFO, WARNING, ERROR, DEBUG.
    Time: TDateTime; // Time since the Epoch (00:00:00 UTC, January 1, 1970), measured in seconds. This is what c-function "time" returns.
    Text: String;    // Log-message.
    Constructor Create(AID: Integer; AKind: String; ATime: TDateTime; AText: String);
  End;

  TListLog = TObjectList<TItemLog>;

  TItemFiles = Class
    ID: Integer;         // ID of file.
    NZBID: Integer;      // ID of NZB-file.
    NZBFilename: String; // Name of nzb-file. The filename could include fullpath (if client sent it by adding the file to queue).
    NZBName: String;     // //The name of nzb-file without path and extension. Ready for user-friendly output.
    NZBNicename: String;
    // The name of nzb-file without path and extension. Ready for user-friendly output. NOTE: deprecated, use NZBName instead.
    Subject: String;     // Subject of article (read from nzb-file).
    Filename: String;
    // Filename parsed from subject. It could be incorrect since the subject not always correct formated. After the first article for file is read, the correct filename is read from article body.
    FilenameConfirmed: Boolean;
    // "True" if filename was already read from article's body. "False" if the name was parsed from subject. For confirmed filenames the destination file on disk will be exactly as specified in field "filename". For unconfirmed filenames the name could change later.
    DestDir: String;        // Destination directory for output file.
    FileSizeLo: Int64;      // Filesize in bytes, Low 32-bits of 64-bit value.
    FileSizeHi: Int64;      // Filesize in bytes, High 32-bits of 64-bit value.
    RemainingSizeLo: Int64; // Remaining size in bytes, Low 32-bits of 64-bit value.
    RemainingSizeHi: Int64; // Remaining size in bytes, High 32-bits of 64-bit value.
    Paused: Boolean;        // "True" if file is paused.
    PostTime: TDateTime;    // Date/time when the file was posted to newsgroup (Timestamp in Unix format).
    Priority: Integer;      // Priority of the file.
    ActiveDownloads: Integer;
    // Number of active downloads for the file. With this filed can be determined what file(s) is (are) being currently downloaded.
  End;

  TListFiles = TObjectList<TItemFiles>;

  TItemUrlQueue = Class
    ID: Integer;         // ID of URL in the queue.
    NZBFilename: String; // Name of nzb-file, if it was passed when the URL was added to queue. May be empty string.
    URL: String;         // URL to download file from.
    Name: String;
    // The name of nzb-file without path and extension (if it was passed) or a part of the URL. Ready for user-friendly output.
    Category: String;
    // Category assigned to nzb-file when it is added to download queue (after downloading from URL). If the category is empty the category is read from HTTP-response which is usually returned from server hosting the nzb-file.
    Priority: Integer; // Priority assigned to nzb-file when it is added to download queue (after downloading from URL).
  End;

  TListUrlQueue = TObjectList<TItemUrlQueue>;

  TBaseItemLog = Class
    Log: TListLog; // Array of structs with log-messages. For description of struct see TItemLog.
    Constructor Create;
    Destructor Destroy; Override;
  End;

  TItemPostQueue = Class(TBaseItemLog)
    NZBID: Integer; // ID of NZB-file.
    InfoName: String;
    // Text with user-friendly formatted name of item. For par-jobs consists of NZBNicename and of ParFilename. For script-jobs is equal to NZBNicename.
    NZBFilename: String;
    // Name of nzb-file, this file was added to queue from. The filename could include fullpath (if client sent it by adding the file to queue).
    NZBName: String;        // The name of nzb-file without path and extension. Ready for user-friendly output.
    NZBNicename: String;
    // The name of nzb-file without path and extension. Ready for user-friendly output. NOTE: deprecated, use NZBName instead.
    DestDir: String;        // Destination directory for output file.
    ParFilename: String;    // Name of main par-file. For script-jobs this field is empty.
    Stage: String;
    // Indicate current stage of post-job. On of the predefined text constants: QUEUED, LOADING_PARS, VERIFYING_SOURCES, REPAIRING, VERIFYING_REPAIRED, EXECUTING_SCRIPT, FINISHED. The last constant (FINISHED) is very unlikely, because the post-jobs is deleted from queue right after it is completed. If nzb-file has no par-files or par-check is disabled the par-stages (LOADING_PARS..VERIFYING_REPAIRED) are skipped. If postprocess-script is not defined in program's options the stage EXECUTING_SCRIPT is skipped.
    ProgressLabel: String;  // Text with short description of current action in post processor. For example: "Verifying file myfile.rar".
    FileProgress: Integer;  // Compeleting of current file. A number in the range 0..1000. Divide it to 10 to get percent-value.
    StageProgress: Integer; // Compeleting of current stage. A number in the range 0..1000. Divide it to 10 to get percent-value.
    TotalTimeSec: Integer;  // Number of seconds this post-job is beeing processed (after it first changed the state from QUEUED).
    StageTimeSec: Integer;  // Number of seconds the current stage is beeing processed.
  End;

  TListPostQueue = TObjectList<TItemPostQueue>;

  TItemParameters = Class
    Name, Value: String;
    Constructor Create(AName, AValue: String);
  End;

  TListParameters = TObjectList<TItemParameters>;

  TItemHistory = Class(TBaseItemLog)
    ID: Integer;    // ID of history item.
    NZBID: Integer; // ID of history item. NOTE: deprecated, use ID instead.
    Kind: String;
    // Kind of history item. One of the predefined text constants: NZB for nzb-files; URL for failed URL downloads. NOTE: successful URL-downloads results in adding files to download queue, a success-history-item is not created in this case.
    NZBFilename: String;
    // Name of nzb-file, this file was added to queue from. The filename could include fullpath (if client sent it by adding the file to queue).
    Name: String;           // The name of nzb-file or info-name of URL, without path and extension. Ready for user-friendly output.
    NZBNicename: String;
    // The name of nzb-file without path and extension. Ready for user-friendly output. NOTE: deprecated, use Name instead.
    URL: String;            // URL (only for URL-downloads).
    DestDir: String;        // Destination directory for output files.
    Category: String;       // Category for group or empty string if none category is assigned.
    FileSizeLo: Int64;      // Initial size of all files in group in bytes, Low 32-bits of 64-bit value.
    FileSizeHi: Int64;      // Initial size of all files in group in bytes, High 32-bits of 64-bit value.
    FileSizeMB: Integer;    // Initial size of all files in group in megabytes.
    FileCount: Integer;     // Initial number of files in group.
    RemainingFileCount: Integer;
    // Number of parked files in group. If this number is greater than "0", the history item can be returned to download queue using command "HistoryReturn" of method "editqueue".
    HistoryTime: TDateTime; // Date/time when the file was added to history(Timestamp in Unix format).
    ParStatus: String;      // Result of par-check/repair. One of the predefined text constants: NONE, FAILURE, REPAIR_POSSIBLE, SUCCESS.
    ScriptStatus: String;   // Result of post-processing script. One of the predefined text constants: NONE, UNKNOWN, FAILURE, SUCCESS.
    UrlStatus: String; // Result of URL-download (only for URL-downloads). One of the predefined text constants: UNKNOWN, FAILURE, SUCCESS.
    Parameters: TListParameters; // Post-processing parameters for group. For description of struct see method listgroups.
    Constructor Create;
    Destructor Destroy; Override;
  End;

  TListHistory = TObjectList<TItemHistory>;

  TItemGroups = Class
    NZBID: Integer;              // ID of NZB-file.
    FirstID: Integer;            // ID of the first file in download queue, belonging to the group.
    LastID: Integer;             // ID of the last file in download queue, belonging to the group.
    NZBFilename: String;
    // Name of nzb-file, this file was added to queue from. The filename could include fullpath (if client sent it by adding the file to queue).
    NZBName: String;             // The name of nzb-file without path and extension. Ready for user-friendly output.
    NZBNicename: String;
    // The name of nzb-file without path and extension. Ready for user-friendly output. NOTE: deprecated, use NZBName instead.
    DestDir: String;             // Destination directory for output file.
    Category: String;            // Category for group or empty string if none category is assigned.
    FileSizeLo: Int64;           // Initial size of all files in group in bytes, Low 32-bits of 64-bit value.
    FileSizeHi: Int64;           // Initial size of all files in group in bytes, High 32-bits of 64-bit value.
    FileSizeMB: Integer;         // Initial size of all files in group in megabytes.
    RemainingSizeLo: Int64;      // Remaining size of all (remaining) files in group in bytes, Low 32-bits of 64-bit value.
    RemainingSizeHi: Int64;      // Remaining size of all (remaining) files in group in bytes, High 32-bits of 64-bit value.
    RemainingSizeMB: Integer;    // Remaining size of all (remaining) files in group in megabytes.
    PausedSizeLo: Int64;         // Size of all paused files in group in bytes, Low 32-bits of 64-bit value.
    PausedSizeHi: Int64;         // Size of all paused files in group in bytes, High 32-bits of 64-bit value.
    PausedSizeMB: Integer;       // Size of all paused files in group in megabytes.
    FileCount: Integer;          // Initial number of files in group.
    RemainingFileCount: Integer; // Remaining (current) number of files in group.
    RemainingParCount: Integer;  // Remaining (current) number of par-files in group.
    MinPostTime: TDateTime;      // Date/time when the oldest file in the group was posted to newsgroup (Timestamp in Unix format).
    MaxPostTime: TDateTime;      // Date/time when the newest file in the group was posted to newsgroup (Timestamp in Unix format).
    MinPriority: Integer;        // The lowest priority of files in the group. The files in the group can have different priorities.
    MaxPriority: Integer;        // The highest priority of files in the group. The files in the group can have different priorities.
    ActiveDownloads: Integer;
    // Number of active downloads in the group. With this filed can be determined what group(s) is (are) being currently downloaded. In most cases only one group is downloaded at a time however more that one group can be downloaded simultaneously when the first group is almost completely downloaded.
    Parameters: TListParameters; // Post-processing parameters for group. For description of struct see method listgroups.
    Constructor Create;
    Destructor Destroy; Override;
  End;

  TListGroups = TObjectList<TItemGroups>;

  TStatus = Packed Record
    RemainingSizeLo: Int64;
    // Remaining size of all entries in download queue, in bytes. This field contains the low 32-bits of 64-bit value
    RemainingSizeHi: Int64;
    // Remaining size of all entries in download queue, in bytes. This field contains the high 32-bits of 64-bit value
    RemainingSizeMB: Integer; // Remaining size of all entries in download queue, in megabytes.
    DownloadedSizeLo: Int64;
    // Amount of data downloaded since server start, in bytes. This field contains the low 32-bits of 64-bit value
    DownloadedSizeHi: Int64;
    // Amount of data downloaded since server start, in bytes. This field contains the high 32-bits of 64-bit value
    DownloadedSizeMB: Integer;    // Amount of data downloaded since server start, in megabytes.
    DownloadRate: Integer;        // Current download speed, in Bytes per Second.
    AverageDownloadRate: Integer; // Average download speed since server start, in Bytes pro Second.
    DownloadLimit: Integer;
    // Current download limit, in Bytes pro Second. The limit can be changed via method "rate". Be aware of different scales used by the method rate (Kilobytes) and this field (Bytes).
    ThreadCount: Integer;         // Number of threads running. It includes all threads, created by the program, not only download-threads.
    ParJobCount: Integer; // Number of ParJobs in Par-Checker queue (including current file). NOTE: deprecated, use PostJobCount instead.
    PostJobCount: Integer; // Number of Par-Jobs or Post-processing script jobs in the post-processing queue (including current file).
    UrlCount: Integer;            // Number of URLs in the URL-queue (including current file).
    UpTimeSec: Integer;           // Server uptime in seconds.
    DownloadTimeSec: Integer;     // Server download time in seconds.
    ServerStandBy: Boolean;
    // "False" - there are currently downloads running, "True" - no downloads in progress (server paused or all jobs completed).
    ServerPaused: Boolean;        // "True" if server is currently in paused-state. NOTE: deprecated, use DownloadPaused instead.
    DownloadPaused: Boolean;      // "True" if download queue is paused via first pause register (soft-pause).
    Download2Paused: Boolean;     // "True" if download queue is paused via second pause register (manual pause)
    PostPaused: Boolean;          // "True" if post-processor queue is currently in paused-state.
    ScanPaused: Boolean;          // "True" if the scanning of incoming nzb-directory is currently in paused-state.
  End;

  TNZBGet = Class
  Private
    FUseSSL: Boolean;
    FHTTPPath, FUser, FPass: String;
    FIdHTTP: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    FIdIOHandlerStream: TIdIOHandlerStream;
    FError: Boolean;
    FErrorText: String;
    Procedure SetPass(Const Value: String);
    Procedure SetUser(Const Value: String);
  Public
    Function Append(ANZBFilename, ACategory: String; APriority: Integer; AAddToTop: Boolean; AFile: String): Boolean;
    Function History: TListHistory;
    Function ListFiles(AIDFrom, AIDTo, ANZBID: Integer): TListFiles;
    Function ListGroups: TListGroups;
    Function Log(AIDFrom, ANumberOfEntries: Integer): TListLog;
    Function PauseDownload: Boolean;
    Function PauseDownload2: Boolean;
    Function PostQueue(ANumberOfLogEntries: Integer): TListPostQueue;
    Function Rate(ALimite: Integer): Boolean;
    Function ResumeDownload: Boolean;
    Function ResumeDownload2: Boolean;
    Function SendCMD(ACMD: String): String;
    Function SendCMDSimple(ACMD: String): Variant;
    Function ShutDown: Boolean;
    Function Status: TStatus;
    Function UrlQueue: TListUrlQueue;
    Function Version: String;
    Constructor Create(AHTTPPath, AUser, APass: String; AUseSSL: Boolean = True);
    Destructor Destroy; Override;
    Property HTTPPath: String Read FHTTPPath Write FHTTPPath;
    Property User: String Read FUser Write SetUser;
    Property Pass: String Read FPass Write SetPass;
    Property Error: Boolean Read FError;
    Property ErrorText: String Read FErrorText;
    Property IdHTTP: TIdHTTP Read FIdHTTP Write FIdHTTP;
  End;

Function DateTimeToUnix(ConvDate: TDateTime): Longint;
Function UnixToDateTime(USec: Longint): TDateTime;
Function LoadFileToStr(Const Filename: TFileName): String;

Implementation

Const
  // Sets UnixStartDate to TDateTime of 01/01/1970
  UnixStartDate: TDateTime = 25569.0;

Function DateTimeToUnix(ConvDate: TDateTime): Longint;
Begin
  Result := Round((ConvDate - UnixStartDate) * 86400);
End;

Function UnixToDateTime(USec: Longint): TDateTime;
Begin
  Result := (USec / 86400) + UnixStartDate;
End;

Function LoadFileToStr(Const Filename: TFileName): String;
Var
  LStrings: TStringList;
Begin
  LStrings := TStringList.Create;
  Try
    LStrings.Loadfromfile(Filename);
    Result := LStrings.Text;
  Finally
    FreeAndNil(LStrings);
  End;
End;

{ TItemLog }

Constructor TItemLog.Create(AID: Integer; AKind: String; ATime: TDateTime;
  AText: String);
Begin
  ID   := AID;
  Kind := AKind;
  Time := ATime;
  Text := AText;
End;

{ TBaseItemLog }

Constructor TBaseItemLog.Create;
Begin
  Log := TListLog.Create;
End;

Destructor TBaseItemLog.Destroy;
Begin
  Log.Free;

  Inherited;
End;

{ TItemHistory }

Constructor TItemHistory.Create;
Begin
  Parameters := TListParameters.Create;
End;

Destructor TItemHistory.Destroy;
Begin
  Parameters.Free;

  Inherited;
End;

{ TItemParameters }

Constructor TItemParameters.Create(AName, AValue: String);
Begin
  Name  := AName;
  Value := AValue;
End;

{ TItemListGroups }

Constructor TItemGroups.Create;
Begin
  Parameters := TListParameters.Create;
End;

Destructor TItemGroups.Destroy;
Begin
  Parameters.Free;

  Inherited;
End;

{ TNZBGet }

Constructor TNZBGet.Create(AHTTPPath, AUser, APass: String; AUseSSL: Boolean = True);
Begin
  FHTTPPath                    := AHTTPPath;
  FUseSSL                      := AUseSSL;

  FIdHTTP                      := TIdHTTP.Create(Application);
  // ensure apply settings
  User                         := AUser;
  Pass                         := APass;

  FIdSSLIOHandlerSocketOpenSSL := NIL; // prevent compiler warnings

  With FIdHTTP Do
  Begin
    If FUseSSL Then
    Begin
      FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Application);
      IOHandler                    := FIdSSLIOHandlerSocketOpenSSL;
    End
    Else
    Begin
      FIdIOHandlerStream        := TIdIOHandlerStream.Create(Application);
      IOHandler                 := FIdIOHandlerStream;
    End;
    HandleRedirects             := True;
    ReadTimeout                 := 5000;
    Request.CharSet             := 'utf-8';
    Request.ContentEncoding     := 'application/json';
    Request.BasicAuthentication := True;
  End;
End;

Destructor TNZBGet.Destroy;
Begin
  FIdHTTP.Free; // handlers is free auto if set

  Inherited;
End;

// Add nzb-file to download queue. This method is equivalent for command "nzbget -A [T] -K <category> <filename>".
//
// Parameters:
// NZBFilename - name of nzb-file. Server uses the name to build destination directory. This name can contain full path or only filename.
// Category - category for nzb-file. Can be empty string.
// Priority - priority for nzb-file. 0 for "normal priority", positive values for high priority and negative values for low priority. Default priorities are: -100 (very low), -50 (low), 0 (normal), 50 (high), 100 (very high). This parameter exists since version 9.0.
// AddToTop - "True" if the file should be added to the top of the download queue or "False" if to the end.
// Content - content of nzb-file encoded with Base64.
//
// Return value: "True" on success or "False" on failure.
Function TNZBGet.Append(ANZBFilename, ACategory: String; APriority: Integer;
  AAddToTop: Boolean; AFile: String): Boolean;
Var
  js: TlkJSONobject;
  cmd, AddToTop: String;
Begin
  Result := False;

  If Not FileExists(AFile) Then
    Exit;

  If AAddToTop Then
    AddToTop := 'true'
  Else
    AddToTop := 'false';

  cmd        := SendCMD('{"method":"append","params":["' +
    ANZBFilename + '", "' + ACategory + '", ' + IntToStr(APriority) +
    ', ' + AddToTop + ', "' + EncodeString(LoadFileToStr(AFile)) + '"]}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', cmd) = 1) Then
  Begin
    js       := TlkJSON.ParseText(cmd) As TlkJSONobject;
    Try
      Result := js.Field['result'].Value;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.History: TListHistory;
Var
  js: TlkJSONobject;
  jsresult, jslog, jsParameters: TlkJSONbase;
  str: String;
  I, N: Integer;
  ItemHistory: TItemHistory;
Begin
  Result := TListHistory.Create;

  str    := SendCMD('{"method":"history","params":[false]}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', str) = 1) Then
  Begin
    js := TlkJSON.ParseText(str) As TlkJSONobject;
    Try
      If js.IndexOfName('result') <> -1 Then
      Begin
        jsresult      := js.Field['result'];
        For I         := 0 To jsresult.Count - 1 Do
        Begin
          ItemHistory := TItemHistory.Create;
          Try
            With ItemHistory, jsresult.Child[I] Do
            Begin
              ID                 := Field['ID'].Value;
              NZBID              := Field['NZBID'].Value;
              Kind               := Field['Kind'].Value;
              NZBFilename        := Field['NZBFilename'].Value;
              Name               := Field['Name'].Value;
              NZBNicename        := Field['NZBNicename'].Value;
              URL                := Field['URL'].Value;
              DestDir            := Field['DestDir'].Value;
              Category           := Field['Category'].Value;
              FileSizeLo         := Field['FileSizeLo'].Value;
              FileSizeHi         := Field['FileSizeHi'].Value;
              FileSizeMB         := Field['FileSizeMB'].Value;
              FileCount          := Field['FileCount'].Value;
              RemainingFileCount := Field['RemainingFileCount'].Value;
              HistoryTime        := UnixToDateTime(Field['HistoryTime'].Value);
              ParStatus          := Field['ParStatus'].Value;
              ScriptStatus       := Field['ScriptStatus'].Value;
              UrlStatus          := Field['UrlStatus'].Value;
              jsParameters       := Field['Parameters'];
              For N              := 0 To jsParameters.Count - 1 Do
              Begin
                Parameters.Add(TItemParameters.Create(jsParameters.Child[N].Field['Name'].Value,
                  jsParameters.Child[N].Field['Value'].Value));
              End;
              jslog := Field['Log'];
              For N := 0 To jslog.Count - 1 Do
              Begin
                Log.Add(TItemLog.Create(jslog.Child[N].Field['ID'].Value,
                  jslog.Child[N].Field['Kind'].Value,
                  UnixToDateTime(jslog.Child[N].Field['Time'].Value),
                  jslog.Child[N].Field['Text'].Value));
              End;
            End;

            Result.Add(ItemHistory);
          Except
            ItemHistory.Free;
          End;
        End;
      End;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.ListFiles(AIDFrom, AIDTo, ANZBID: Integer): TListFiles;
Var
  js: TlkJSONobject;
  jsresult: TlkJSONbase;
  str: String;
  I: Integer;
  ItemFiles: TItemFiles;
Begin
  Result := TListFiles.Create;

  str    := SendCMD('{"method":"listfiles","params":[' + IntToStr(AIDFrom) +
    ', ' + IntToStr(AIDTo) + ', ' + IntToStr(ANZBID) + ']}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', str) = 1) Then
  Begin
    js := TlkJSON.ParseText(str) As TlkJSONobject;
    Try
      If js.IndexOfName('result') <> -1 Then
      Begin
        jsresult    := js.Field['result'];
        For I       := 0 To jsresult.Count - 1 Do
        Begin
          ItemFiles := TItemFiles.Create;
          Try
            With ItemFiles, jsresult.Child[I] Do
            Begin
              ID                := Field['ID'].Value;
              NZBID             := Field['NZBID'].Value;
              NZBFilename       := Field['NZBFilename'].Value;
              NZBName           := Field['NZBName'].Value;
              NZBNicename       := Field['NZBNicename'].Value;
              Subject           := Field['Subject'].Value;
              Filename          := Field['Filename'].Value;
              FilenameConfirmed := Field['FilenameConfirmed'].Value;
              DestDir           := Field['DestDir'].Value;
              FileSizeLo        := Field['FileSizeLo'].Value;
              FileSizeHi        := Field['FileSizeHi'].Value;
              RemainingSizeLo   := Field['RemainingSizeLo'].Value;
              RemainingSizeHi   := Field['RemainingSizeHi'].Value;
              Paused            := Field['Paused'].Value;
              PostTime          := UnixToDateTime(Field['PostTime'].Value);
              Priority          := Field['Priority'].Value;
              ActiveDownloads   := Field['ActiveDownloads'].Value;
            End;

            Result.Add(ItemFiles);
          Except
            ItemFiles.Free;
          End;
        End;
      End;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.ListGroups: TListGroups;
Var
  js: TlkJSONobject;
  jsresult, jsParameters: TlkJSONbase;
  str: String;
  I, N: Integer;
  ItemGroups: TItemGroups;
Begin
  Result := TListGroups.Create;

  str    := SendCMD('{"method":"listgroups","params":[false]}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', str) = 1) Then
  Begin
    js := TlkJSON.ParseText(str) As TlkJSONobject;
    Try
      If js.IndexOfName('result') <> -1 Then
      Begin
        jsresult     := js.Field['result'];
        For I        := 0 To jsresult.Count - 1 Do
        Begin
          ItemGroups := TItemGroups.Create;
          Try
            With ItemGroups, jsresult.Child[I] Do
            Begin
              NZBID              := Field['NZBID'].Value;
              FirstID            := Field['FirstID'].Value;
              LastID             := Field['LastID'].Value;
              NZBFilename        := Field['NZBFilename'].Value;
              NZBName            := Field['NZBName'].Value;
              NZBNicename        := Field['NZBNicename'].Value;
              DestDir            := Field['DestDir'].Value;
              Category           := Field['Category'].Value;
              FileSizeLo         := Field['FileSizeLo'].Value;
              FileSizeHi         := Field['FileSizeHi'].Value;
              FileSizeMB         := Field['FileSizeMB'].Value;
              RemainingSizeLo    := Field['RemainingSizeLo'].Value;
              RemainingSizeHi    := Field['RemainingSizeHi'].Value;
              RemainingSizeMB    := Field['RemainingSizeMB'].Value;
              PausedSizeLo       := Field['PausedSizeLo'].Value;
              PausedSizeHi       := Field['PausedSizeHi'].Value;
              PausedSizeMB       := Field['PausedSizeMB'].Value;
              FileCount          := Field['FileCount'].Value;
              RemainingFileCount := Field['RemainingFileCount'].Value;
              RemainingParCount  := Field['RemainingParCount'].Value;
              MinPostTime        := UnixToDateTime(Field['MinPostTime'].Value);
              MaxPostTime        := UnixToDateTime(Field['MaxPostTime'].Value);
              MinPriority        := Field['MinPriority'].Value;
              MaxPriority        := Field['MaxPriority'].Value;
              ActiveDownloads    := Field['ActiveDownloads'].Value;
              jsParameters       := Field['Parameters'];
              For N              := 0 To jsParameters.Count - 1 Do
              Begin
                Parameters.Add(TItemParameters.Create(jsParameters.Child[N].Field['Name'].Value,
                  jsParameters.Child[N].Field['Value'].Value));
              End;
            End;

            Result.Add(ItemGroups);
          Except
            ItemGroups.Free;
          End;
        End;
      End;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.Log(AIDFrom, ANumberOfEntries: Integer): TListLog;
Var
  js: TlkJSONobject;
  jsresult: TlkJSONbase;
  str: String;
  I: Integer;
Begin
  Result := TListLog.Create;

  str    := SendCMD('{"method":"log","params":[' + IntToStr(AIDFrom) + ', ' + IntToStr(ANumberOfEntries) + ']}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', str) = 1) Then
  Begin
    js := TlkJSON.ParseText(str) As TlkJSONobject;
    Try
      If js.IndexOfName('result') <> -1 Then
      Begin
        jsresult := js.Field['result'];
        For I    := 0 To jsresult.Count - 1 Do
        Begin
          With jsresult.Child[I] Do
            Result.Add(TItemLog.Create(Field['ID'].Value, Field['Kind'].Value,
              UnixToDateTime(Field['Time'].Value), Field['Text'].Value));
        End;
      End;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.PauseDownload: Boolean;
Begin
  Result := SendCMDSimple('pausedownload');
End;

Function TNZBGet.PauseDownload2: Boolean;
Begin
  Result := SendCMDSimple('pausedownload2');
End;

Function TNZBGet.PostQueue(ANumberOfLogEntries: Integer): TListPostQueue;
Var
  js: TlkJSONobject;
  jsresult, jslog: TlkJSONbase;
  str: String;
  I, N: Integer;
  ItemPostQueue: TItemPostQueue;
Begin
  Result := TListPostQueue.Create;

  str    := SendCMD('{"method":"postqueue","params":[' + IntToStr(ANumberOfLogEntries) + ']}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', str) = 1) Then
  Begin
    js := TlkJSON.ParseText(str) As TlkJSONobject;
    Try
      If js.IndexOfName('result') <> -1 Then
      Begin
        jsresult        := js.Field['result'];
        For I           := 0 To jsresult.Count - 1 Do
        Begin
          ItemPostQueue := TItemPostQueue.Create;
          Try
            With ItemPostQueue, jsresult.Child[I] Do
            Begin
              NZBID         := Field['NZBID'].Value;
              InfoName      := Field['InfoName'].Value;
              NZBFilename   := Field['NZBFilename'].Value;
              NZBName       := Field['NZBName'].Value;
              NZBNicename   := Field['NZBNicename'].Value;
              DestDir       := Field['DestDir'].Value;
              ParFilename   := Field['ParFilename'].Value;
              Stage         := Field['Stage'].Value;
              ProgressLabel := Field['ProgressLabel'].Value;
              FileProgress  := Field['FileProgress'].Value;
              StageProgress := Field['StageProgress'].Value;
              TotalTimeSec  := Field['TotalTimeSec'].Value;
              StageTimeSec  := Field['StageTimeSec'].Value;
              jslog         := Field['StageTimeSec'];
              For N         := 0 To jslog.Count - 1 Do
              Begin
                Log.Add(TItemLog.Create(jslog.Child[N].Field['ID'].Value,
                  jslog.Child[N].Field['Kind'].Value,
                  UnixToDateTime(jslog.Child[N].Field['Time'].Value),
                  jslog.Child[N].Field['Text'].Value));
              End;
            End;

            Result.Add(ItemPostQueue);
          Except
            ItemPostQueue.Free;
          End;
        End;
      End;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.Rate(ALimite: Integer): Boolean;
Var
  js: TlkJSONobject;
  str: String;
Begin
  Result := False;

  str    := SendCMD('{"method":"rate","params":[' + IntToStr(ALimite) + ']}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', str) = 1) Then
  Begin
    js         := TlkJSON.ParseText(str) As TlkJSONobject;
    Try
      If js.IndexOfName('result') <> -1 Then
        Result := js.Field['result'].Value;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.ResumeDownload: Boolean;
Begin
  Result := SendCMDSimple('resumedownload');
End;

Function TNZBGet.ResumeDownload2: Boolean;
Begin
  Result := SendCMDSimple('resumedownload2');
End;

Function TNZBGet.SendCMD(ACMD: String): String;
Var
  StreamToSend: TMemoryStream;
  UTF8CMD: UTF8String;
Begin
  Result       := '';
  FError       := False;
  FErrorText   := '';
  StreamToSend := TMemoryStream.Create;
  Try
    Try
      With FIdHTTP Do
      Begin
        UTF8CMD := UTF8Encode(ACMD);
        StreamToSend.Write(UTF8CMD[1], Length(UTF8CMD));
        Result  := Post(FHTTPPath, StreamToSend); // js.ToString);

        If Response.ResponseCode <> 200 Then
        Begin
          FError     := True;
          FErrorText := Format('%d %s', [Response.ResponseCode, Response.ResponseText]);
        End;
      End;
    Except
      On E: Exception Do
      Begin
        FError     := True;
        FErrorText := E.Message;
      End;
    End;
  Finally
    StreamToSend.Free;
  End;
End;

Function TNZBGet.SendCMDSimple(ACMD: String): Variant;
Var
  js: TlkJSONobject;
Begin
  Result := SendCMD('{"method":"' + ACMD + '","params":[false]}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', Result) = 1) Then
  Begin
    js       := TlkJSON.ParseText(Result) As TlkJSONobject;
    Try
      Result := js.Field['result'].Value;
    Finally
      js.Free;
    End;
  End;
End;

Procedure TNZBGet.SetPass(Const Value: String);
Begin
  FPass                    := Value;
  FIdHTTP.Request.Password := Value;
End;

Procedure TNZBGet.SetUser(Const Value: String);
Begin
  FUser                    := Value;
  FIdHTTP.Request.Username := Value;
End;

Function TNZBGet.ShutDown: Boolean;
Begin
  Result := SendCMDSimple('shutdown');
End;

Function TNZBGet.Status: TStatus;
Var
  js: TlkJSONobject;
  cmd: String;
Begin
  With Result Do
  Begin
    RemainingSizeLo     := 0;
    RemainingSizeHi     := 0;
    RemainingSizeMB     := 0;
    DownloadedSizeLo    := 0;
    DownloadedSizeHi    := 0;
    DownloadedSizeMB    := 0;
    DownloadRate        := 0;
    AverageDownloadRate := 0;
    DownloadLimit       := 0;
    ThreadCount         := 0;
    ParJobCount         := 0;
    PostJobCount        := 0;
    UrlCount            := 0;
    UpTimeSec           := 0;
    DownloadTimeSec     := 0;
    ServerStandBy       := False;
    ServerPaused        := False;
    DownloadPaused      := False;
    Download2Paused     := False;
    PostPaused          := False;
    ScanPaused          := False;
  End;

  cmd                   := SendCMD('{"method":"status","params":[false]}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', cmd) = 1) Then
  Begin
    js := TlkJSON.ParseText(cmd) As TlkJSONobject;
    Try
      With Result, js.Field['result'] Do
      Begin
        RemainingSizeLo     := Field['RemainingSizeLo'].Value;
        RemainingSizeHi     := Field['RemainingSizeHi'].Value;
        RemainingSizeMB     := Field['RemainingSizeMB'].Value;
        DownloadedSizeLo    := Field['DownloadedSizeLo'].Value;
        DownloadedSizeHi    := Field['DownloadedSizeHi'].Value;
        DownloadedSizeMB    := Field['DownloadedSizeMB'].Value;
        DownloadRate        := Field['DownloadRate'].Value;
        AverageDownloadRate := Field['AverageDownloadRate'].Value;
        DownloadLimit       := Field['DownloadLimit'].Value;
        ThreadCount         := Field['ThreadCount'].Value;
        ParJobCount         := Field['ParJobCount'].Value;
        PostJobCount        := Field['PostJobCount'].Value;
        UrlCount            := Field['UrlCount'].Value;
        UpTimeSec           := Field['UpTimeSec'].Value;
        DownloadTimeSec     := Field['DownloadTimeSec'].Value;
        ServerStandBy       := Field['ServerStandBy'].Value;
        ServerPaused        := Field['ServerPaused'].Value;
        DownloadPaused      := Field['DownloadPaused'].Value;
        Download2Paused     := Field['Download2Paused'].Value;
        PostPaused          := Field['PostPaused'].Value;
        ScanPaused          := Field['ScanPaused'].Value;
      End;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.UrlQueue: TListUrlQueue;
Var
  js: TlkJSONobject;
  jsresult: TlkJSONbase;
  str: String;
  I: Integer;
  ItemUrlQueue: TItemUrlQueue;
Begin
  Result := TListUrlQueue.Create;

  str    := SendCMD('{"method":"urlqueue","params":[false]}');
  // if seem json try get result
  If Not Error And (AnsiPos('{', str) = 1) Then
  Begin
    js := TlkJSON.ParseText(str) As TlkJSONobject;
    Try
      If js.IndexOfName('result') <> -1 Then
      Begin
        jsresult       := js.Field['result'];
        For I          := 0 To jsresult.Count - 1 Do
        Begin
          ItemUrlQueue := TItemUrlQueue.Create;
          Try
            With ItemUrlQueue, jsresult.Child[I] Do
            Begin
              ID          := Field['ID'].Value;
              NZBFilename := Field['NZBFilename'].Value;
              URL         := Field['URL'].Value;
              Name        := Field['Name'].Value;
              Category    := Field['Category'].Value;
              Priority    := Field['Priority'].Value;
            End;

            Result.Add(ItemUrlQueue);
          Except
            ItemUrlQueue.Free;
          End;
        End;
      End;
    Finally
      js.Free;
    End;
  End;
End;

Function TNZBGet.Version: String;
Begin
  Result := SendCMDSimple('version');
End;

End.
