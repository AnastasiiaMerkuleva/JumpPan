uses graphabc;

type point= record
        x,y: integer;
    end;

type
    tState = (MainMenu, Game, Setting, Inform, GameOver);
var 
   
    Left, Right: boolean;
    active: boolean;
    state : tState;
    
procedure MenuMouse (x, y, mb: integer);
begin
    if mb <> 1 then exit;
    if (x>200) and (x<340) and (y>165) and (y<190) then State := game;
    if (x>200) and (x<340) and (y>290) and (y<310) then State := setting;
    if (x>200) and (x<340) and (y>370) and (y<425) then State := inform;
    if (x>140) and (x<270) and (y>505) and (y<590) then active:= false ;
end;

procedure GameMouse (x, y, mb : integer; act: boolean );
begin
    if mb <> 1 then exit;       
    if (x>30) and (x<130) and (y>25) and (y<50) then State:= mainmenu
    else if (x<266) then Left:=act
    else Right:=act;
    
end;

procedure GameMouseUP (x, y, mb: integer);
begin
    GameMouse(x,y,mb, false );
end;

procedure GameMouseDown (x, y, mb: integer);
begin
    GameMouse(x,y,mb,true);
end;

procedure GameOverMouse (x, y, mb: integer);
begin
    if mb<> 1 then exit;
    if (x>140 ) and (x<235 ) and (y>350 ) and (y<470 ) then state := Game;
    if (x>320 ) and (x<400 ) and (y>350 ) and (y<470 ) then state := MainMenu;
end;    
    
procedure SettingMouse (x, y, mb: integer); 
begin
    if mb <> 1 then exit;
    if (x>330) and (x<420) and (y>600) and (y<620) then State:= mainmenu;
end;


procedure InformMouse (x, y, mb: integer);
begin
    if mb <> 1 then exit;
    if (x>330) and (x<420) and (y>600) and (y<620) then State := mainmenu;
end; 


procedure keyupGame(Key: integer);
begin
    if Key = VK_Left then Left := false;
    if key = VK_Right then Right := false;
end;
    
procedure keydownGame(Key: integer); 
begin
    if Key = VK_Left then Left := true;
    if key = VK_Right then Right := true;
end;

function menu : integer;
var menu: picture; 
        x, y, mb: integer;
begin   
    state:= MainMenu;
    menu := picture.create('data\menu.png');
    menu.draw(0,0);
    OnMouseUp := MenuMouse; 
end;

function games: integer;
var pot, platforma, background: picture;
    ex, ey, x, y, i, h, score: integer;
    vx, vy: real;
    platforms: array [1..20] of point;
    
begin 
    State := game;
    OnKeyDown := keydownGame;
    OnKeyUp:= keyupGame;
    OnMouseUp := GameMouseUP;
    OnMouseDown := GameMouseDown;
    pot := picture.create('data\pot.png');
    
    platforma := Picture.Create ('data\platforma.png');
    background := Picture.Create ('data\background.png');
    
    Left:=false;
    Right:=false;
    
     x := 266; y := 300; h:= 350;
    for i := 1 to 20 do begin
            platforms[i].x := Random(475);
            platforms[i].y :=Random(690);
    end; 
    
    
    while state = Game do begin
        
        background.Draw(0,0);
        pot.Draw(x,y);
        TextOut(400,10, score.ToString);
        for i := 1 to 20 do platforma.Draw(platforms[i].x, platforms[i].y);
        
        
        if Left=true then x := x-3;
        if Right=true then x := x+3;
        vy := vy+0.1;
        y:=y+Round(vy);
        for i :=1 to 20 do 
            if((x+45)>platforms[i].x) and ((x+14)<(platforms[i].x+55)) and ((y+47)>(platforms[i].y+14)) and ((y+47)<(platforms[i].y+27)) and (vy>0) then vy:=-7;
        if y<h then begin
            for i := 1 to 20 do begin
                y:=h;
                platforms[i].y := platforms[i].y- Round(vy);
                if platforms[i].y>690 then begin
                    platforms[i].y :=0;
                    platforms[i].x :=Random(475);
                end;
                
            end;
          
         score := score + 10;
             
        
            
        end;
        if x>532 then x:= 0; if x<0 then x:= 532;
        if y>690 then state:= GameOver;
        
        Redraw
    end;
end;

function GameOv: integer;
var gameoverpic: Picture;

begin
    state:= GameOver;
    gameoverpic:= Picture.Create('data\gameover.png');
    gameoverpic.Draw(0,0);
    OnMouseUp:= GameOverMouse;

end;    
    
    
    





begin
    window.caption := 'Кастрюлька-попрыгулька_v1.2';
    setwindowsize(532,690);
    Window.IsFixedSize := true;
    Window.Top :=5;
    LockDrawing;
    active:=true;
    
    while active= true do begin
    
        if state=MainMenu then menu()
        else if state = Game then games()
            else if state= GameOver then GameOv();
    
        Redraw;
   end;
   
   Halt;
end.    