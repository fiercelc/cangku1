unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Media, FMX.StdCtrls,
  FMX.ListBox, FMX.Layouts;

type
  TForm1 = class(TForm)
    videoBtn: TButton;
    MediaPlayer1: TMediaPlayer;
    ToolBar1: TToolBar;
    Label1: TLabel;
    tbNowPlaying: TToolBar;
    lyState: TLayout;
    btnPlay: TButton;
    btnPause: TButton;
    Layout5: TLayout;
    tbProgress: TTrackBar;
    Label_now: TLabel;
    Label_all: TLabel;
    SettingsList: TListBox;
    VolumeHeader: TListBoxGroupHeader;
    VolumeListItem: TListBoxItem;
    VolumeTrackBar: TTrackBar;
    Timer1: TTimer;
    procedure videoBtnClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure VolumeTrackBarChange(Sender: TObject);
    procedure tbProgressChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.iOUtils;

type
  TOpenMedia = class(TMedia);

procedure TForm1.btnPauseClick(Sender: TObject);
begin
  MediaPlayer1.Stop;
  Timer1.Enabled := false;
  btnPlay.Enabled := true;
  btnPause.Enabled := false;
end;

procedure TForm1.btnPlayClick(Sender: TObject);
begin
  MediaPlayer1.FileName := TPath.GetDocumentsPath + '/feng.mp3';
  MediaPlayer1.CurrentTime :=
    trunc((tbProgress.Value * MediaPlayer1.Duration) / 100);
    MediaPlayer1.Volume := VolumeTrackBar.Value;
  MediaPlayer1.Play;
  Timer1.Enabled := true;
  btnPlay.Enabled := false;
  btnPause.Enabled := true;
end;

procedure TForm1.tbProgressChange(Sender: TObject);
begin
  MediaPlayer1.CurrentTime :=
    trunc((tbProgress.Value * MediaPlayer1.Duration) / 100);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  handler: TNotifyEvent;
begin
  handler := tbProgress.OnChange;
  tbProgress.OnChange := nil;
  tbProgress.Value :=
    int((MediaPlayer1.CurrentTime / MediaPlayer1.Duration) * 100);

  Label_now.Text := inttostr(trunc(MediaPlayer1.CurrentTime / 60000)) + ':' +
    inttostr(trunc(MediaPlayer1.CurrentTime / 1000 -
    trunc(MediaPlayer1.CurrentTime / 60000) * 60));
  Label_all.Text := inttostr(trunc(MediaPlayer1.Duration / 60000)) + ':' +
    inttostr(trunc(MediaPlayer1.Duration / 1000 - trunc(MediaPlayer1.Duration /
    60000) * 60));

  tbProgress.OnChange := handler;

  // 播放完毕后的处理
  if MediaPlayer1.CurrentTime >= MediaPlayer1.Duration - 1000 then
  begin
    MediaPlayer1.Stop;
    tbProgress.Value:=0;
    btnPlay.Enabled := true;
    btnPause.Enabled := false;
    Timer1.Enabled := false;
  end;
end;

procedure TForm1.videoBtnClick(Sender: TObject);
begin
  MediaPlayer1.FileName := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath)
    + 'Ocean.mp4';
    MediaPlayer1.Play;
end;

procedure TForm1.VolumeTrackBarChange(Sender: TObject);
begin
  MediaPlayer1.Volume := VolumeTrackBar.Value;
end;

end.
