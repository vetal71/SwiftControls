unit GrtPanel;

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Buttons, StdCtrls, Graphics;

procedure Register;

type TEnumExpandStatus = (esExpanded, esCollapsed);

type
  TGrtPanel = class(TPanel)
  private
    { Private declarations }
    FPanel: TPanel;
    FExpandButton: TSpeedButton;
    FCaptionLabel: TLabel;
    FOnCollapse: TNotifyEvent;
    FOnExpand: TNotifyEvent;
    FAttachedPanel: TPanel;
    FAutoCollapse: boolean;
    FHeight: integer;
    FStatus: TEnumExpandStatus;

    procedure SetImage(AValue: TBitmap);
    function  GetImage(): TBitmap;
    procedure SetHeight(AValue: integer);
    procedure SetStatus(const AValue: TEnumExpandStatus);
    procedure SetAutoCollapse(const AValue: boolean);
    procedure SetLabel(AValue: string);
    function  GetLabel(): string;
    procedure SetOnCollapse(const AValue: TNotifyEvent);
    procedure SetOnExpand(const AValue: TNotifyEvent);
    procedure SetAttachedPanel(const AValue: TPanel);
    procedure ResizePanel();

    const UP = '5';
    const DOWN = '6';
    const MIN_HEIGHT = 24;

  protected
    { Protected declarations }
    procedure OnMyButtonClick(Sender: TObject);
    procedure OnShowPanel(Sender: TObject);
    procedure AllignAttachedPanel();
    procedure Paint; override;
    //procedure SetInitialHeight(Sender: TObject);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

  published
    { Published declarations }
    property GrtOnExpand: TNotifyEvent read FOnExpand write SetOnExpand;
    property GrtOnCollapse: TNotifyEvent read FOnCollapse write SetOnCollapse;
    property GrtCaption: string read GetLabel write SetLabel;
    property GrtHeight: integer read FHeight write SetHeight;
    property GrtAttachedPanel: TPanel read FAttachedPanel write SetAttachedPanel;
    property GrtAutoCollapse: boolean read FAutoCollapse write SetAutoCollapse;
    property GrtStatus: TEnumExpandStatus read FStatus write SetStatus;
    property GrtBtnImage: TBitmap read GetImage write SetImage;
  end;



implementation

//$R GrtPanel.Dcr}

procedure Register;
begin
  RegisterComponents('Samples', [TGrtPanel]);
end;

{ TGrtPanel }

procedure TGrtPanel.AllignAttachedPanel;
begin
  if not Assigned(FAttachedPanel) then Exit;
  FAttachedPanel.Top := Self.Top + Self.Height;
  FAttachedPanel.Left := Self.Left;
  if FAttachedPanel is TGrtPanel then
    TGrtPanel(FAttachedPanel).AllignAttachedPanel();
end;

constructor TGrtPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Constraints.MinHeight := MIN_HEIGHT;
  FStatus := esExpanded;
  FAutoCollapse := false;
  if FHeight > 0  then Self.Height := FHeight;

  if not Assigned(FPanel) then begin
    FPanel := TPanel.Create(Self);
    with FPanel do
    begin
      Parent := Self;
      Align := alTop;
      Constraints.MinHeight := MIN_HEIGHT;
      Height := MIN_HEIGHT;
      BevelOuter := bvNone;
      BorderWidth := 4;
      Caption := '';
    end;  { PanTopContainer1 }
  end;

  if not Assigned(FExpandButton) then begin
    FExpandButton := TSpeedButton.Create(Self);
    with FExpandButton do
    begin
      Parent := FPanel;
      Align := alLeft;
      Width := 20;
      Flat := true;
      Font.Size := 12;
      Caption := '6';
      Font.Name := 'Webdings';
      OnClick := OnMyButtonClick;
    end;  { ExpandButton1 }
  end;

  if not Assigned(FCaptionLabel) then begin
    FCaptionLabel := TLabel.Create(Self);
    with FCaptionLabel do
    begin
      Parent := FPanel;
      Align := alClient;
      Caption := 'Panel Caption';
      Font.Style := [fsBold];
    end;  { CaptionLabel1 }
  end;

  AllignAttachedPanel();
  //Self.OnResize := Self.SetInitialHeight;
end;

destructor TGrtPanel.Destroy;
begin
  if Assigned(FExpandButton) then FreeAndNil(FExpandButton);
  if Assigned(FCaptionLabel) then FreeAndNil(FCaptionLabel);
  if Assigned(FPanel) then FreeAndNil(FPanel);
  inherited;
end;

function TGrtPanel.GetImage: TBitmap;
begin
  Result := FExpandButton.Glyph;
end;

function TGrtPanel.GetLabel: string;
begin
  Result := FCaptionLabel.Caption;
end;

procedure TGrtPanel.OnMyButtonClick(Sender: TObject);
begin

  if (FStatus = esExpanded) then begin
    if Assigned(FOnCollapse) then FOnCollapse(Self);
    FStatus := esCollapsed;
  end else begin
    if Assigned(FOnExpand) then FOnExpand(Self);
    FStatus := esExpanded;
  end;
  ResizePanel();
end;


procedure TGrtPanel.OnShowPanel(Sender: TObject);
begin
end;

procedure TGrtPanel.Paint;
begin
  inherited;
  if (Assigned(FExpandButton.Glyph) and (not FExpandButton.Glyph.Empty)) then
    FExpandButton.Caption := ''
  else
    FExpandButton.Caption := '6';
end;

//procedure TGrtPanel.SetInitialHeight(Sender: TObject);
//begin
//  // designtime
//  //  if csDesigning in TGrtPanel(Sender).ComponentState then begin
//  //    if (Self.Height > FPanel.Height) then begin
//  //      FHeight := Self.Height;
//  //      Trace('SetHeight: ' + IntToStr(FHeight));
//  //    end;
//  //  end;
//  AllignAttachedPanel();
//end;

procedure TGrtPanel.ResizePanel;
begin
  if not FAutoCollapse then Exit;

  if (FStatus = esExpanded) then begin
    Self.Height := FHeight;
  end else begin
    Self.Height := FPanel.Height;
  end;
  AllignAttachedPanel();
end;

procedure TGrtPanel.SetAttachedPanel(const AValue: TPanel);
begin
  FAttachedPanel := AValue;
  AllignAttachedPanel();
end;

procedure TGrtPanel.SetAutoCollapse(const AValue: boolean);
begin
  FAutoCollapse := AValue;
  ResizePanel();
end;

procedure TGrtPanel.SetHeight(AValue: integer);
begin
  FHeight := AValue;
end;

procedure TGrtPanel.SetImage(AValue: TBitmap);
begin
  FExpandButton.Glyph := AValue;
  if (Assigned(FExpandButton.Glyph) and (not FExpandButton.Glyph.Empty)) then
    FExpandButton.Caption := ''
  else
    FExpandButton.Caption := '6';
end;

procedure TGrtPanel.SetLabel(AValue: string);
begin
  FCaptionLabel.Caption := AValue;
end;

procedure TGrtPanel.SetOnCollapse(const AValue: TNotifyEvent);
begin
  FOnCollapse := AValue;
end;

procedure TGrtPanel.SetOnExpand(const AValue: TNotifyEvent);
begin
  FOnExpand := AValue;
end;

procedure TGrtPanel.SetStatus(const AValue: TEnumExpandStatus);
begin
  FStatus := AValue;
  if (FAutoCollapse) then ResizePanel();
end;



end.
