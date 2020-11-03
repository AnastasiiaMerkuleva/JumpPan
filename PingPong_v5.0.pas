uses graphABC, ABCObjects;

type Command = (comUp, comDn, comNo);
     tStatus = (play,pause, gameEnd, loss, mainMenu);


type tPlayer= record
    y, x:integer;
    loss: integer;
    com: Command;
    left: boolean;
    end;

const playerV: integer =2; 

const PlayerHeight: integer =150;

const PlayerWidth: integer =10;

type tBall = record
    x,y,dy,dx: integer;
    end;

const ballV: integer = 2;

const ballr: integer = 15;
 
type tGame = record
   l, r: tPlayer;
   ball: tBall;
  // block: tBlock;
   active: boolean;
   status: tStatus;
   end;

const maxLoss: integer = 5;

procedure PlayerDrawAndMove (var player : tPlayer);
begin
    if player.left then player.x := 0
    else player.x := window.Width - PlayerWidth; 
    if player.com = comUp then player.y := player.y - playerV
    else if player.com = comDn then player.y :=  player.y + playerV;
    if player.y<0 then player.y := player.y - player.y
    else if player.y + PlayerHeight > window.Height then player.y := window.Height - PlayerHeight;
    rectangle (player.x, player.y,player.x+PlayerWidth,player.y+PlayerHeight);
end;

//procedure PlayerKey (var player : tPlayer; key: integer; down: boolean);  


procedure BallDraw (ball : tBall);  //отрисовка мяча 
var ballimage: picture; 
begin  
    if ball.dx <0 then ballimage := Picture.Create('data\leftball.png')
    else ballimage := Picture.Create('data\rightball.png');
    ballimage.draw(ball.x-ballr,ball.y-ballr);
end;

procedure GameBallMove ( var game: tGame);   //движение мяча
begin
    if ((game.ball.y + ballr) > window.Height) or ((game.ball.y - ballr) < 0) then game.ball.dy := -game.ball.dy;
    //столкновение с левым игроком
    if ((game.ball.y + ballr) > game.l.y) and ((game.ball.y - ballr) < (game.l.y+ (PlayerHeight div 3))) and ((game.ball.x - ballr) < (game.l.x + PlayerWidth)) then begin 
        game.ball.dx := -game.ball.dx;
        game.ball.dy := -ballV;
    end
    else if ((game.ball.y + ballr) > (game.l.y+(PlayerHeight div 3))) and ((game.ball.y - ballr) < (game.l.y+ 2*(PlayerHeight div 3))) and ((game.ball.x - ballr) < (game.l.x + PlayerWidth)) then begin 
        game.ball.dx := -game.ball.dx;
        game.ball.dy := 0;
    end
    else if ((game.ball.y + ballr) > (game.l.y+ 2*(PlayerHeight div 3))) and ((game.ball.y - ballr) < (game.l.y+PlayerHeight )) and ((game.ball.x - ballr) < (game.l.x + PlayerWidth)) then begin 
        game.ball.dx := -game.ball.dx;
        game.ball.dy := ballV;
    end
    else if ((game.ball.x - ballr) < game.l.x) then begin
        inc(game.l.loss);
        game.status := pause;
    end;
   
    //столкновение с правым игроком
    if ((game.ball.y + ballr) > game.r.y) and ((game.ball.y - ballr) < (game.r.y+ (PlayerHeight div 3))) and ((game.ball.x + ballr) > game.r.x ) then begin 
        game.ball.dx := -game.ball.dx;
        game.ball.dy := -ballV;
    end
    else if ((game.ball.y + ballr) > (game.r.y+(PlayerHeight div 3))) and ((game.ball.y - ballr) < (game.r.y+ 2*(PlayerHeight div 3))) and ((game.ball.x + ballr) > game.r.x) then begin 
        game.ball.dx := -game.ball.dx;
        game.ball.dy := 0;
    end
    else if ((game.ball.y + ballr) > (game.r.y+ 2*(PlayerHeight div 3))) and ((game.ball.y - ballr) < (game.r.y+PlayerHeight )) and ((game.ball.x + ballr) > game.r.x) then begin 
        game.ball.dx := -game.ball.dx;
        game.ball.dy := ballV;
    end
    else if ((game.ball.x + ballr) > (game.r.x+PlayerWidth)) then begin
        inc(game.r.loss);
        game.status := pause;
    end;
    game.ball.y := game.ball.y + game.ball.dy;
    game.ball.x := game.ball.x + game.ball.dx;

    


end;

procedure GameBallInit ( var game : tGame);   
begin
    if game.status = pause then begin
        game.ball.x := 0 + PlayerWidth + ballr;
        game.ball.y := window.Height div 2 - ballr div 2;
    end;
    game.ball.dy := ballv;
    game.ball.dx := ballv;
end;

//procedure Menu 

procedure GameEndPro ( game: tGame);
begin
    if game.l.loss = maxLoss then begin
        game.status := gameEnd;
        ClearWindow;
        writeln('Победил правый игрок');
        
    end
    else if game.r.loss = maxLoss then begin
        game.status := gameEnd;
        ClearWindow;
        writeln('Победил левый игрок');
    end;
end;

procedure GameInit ( game: tGame);
var background: picture;
begin
    background := Picture.Create ('data\background.png');
    background.Draw(0,0,WindowWidth,WindowHeight);
end;

procedure GameProcess (var game : tGame); 
begin
    PlayerDrawAndMove(game.l);
    PlayerDrawAndMove(game.r);
    GameEndPro(game);
    if game.status = pause then GameBallInit(game)
    else if game.status = play then GameBallMove(game);
    BallDraw(game.ball);
    
end;

var game: tGame;

procedure keyup (key: integer);
begin
    case key of
        VK_W: game.l.com := comNo;
        VK_S: game.l.com := comNo;
        VK_Up: game.r.com := comNo;
        VK_Down: game.r.com := comNo;
        VK_Space: game.status := play;
    end;       
end;

procedure keydown (key: integer); 
begin
    case key of
        VK_W: game.l.com := comUp;
        VK_S: game.l.com := comDn;
        VK_Up: game.r.com := comUp;
        VK_Down: game.r.com := comDn;
    end;
end;


procedure PlayerInit ( var p: tPlayer; left : boolean);
begin
    p.y := window.Height div 2-PlayerHeight div 2;
    p.com := comNo;
    p.left := left;
    p.loss := 0;    
end;

begin
    window.caption := 'Обыграй меня, если сможешь!';
    //MaximizeWindow;
    //window.IsFixedSize := true;
    window.Top :=5;
    window.Left := 250;
    LockDrawing; 
    OnKeyDown := keydown;
    OnKeyUp := keyup;
    game.status := pause;
    game.active:=true;
    
    
    PlayerInit(game.l, true);
    PlayerInit(game.r, false);
    GameBallInit(game);
    
    
    while game.active do begin
        LockDrawingObjects;
        ClearWindow;
        TextOut(10,10, game.l.loss.ToString);
        TextOut(WindowWidth- 20, 10, game.r.loss.ToString);
        GameProcess(game);
        RedrawObjects;
    end;
end.