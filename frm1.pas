{
This project has been downloaded from:
http://lazplanet.blogspot.com
}
unit frm1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  EditBtn, Buttons, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnSave: TBitBtn;
    FileNameEdit1: TFileNameEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    Sel: TShape;
    procedure btnSaveClick(Sender: TObject);
    procedure FileNameEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2Paint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

  PrevX, PrevY: Integer;
  MouseIsDown: Boolean;

  Bmp2: TBitmap;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    MouseIsDown:=True;
    PrevX:=X;
    PrevY:=Y;
    Sel.Visible:=True;
    Image1MouseMove(Sender,Shift,X,Y);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Bmp2:=TBitmap.Create;

  Bmp2.Width:=Screen.Width;
  Bmp2.Height:=Screen.Height;

  Bmp2.Canvas.Brush.Color:=clWhite;
  Bmp2.Canvas.FillRect(0,0, Bmp2.Canvas.Width, Bmp2.Canvas.Height);
  // we trigger the OnPaint event to draw Bmp2
  Image2Paint(Sender);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Bmp2.Free;
end;

procedure TForm1.FileNameEdit1Change(Sender: TObject);
begin
  if FileExistsUTF8(FileNameEdit1.FileName) then
    Image1.Picture.LoadFromFile(FileNameEdit1.FileName);
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  SaveDialog1.Execute;
  if (SaveDialog1.FileName <> '') then
    bmp2.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown = true then begin
    Sel.SetBounds(prevx,prevy,X-prevx,y-prevy);
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  rect1, rect2: TRect;
  destwidth, destheight: Integer;
begin
  MouseIsDown:=False;
  Sel.Visible:=False;
  // if we do not refresh, then the Sel will
  // be also drawn !
  Image1.Refresh;

  // we keep width and height in variables
  // because we will need it many times
  destwidth:=X-PrevX;
  destheight:=Y-PrevY;

  //// We prepare 2 rects for cropping ////
  // Destination rectangle
  // ...where the cropped image would be drawn
  with rect1 do begin
    Left:=0;
    Top:=0;
    Right:=Left+destwidth;
    Bottom:=Top+destheight;
  end;

  // Source rectangle
  // ...where we crop from
  with rect2 do begin
    Left:=PrevX;
    Top:=PrevY;
    Right:=Left+destwidth;
    Bottom:=Top+destheight;
  end;

  // we do the actual drawing
  Bmp2.Canvas.CopyRect(rect1, Image1.Canvas, rect2);
  Bmp2.SetSize(destwidth, destheight);
  Image2.SetBounds(0,0,destwidth,destheight);

  Image2Paint(Sender);
end;

procedure TForm1.Image2Paint(Sender: TObject);
begin
  Image2.Canvas.Draw(0,0,Bmp2);
end;

end.

