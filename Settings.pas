Unit Settings;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  cxButtons;

Type
  TfmSettings = Class(TForm)
    eHost: TEdit;
    ePass: TEdit;
    eUser: TEdit;
    cxbtApply: TcxButton;
    cxbtCancel: TcxButton;
    l1: TLabel;
    l2: TLabel;
    l3: TLabel;
    cbUseSSL: TCheckBox;
    cbShowPassword: TCheckBox;
    Procedure cbShowPasswordClick(Sender: TObject);
  Private
    { Déclarations privées }
  Public
    { Déclarations publiques }
  End;

Var
  fmSettings: TfmSettings;

Implementation

{$R *.dfm}


Procedure TfmSettings.cbShowPasswordClick(Sender: TObject);
Begin
  If (Sender As TCheckBox).Checked Then
    ePass.PasswordChar := #0
  Else
    ePass.PasswordChar := '*';
End;

End.
