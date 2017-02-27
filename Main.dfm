object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'NZB Get'
  ClientHeight = 362
  ClientWidth = 780
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 796
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    780
    362)
  PixelsPerInch = 96
  TextHeight = 13
  object lState: TLabel
    Left = 380
    Top = 13
    Width = 67
    Height = 13
    Caption = #201'tat : inconnu'
  end
  object lSpeed: TLabel
    Left = 608
    Top = 13
    Width = 160
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    AutoSize = False
  end
  object cxpcInfos: TcxPageControl
    Left = 8
    Top = 39
    Width = 764
    Height = 298
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    Properties.ActivePage = cxtsGroups
    Properties.TabWidth = 200
    ClientRectBottom = 294
    ClientRectLeft = 4
    ClientRectRight = 760
    ClientRectTop = 24
    object cxtsGroups: TcxTabSheet
      Caption = 'Liste d'#39'attente'
      ImageIndex = 4
      object cxgGroups: TcxGrid
        Left = 0
        Top = 0
        Width = 756
        Height = 270
        Align = alClient
        TabOrder = 0
        object cxGridDBTableViewGroups: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          object cxgdbcGridDBTableViewGroupsColumnID: TcxGridDBColumn
          end
        end
        object cxgrdtblvwGroupsTableViewGroup: TcxGridTableView
          FilterBox.CustomizeDialog = False
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Filtering.MRUItemsList = False
          Filtering.ColumnMRUItemsList = False
          OptionsCustomize.ColumnFiltering = False
          OptionsCustomize.ColumnGrouping = False
          OptionsCustomize.ColumnHidingOnGrouping = False
          OptionsCustomize.ColumnMoving = False
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.MultiSelect = True
          OptionsView.GroupByBox = False
          object cxgrdclmnGroupsTableViewGroupColumnID: TcxGridColumn
            Caption = 'Id'
            DataBinding.ValueType = 'Integer'
            PropertiesClassName = 'TcxLabelProperties'
          end
          object cxgrdtblvwGroupsTableViewGroupColumnState: TcxGridColumn
            Caption = #201'tat'
            PropertiesClassName = 'TcxLabelProperties'
            Width = 80
          end
          object cxgrdclmnGroupsTableViewGroupColumnNZBName: TcxGridColumn
            Caption = 'NZB'
            PropertiesClassName = 'TcxLabelProperties'
            Width = 262
          end
          object cxgrdclmnGroupsTableViewGroupColumnProgress: TcxGridColumn
            Caption = 'Progression'
            PropertiesClassName = 'TcxProgressBarProperties'
            Width = 69
          end
          object cxgrdtblvwGroupsTableViewGroupColumnAge: TcxGridColumn
            Caption = 'Age'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taRightJustify
            Width = 60
          end
          object cxgrdtblvwGroupsTableViewGroupColumnSize: TcxGridColumn
            Caption = 'Taille (t'#233'l'#233'charg'#233'/totale)'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Width = 125
          end
          object cxgrdtblvwGroupsTableViewGroupColumnTimeLeft: TcxGridColumn
            Caption = 'Temps restant'
            DataBinding.ValueType = 'DateTime'
            PropertiesClassName = 'TcxTimeEditProperties'
            Width = 79
          end
        end
        object cxglGridLevelGroups: TcxGridLevel
          GridView = cxgrdtblvwGroupsTableViewGroup
        end
      end
    end
    object cxtsHistory: TcxTabSheet
      Caption = 'Historique'
      ImageIndex = 2
      object cxlvHistory: TcxListView
        Left = 0
        Top = 0
        Width = 756
        Height = 270
        Align = alClient
        Columns = <
          item
            Caption = 'ID'
          end
          item
            Caption = 'Kind'
          end
          item
            Caption = 'NZB Filename'
            Width = 220
          end
          item
            Caption = 'Date'
            Width = 160
          end
          item
            Caption = 'Par2 v'#233'rification'
            Width = 110
          end
          item
            Caption = 'Taille'
            Width = 100
          end>
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object cxtsLog: TcxTabSheet
      Caption = 'Log'
      ImageIndex = 0
      object lvLog: TListView
        Left = 0
        Top = 0
        Width = 756
        Height = 270
        Align = alClient
        Columns = <
          item
            Caption = 'ID'
            Width = 70
          end
          item
            Caption = 'Kind'
            Width = 100
          end
          item
            Caption = 'Date'
            Width = 150
          end
          item
            Caption = 'Texte'
            Width = 430
          end>
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object cxtsFiles: TcxTabSheet
      Caption = 'Files'
      ImageIndex = 3
      TabVisible = False
      object cxlvFiles: TcxListView
        Left = 0
        Top = 0
        Width = 756
        Height = 270
        Align = alClient
        Columns = <
          item
            Caption = 'ID'
          end
          item
            Caption = 'NZB Filename'
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object cxtsQueue: TcxTabSheet
      Caption = 'Queue'
      ImageIndex = 1
      TabVisible = False
      object cxlvQueue: TcxListView
        Left = 0
        Top = 0
        Width = 756
        Height = 270
        Align = alClient
        Columns = <
          item
            Caption = 'NZB Id'
          end
          item
            Caption = 'InfoName'
          end
          item
            Caption = 'NZB Filename'
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object cxtsURLQueue: TcxTabSheet
      Caption = 'URL Queue'
      ImageIndex = 5
      TabVisible = False
      object cxlvURLQueue: TcxListView
        Left = 0
        Top = 0
        Width = 756
        Height = 270
        Align = alClient
        Columns = <
          item
            Caption = 'ID'
          end
          item
            Caption = 'NZB Filename'
            Width = 250
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object cxbtRefresh: TcxButton
    Left = 8
    Top = 8
    Width = 225
    Height = 25
    Caption = 'Actualiser les informations'
    DropDownMenu = PopupMenu1
    Kind = cxbkDropDownButton
    OptionsImage.ImageIndex = 0
    OptionsImage.Images = cxil1
    TabOrder = 1
    OnClick = btRefreshClick
  end
  object cxbtSend: TcxButton
    Left = 239
    Top = 8
    Width = 135
    Height = 25
    Layout = blGlyphRight
    Caption = 'Envoyer NZB'
    OptionsImage.ImageIndex = 1
    OptionsImage.Images = cxil1
    OptionsImage.Layout = blGlyphRight
    TabOrder = 2
    OnClick = cxbtSendClick
  end
  object dxsbState: TdxStatusBar
    Left = 0
    Top = 339
    Width = 780
    Height = 23
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Width = 300
      end
      item
        PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
        PanelStyle.Container = dxsbccStateContainer
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    object dxsbccStateContainer: TdxStatusBarContainerControl
      Left = 306
      Top = 4
      Width = 456
      Height = 17
      object cxpbProgress: TcxProgressBar
        Left = 0
        Top = 0
        Align = alClient
        TabOrder = 0
        Width = 456
      end
    end
  end
  object jvfs1: TJvFormStorage
    AppStorage = jvaifs1
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'cxpcInfos.ActivePage'
      'cxgrdclmnGroupsTableViewGroupColumnID.Width'
      'cxgrdtblvwGroupsTableViewGroupColumnState.Width'
      'cxgrdclmnGroupsTableViewGroupColumnNZBName.Width'
      'cxgrdclmnGroupsTableViewGroupColumnProgress.Width'
      'cxgrdtblvwGroupsTableViewGroupColumnAge.Width'
      'cxgrdtblvwGroupsTableViewGroupColumnSize.Width'
      'cxgrdtblvwGroupsTableViewGroupColumnTimeLeft.Width'
      'cxlvHistory.Columns'
      'lvLog.Columns')
    StoredValues = <>
    Left = 232
    Top = 64
  end
  object jvaifs1: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    FileName = 'conf.ini'
    SubStorages = <>
    Left = 136
    Top = 64
  end
  object cxil1: TcxImageList
    FormatVersion = 1
    DesignInfo = 4194616
    ImageInfo = <
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          000000000000000000000104002D1B430BCD0000000100000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000070A21275E13F11E5B0CEB0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000010A1122255F1FEC428A40FF1F5E0EEB1B5000DA1B5100DA1B5200DB1B52
          00DB1B5200DB1B5200DB1B5000DA1B5000DA133A01A00000000000000000020B
          1225265C1AEC458941FF378B39FF37A33BFD2DAC33F227B731F222C22FF21DC3
          2BF218BD24F211AD1CF20D9214F00E7813F51D5C0CF000000000000000001D4F
          18D547893AFF378E3AFF32AC36FF2EC436FF2DD638FF28E137FF23E934FF1AE7
          2BFF10DB20FF06C612FF00A105FF006F02FF185F08F800000000000000000415
          2235186118EB0DA310FF28C936FF44D555FB50D45FEA64DF71EA6BE078EA5FE0
          69EA4BD94FE83DC24BF029BF39FF018F06FF186509F800000000000000000317
          2B38032D4F5D227D25F049EB4FFF2C801EEA174601BA184701BA184701BB1847
          01BB174300B61B5005C748D957FF08AB10FF186E09F800000000000000000730
          557105417C802B5D7E8B399537F4398527EA0000000000000000000000000000
          00000D2079BE14411A8440A942B20B8D14C2176407DF00000000000000000B48
          7DAB0265BDCB2D75BEBE09224981266514C00001000100000000000000000000
          000026439EE3294DA1F32561326A07430956154F04BC00000000000000000E59
          9CDE0077E1FF1F8DF9FF1F8DF9FF000050A8010354AD000254AD000254AC0001
          52AB193A99E23499FFFF0D3A8CEC0320072E0107010A00000000000000001356
          98E10672D7FF0E7BE0FF1F7FE1ED388BE2E2579DE4E464A5E4E45CA1E3E44592
          DDE4278CF2F90177ECFF1671CDFF062E60DD0210041B00000000000000003065
          9DE24796ECFF3899EDFF32AAFDFF47B7FFFF60C0FFFF60BFFFFF4AB5FFFF28A4
          FFFF0B8AF3FF1A86E0FF2788D8FF1B6AC4FF092851C900000000000000004464
          85D278ACE3FB68A6DAF463ABE0F45DAFE5F45EB1E8F556ADE8F549A3E4F54498
          DAF54998DEFD4295E0FF428FE0FF16367AE90315062F00000000000000000103
          2E6501034492010254B2010355B2010355B2010456B3010457B4010456B30002
          54B2203283E594C1FDFF35558CE90214042A0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00002E377EE35F68A1F1010C052A000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00001F234AB90504083600000000000000000000000000000000}
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          000000000000000000000000000009100823306430D5296A29D32B6D2CD33167
          30D5091008230000000000000000000000000000000000000000000000000000
          00000000000000000000000000000B130A2C338933FF11A719FF1EBA2BFF3896
          3CFF0B130A2C0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000B110A2A299E2AFF00C111FF08FC22FF37BA
          40FF0A110A2A0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000B110A2A2A9D2AFF00C711FF11F528FF3AB5
          41FF0A110A2A0000000000000000000000000000000000000000000000000000
          0000000000000000000000000000090F09232A9A2AFF00BC10FF09EE21FF37B2
          3EFF090E08230000000000000000000000000000000000000000080F08220B13
          0B2C0B120B2A0B120B2A0B110A2A151E144C309030FD00A80CFF00D416FF2DA5
          35FD121C114C0A11092A0A11092A0A11092A0A130A2C080F08222F632ED62882
          29FF15921CFF15991DFF149F1DFF169E1EFF0DA113FB008608FF00B711FF30BC
          3BFB4DA64EFF4FAD53FF51AE54FF52AF56FF489148FF356634D6296228D40B87
          10FF009503FF00B012FF00C813FF00CE13FF00C412FF0FA61EFF20A52EFF2EC9
          3BFF3DE34CFF4AE958FF50EB5FFF54EF64FF4CB152FF356C35D4296629D412A0
          1AFF00E415FF27FD3DFF52FF62FF60FF70FF44F956FF2FD73DFF2EB13BFF3CB0
          47FF44C751FF4ED15BFF56D363FF63D670FF55A55AFF386938D4316630D63595
          39FF3DBE45FF56BE5BFF69BB6DFF66B469FF5DE266FB4EF660FF3FD64EFF51B1
          58FB509753FF57A05BFF5CA25FFF62A565FF528D52FF376636D6080F08220B13
          0A2C0A110A2A0911092A0911082A0F1B0D4C5EB461FD74FF80FF52E961FF4FA4
          50FD111D0F4C0912092A0911092A0911092A0A13092C080F0822000000000000
          0000000000000000000000000000080E072360BC64FF78FF86FF5FE86BFF55A7
          58FF080E07230000000000000000000000000000000000000000000000000000
          00000000000000000000000000000911092A5DBA5EFF6DFC79FF67DE70FF5BA4
          5CFF0911092A0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000911092A5CB65FFF72F67FFF7CDC85FF64A6
          65FF0911082A0000000000000000000000000000000000000000000000000000
          00000000000000000000000000000A130A2C4D904DFF61B565FF68AE6BFF528D
          52FF0A13092C0000000000000000000000000000000000000000000000000000
          000000000000000000000000000008100823376535D53B6C3AD33D6C3BD33865
          35D5081008230000000000000000000000000000000000000000}
      end>
  end
  object PopupMenu1: TPopupMenu
    Left = 392
    Top = 64
    object miActualiserstatus1: TMenuItem
      Caption = 'Actualiser status'
      ShortCut = 112
      OnClick = miActualiserstatus1Click
    end
    object miActualiserlistedattente1: TMenuItem
      Caption = 'Actualiser liste d'#39'attente'
      ShortCut = 113
      OnClick = miActualiserlistedattente1Click
    end
    object miActualiserhistorique1: TMenuItem
      Caption = 'Actualiser historique'
      ShortCut = 114
      OnClick = miActualiserhistorique1Click
    end
    object miActualiserlog1: TMenuItem
      Caption = 'Actualiser log'
      ShortCut = 115
      OnClick = miActualiserlog1Click
    end
    object miousactualiser1: TMenuItem
      Caption = 'Tous actualiser'
      ShortCut = 116
      OnClick = btRefreshClick
    end
  end
  object dxtbpProgress: TdxTaskbarProgress
    LinkedComponent = cxpbProgress
    Left = 576
    Top = 64
  end
  object IdAntiFreeze: TIdAntiFreeze
    Active = False
    Left = 480
    Top = 64
  end
end
