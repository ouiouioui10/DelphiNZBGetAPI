inherited fmDemoMain: TfmDemoMain
  Caption = 'fmDemoMain'
  PixelsPerInch = 96
  TextHeight = 13
  inherited lState: TLabel
    Margins.Bottom = 0
  end
  inherited lSpeed: TLabel
    Margins.Bottom = 0
  end
  inherited cxpcInfos: TcxPageControl
    TabOrder = 3
  end
  inherited cxbtRefresh: TcxButton
    Left = 40
    Width = 193
  end
  object cxbtSettings: TcxButton [6]
    Left = 8
    Top = 8
    Width = 26
    Height = 25
    OptionsImage.ImageIndex = 2
    OptionsImage.Images = cxil1
    TabOrder = 0
    OnClick = cxbtSettingsClick
  end
  inherited jvfs1: TJvFormStorage
    Version = 2
    AfterRestorePlacement = jvfs1AfterRestorePlacement
    StoredValues = <
      item
        Name = 'Host'
        Value = 'https://localhost:1234/jsonrpc'
        KeyString = 'Host'
      end
      item
        Name = 'User'
        Value = 'nzbget'
        KeyString = 'User'
      end
      item
        Name = 'Pass'
        Value = ''
        KeyString = 'Pass'
      end
      item
        Name = 'UseSSL'
        Value = True
        KeyString = 'UseSSL'
      end>
  end
  inherited jvaifs1: TJvAppIniFileStorage
    OnEncryptPropertyValue = jvaifs1EncryptPropertyValue
    OnDecryptPropertyValue = jvaifs1DecryptPropertyValue
  end
  inherited cxil1: TcxImageList
    FormatVersion = 1
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
      end
      item
        Image.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000012454545B6454545B60000
          0011000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000838382D9E4E4E4FFE3E3E3FF4A4A
          4AC1000000000000000000000000000000000000000000000000000000000000
          00000000000F393939AD0A0A0A610C0C0C6ED5D5D4F8E2E1DFFFE1E0DFFFD3D3
          D2F30A0A0A670B0B0B66363636AD0000000F0000000000000000000000000000
          00005C5C5BC5FFFFFFFFEDEDECFEECECEBFEE7E7E6FFD6D5D3FFD7D6D4FFE3E2
          E0FFE1E0DEFEE1E0DFFDE9E8E6FF515151C10000000000000000000000000000
          0000787878E7F9F9F7FFEFEFEEFFDBDBDAFFCAC9C9FFC9C8C6FFC9C8C7FFC9C8
          C7FFCBCBC9FFE6E5E4FFE5E4E2FF707070E50000000000000000000000000000
          000030303095F6F5F4FFE6E5E4FFBFBEBDFFEBEBEAFFD4D3D2FFD6D5D4FFE2E1
          E1FFB4B4B3FFD7D6D4FFE2E1DFFF2828288D00000000000000000000000F4444
          44B59B9A9AE7E4E3E2FFD1D0CFFFF0F0EFFFAEAEAEFF9F9E9EF1A1A1A1F2ACAC
          ABFFE8E8E7FFCBCBCAFFE0DFDDFF91918FE4444444B50000000F1717176DE4E4
          E3FFD8D6D5FFD2D1D0FFC5C4C3FFEDECEBFF676767BA00000000000000008080
          7FCDE8E7E6FFB6B5B4FFD6D5D3FFE2E1E0FFE0E0DFFF141414661F1E1E76ECEB
          E8FFDAD9D7FFD4D3D1FFC6C5C4FFDEDCDCFF2827277E00000000000000003E3E
          3D9ADDDCDBFFC8C6C5FFE2E2E1FFE1E1DFFFEEEDECFF1B1B1B6F1E1E1E4A8686
          86EBD7D7D6FCDEDDDCFFCBCACAFFE6E5E5FF919190E1050505500808085CAAAA
          AAEBEEEEECFFCCCBCBFFE7E6E5FFD9D9D8FC878787EB0F0F0F43000000000000
          0000767675CEE1E0DEFFD9D7D6FFB8B7B7FFE1E0DFFFD2D1D1FDE2E1E0FDF6F6
          F5FFC0C0BFFFEAE9E8FFF3F3F2FF717170C90000000000000000000000000000
          00002B2B2B91E3E2E0FFDEDEDCFFE1E0DFFFCCCBCBFFC4C3C2FFCFCFCEFFDEDE
          DDFFF0F0EFFFF0F0EFFFF6F6F5FF262626870000000000000000000000000000
          0002959493E3E5E4E1FFEEEEEDFFEEEEEDFFEBEBEAFFE3E2E1FFE8E8E7FFEAEA
          E9FFF3F3F2FFF5F5F4FFFAF9F8FF949494DF0000000000000000000000000000
          00004747476FB1B1AFFE919190E7A3A2A2F3E8E7E6FFE7E6E5FFEDEDECFFFBFB
          FAFFA8A8A8F2959594E7BDBDBDFE3E3E3E680000000000000000000000000000
          000000000000000000000C0C0C140606060E4F4F4FAAEFEEEDFFF4F4F3FF4F4F
          4FA40505050B0D0D0D1700000000000000000000000000000000000000000000
          0000000000000000000000000000000000001818184A969696F0969696EF0E0E
          0E43000000000000000000000000000000000000000000000000}
      end>
  end
  object jvxorcCrypt: TJvXORCipher
    IsStored = False
    Left = 168
    Top = 64
  end
end