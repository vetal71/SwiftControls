unit DemoPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, GrtPanel, Grids, DBGrids,
  DBCtrls, Planner, pngimage;

type
  TForm1 = class(TForm)
    GrtPanel1: TGrtPanel;
    GrtPanel2: TGrtPanel;
    GrtPanel3: TGrtPanel;
    GrtPanel4: TGrtPanel;
    SpeedButton1: TSpeedButton;
    procedure panGrtCollapse(Sender: TObject);
    procedure panGrtExpand(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  //ShowMessage('Initial Height: ' + IntToStr(GrtPanel1.GrtHeightMin))
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GrtPanel1.GrtStatus := esCollapsed;
  GrtPanel2.GrtStatus := esCollapsed;
  GrtPanel3.GrtStatus := esCollapsed;
  GrtPanel4.GrtStatus := esCollapsed;
end;

procedure TForm1.panGrtCollapse(Sender: TObject);
begin
  //ShowMessage('Collapsed!');
  inherited;
end;

procedure TForm1.panGrtExpand(Sender: TObject);
begin
  //ShowMessage('Expanded!');
  inherited;
end;

end.
