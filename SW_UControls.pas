unit SW_UControls;

interface

uses
  Classes, Controls, StdCtrls, Graphics, Comp_UFlipPanel, ExtCtrls, Messages,
  Types;
type
  { ISwiftControl }
  ISwiftControl = interface
    ['{B7B61C43-4F1D-4DA2-A91A-2E73E23AE299}']
    function GetOnValidate: TNotifyEvent;
    procedure SetOnValidate(Value: TNotifyEvent);
    property OnValidate: TNotifyEvent read GetOnValidate write SetOnValidate;
  end;

  { TSwiftEdit }
  TSwiftEdit = class(TEdit, ISwiftControl)
  private
    FMandatoryField: Boolean;                                                   // признак обязательного поля
    FMandatoryLabel: TLabel;                                                    // метка обязательного поля
    FOnValidate: TNotifyEvent;                                                  // событие валидации

    procedure SetMandatoryField(const Value: Boolean);
    procedure SetLabelBounds;
    function GetOnValidate: TNotifyEvent;
    procedure SetOnValidate(Value: TNotifyEvent);
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure CMVisiblechanged(var Message: TMessage);
      message CM_VISIBLECHANGED;
    procedure CMEnabledchanged(var Message: TMessage);
      message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage);
      message CM_BIDIMODECHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalLabel;
  published
    { property }
    property MandatoryField: Boolean read FMandatoryField write SetMandatoryField default True;
  end;

  { TSwiftComboBox }
  TSwiftComboBox = class(TComboBox, ISwiftControl)
  private
    FMandatoryField: Boolean;
    FMandatoryLabel: TLabel;
    FOnValidate: TNotifyEvent;

    procedure SetMandatoryField(const Value: Boolean);
    procedure SetLabelBounds;
    function GetOnValidate: TNotifyEvent;
    procedure SetOnValidate(Value: TNotifyEvent);
  protected
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CMVisiblechanged(var Message: TMessage);
      message CM_VISIBLECHANGED;
    procedure CMEnabledchanged(var Message: TMessage);
      message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage);
      message CM_BIDIMODECHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalLabel;
  published
    {property}
    property MandatoryField: Boolean read FMandatoryField write SetMandatoryField default True;
  end;

  { TSwiftFlipPanel }
  TSwiftFieldControl = class(TScFlipPanel)
  private
  //  FFiledName : string;
  //  FFiledValue: string;
  public
    constructor Create(AOwner: TComponent); override;
    {property}
//    property FiledValue: string read GetFieldValue write SetFieldValue;
  published
    {property}
//    property FiledName: string read GetFieldName write SetFieldName;
  end;

procedure Register;

implementation

uses
  SysUtils;

procedure Register;
begin
  RegisterComponents('Swift Controls', [
      TSwiftEdit,
      TSwiftComboBox,
      TSwiftFieldControl
    ]);
end;

{ TSwiftComboBox }

procedure TSwiftComboBox.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  if FMandatoryLabel <> nil then
    FMandatoryLabel.BiDiMode := BiDiMode;
end;

procedure TSwiftComboBox.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  if FMandatoryLabel <> nil then
    FMandatoryLabel.Enabled := Enabled;
end;

procedure TSwiftComboBox.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  if FMandatoryLabel <> nil then
    FMandatoryLabel.Visible := Visible;
end;

constructor TSwiftComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMandatoryField := True;
  SetupInternalLabel;
end;

function TSwiftComboBox.GetOnValidate: TNotifyEvent;
begin
  Result := FOnValidate;
end;

procedure TSwiftComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
    if (AComponent = FMandatoryLabel) then
      FMandatoryLabel := nil;
  end;
end;

procedure TSwiftComboBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelBounds;
end;

procedure TSwiftComboBox.SetLabelBounds;
begin
  if FMandatoryLabel = nil then Exit;
  FMandatoryLabel.SetBounds(Self.Left + Self.Width + 2, Self.Top, 10, Self.Height);
end;

procedure TSwiftComboBox.SetMandatoryField(const Value: Boolean);
begin
  FMandatoryField := Value;
  if Assigned(FMandatoryLabel) then begin
    FMandatoryLabel.Visible := FMandatoryField;
  end;
end;

procedure TSwiftComboBox.SetOnValidate(Value: TNotifyEvent);
begin
  FOnValidate := Value;
end;

procedure TSwiftComboBox.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FMandatoryLabel = nil then exit;

  FMandatoryLabel.Parent := AParent;
  FMandatoryLabel.Visible := FMandatoryField;
end;

procedure TSwiftComboBox.SetupInternalLabel;
begin
  if Assigned(FMandatoryLabel) then Exit;
  FMandatoryLabel := TLabel.Create(Self);
  FMandatoryLabel.FreeNotification(Self);
  FMandatoryLabel.FocusControl := Self;
  FMandatoryLabel.ParentColor := False;
  FMandatoryLabel.ParentFont := False;
  FMandatoryLabel.Caption    := '*';
  FMandatoryLabel.Font.Name  := 'System';
  FMandatoryLabel.Font.Size  := 15;
  FMandatoryLabel.Font.Style := [ fsBold ];
  FMandatoryLabel.Font.Color := clRed;
  FMandatoryLabel.Layout     := tlCenter;
  FMandatoryLabel.Visible    := FMandatoryField;
end;

{ TSwiftEdit }

procedure TSwiftEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  if FMandatoryLabel <> nil then
    FMandatoryLabel.BiDiMode := BiDiMode;
end;

procedure TSwiftEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  if FMandatoryLabel <> nil then
    FMandatoryLabel.Enabled := Enabled;
end;

procedure TSwiftEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  if FMandatoryLabel <> nil then
    FMandatoryLabel.Visible := Visible;
end;

constructor TSwiftEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMandatoryField := True;
  SetupInternalLabel;
end;

procedure TSwiftEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetLabelBounds;
end;

procedure TSwiftEdit.SetLabelBounds;
begin
  if FMandatoryLabel = nil then Exit;
  FMandatoryLabel.SetBounds(Self.Left + Self.Width + 2, Self.Top, 10, Self.Height);
end;

procedure TSwiftEdit.SetMandatoryField(const Value: Boolean);
begin
  FMandatoryField := Value;
  if Assigned(FMandatoryLabel) then begin
    FMandatoryLabel.Visible := FMandatoryField;
  end;
end;

procedure TSwiftEdit.SetOnValidate(Value: TNotifyEvent);
begin
  FOnValidate := Value;
end;

procedure TSwiftEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FMandatoryLabel = nil then exit;
  FMandatoryLabel.Parent := AParent;
  FMandatoryLabel.Visible := FMandatoryField;
end;

procedure TSwiftEdit.SetupInternalLabel;
begin
  if Assigned(FMandatoryLabel) then Exit;
  FMandatoryLabel := TLabel.Create(Self);
  FMandatoryLabel.FreeNotification(Self);
  FMandatoryLabel.FocusControl := Self;
  FMandatoryLabel.ParentColor := False;
  FMandatoryLabel.ParentFont := False;
  FMandatoryLabel.Caption    := '*';
  FMandatoryLabel.Font.Name  := 'System';
  FMandatoryLabel.Font.Size  := 15;
  FMandatoryLabel.Font.Style := [ fsBold ];
  FMandatoryLabel.Font.Color := clRed;
  FMandatoryLabel.Layout     := tlCenter;
  FMandatoryLabel.Visible    := FMandatoryField;
end;

function TSwiftEdit.GetOnValidate: TNotifyEvent;
begin
  Result := FOnValidate;
end;

{ TSwiftFlipPanel }

constructor TSwiftFieldControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HeaderFont.Style := [fsBold];
end;

end.
