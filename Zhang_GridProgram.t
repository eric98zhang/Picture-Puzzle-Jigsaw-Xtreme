/* Eric Zhang's Grid Program! Started April 7, 2015. Written in Open Turing.
For some reason, the game loads faster if you minimize the output window then bring it back out again.
*/

View.Set("graphics:900;600,offscreenonly")

%declaration area of stuff
type gridSQ :
    record 
	X : int
	Y : int
	TileNum : int
	img : int
    end record

type XYcordNote :
    record
	X : int
	Y : int
	used : boolean
	img : int
    end record

var MaxX,MaxY,table,table1,pic,Mx,My,Mbutton,diff,loadingbar : int := 0
var ch : string(1)
var Char : array char of boolean
var bool,bool1 : boolean := false
var XYs : array 1 .. 6 of int

var MGlarge : int := Font.New ("Malgun Gothic:32")
var MGMID : int := Font.New ("Malgun Gothic:24")
var MGmid : int := Font.New ("Malgun Gothic:17")
var MGSMALL : int := Font.New ("Malgun Gothic:12")

var MGiblarge : int := Font.New ("Malgun Gothic:48:bold,italic")

var BAlarge : int := Font.New ("Book Antiqua:56")

%ClickToCont procedure, as seen in Zhang_Lottery (somewhat modified)
procedure ClickToCont
    var CTCshade : int
    const CTCx : int := 590
    const CTCy : int := 15
    const CTCfont : int := MGmid
    const CTCfontheight : int := 17
    const CTCmsg : string := "Press any key to continue..."
    
    loop
	for i : -24 .. 24
	    CTCshade := RGB.AddColour(abs(i)/31,abs(i)/31,abs(i)/31) %because of the for loop values, the shade goes black --> dark grey --> light grey --> dark grey --> black
	    drawfillbox(CTCx - 2,CTCy - round(0.5*CTCfontheight),CTCx + Font.Width(CTCmsg,CTCfont) + 2,CTCy + CTCfontheight,white) %draw over the previous Font.Draw
	    Font.Draw(CTCmsg,CTCx,CTCy,CTCfont,CTCshade) %draw the thing using shade as colour
	    View.UpdateArea(CTCx - 2,CTCy - 2,CTCx + Font.Width(CTCmsg,CTCfont) + 2,CTCy + CTCfontheight + 2)
	    delay(35)
	    exit when hasch
	end for
	exit when hasch
    end loop
    getch(ch) %clear hasch
    cls
end ClickToCont

%CenterFontDraw procedure. Font.Draws stuff so that it is centered by x coordinate
procedure CenterFontDraw (text : string,yvalue,font,fontclr : int)
    Font.Draw(text,(maxx - Font.Width(text,font)) div 2,yvalue,font,fontclr)
end CenterFontDraw

table := Pic.Scale(Pic.FileNew("Pictures/CatPic1.bmp"),400,250)

%TypeInColumn procedure, as seen in Zhang_Lottery
procedure TypeInColumn (text:string,x1,x2,y1,lineheight,font,clr:int)
    var loopcount := 0  %loopcount is reset
    var PrevCharPosition,loopcount2,loopcount3 : int := 1   %variables are declared to store character positions
    var bool : boolean := false %a boolean var to allow for exiting 2 loops where one is inside the other
    
    loop    %first loop
	loop    %second loop
	    if Font.Width(text(PrevCharPosition .. loopcount2),font) > (x2 - x1) then   %if the width of the string exceeds the column width then...
		for decreasing i : loopcount2 .. PrevCharPosition   %search happens in the charactes that can fit in one line
		    if text(i) = " " then   %if a space is found then...
			loopcount2 := i - 1 %loopcount2 saved as the character position before the space
			bool := true    %preparation to exit back into the first loop    
			Font.Draw(text(PrevCharPosition .. loopcount2),x1,y1 - loopcount * lineheight,font,clr)        
			loopcount2 += 2 %loopcount2 moved to the character position after the space
			exit    %exit the for loop
		    elsif i = PrevCharPosition then %if no space is found within the characters that can fit on the line...
			Font.Draw(text(PrevCharPosition .. loopcount2),x1,y1 - loopcount * lineheight,font,clr) %everything that can fit on the line is drawn
			loopcount2 += 1 %loopcount2 moved to the next character
			bool := true    %preparation to exit back into the first loop                 
			exit    %exit the for loop
		    end if
		end for  
	    elsif Font.Width(text(PrevCharPosition .. length(text)),font) < (x2 - x1) then  %if what hasn't been written yet can all fit in one line then...
		Font.Draw(text(PrevCharPosition .. length(text)),x1,y1 - loopcount * lineheight,font,clr)   %... it gets drawn
		bool := true    %preparation to exit all loops of this procedure
		exit    %exits the second loop
	    end if
	    
	    if bool = true then %when bool is true...
		bool := false   %reset to false
		exit    %exit to first loop
	    end if

	    loopcount2 += 1 %loopcount2 increased by 1 for the next loop
	end loop
	
	if bool = true then %if bool is true...
	    bool := false   %bool is reset
	    exit    %exits the first loop and procedure completes
	end if

	PrevCharPosition := loopcount2
	loopcount += 1
    end loop 
end TypeInColumn

%Opening Screen
CenterFontDraw("Picture Puzzle Jigsaw!",400,BAlarge,7)
View.Update

delay(600)

%moves the word "XTREME" across screen (animation)
for i : 1 .. 45
    drawfillbox(0,360,maxx,290,white)
    Font.Draw("XTREME",i*10 - Font.Width("XTREME",MGiblarge) div 2,300,MGiblarge,7)
    delay(15)
    View.Update
end for

delay(1000)

%CatPic1 sliding across the screen animation
for i : 1 .. 40
    drawfillbox(0,0,400,250,white)
    Pic.Draw(table,10*i - 400,0,picCopy)
    View.Update
    delay(20)
end for

Pic.Free(table)

ClickToCont

%level selection screen
loop
    %Draws stuff
    cls
    CenterFontDraw("Level Selection",530,MGlarge,7)
    Font.Draw("Easy",maxx div 4 - Font.Width("Easy",MGMID) div 2 + 25,480,MGMID,7)
    Font.Draw("Normal",3*maxx div 4 - Font.Width("Normal",MGMID) div 2 - 25,480,MGMID,7)
    Font.Draw("Hard",maxx div 4 - Font.Width("Hard",MGMID) div 2 + 25,240,MGMID,7)
    Font.Draw("Lunatic",3*maxx div 4 - Font.Width("Lunatic",MGMID) div 2 - 25,240,MGMID,7)
    Font.Draw("How To Play",maxx - 7 - Font.Width("How To Play",MGmid),10,MGmid,7)
    drawbox(maxx - 12 - Font.Width("How To Play",MGmid),2,maxx - 2,32,7)
    Pic.Draw(Pic.Scale(Pic.FileNew("Pictures/CatPic1.bmp"),287,180),maxx div 4 - 119,285,picCopy)
    Pic.Draw(Pic.Scale(Pic.FileNew("Pictures/CatPic1.bmp"),287,180),3*maxx div 4 - 169,285,picCopy)
    Pic.Draw(Pic.Scale(Pic.FileNew("Pictures/Pic2.bmp"),287,180),maxx div 4 - 119,45,picCopy)
    Pic.Draw(Pic.Scale(Pic.FileNew("Pictures/Pic2.bmp"),287,180),3*maxx div 4 - 169,45,picCopy)
    View.Update

    %difficulty selection
    bool := false
    loop
	mousewhere(Mx,My,Mbutton)
	if hasch then
	    getch(ch)
	    if ord(ch) = 203 then %if left arrow key then easy mode
		diff := 1
		exit
	    elsif ord(ch) = 208 then %down arrow key = medium mode
		diff := 2
		exit
	    elsif ord(ch) = 200 then %up arrow key = hard mode
		diff := 3
		exit
	    elsif ord(ch) = 205 then %right arrow key = extreme mode
		diff := 4
		exit
	    end if
	elsif Mbutton = 1 then %if you click on the picture under the difficulty titles then that difficulty is selected
	     if Mx > 106 and Mx < 393 and My > 285 and My < 510 then
		diff := 1
		exit
	    elsif Mx > 506 and Mx < 792 and My > 285 and My < 510 then
		diff := 2
		exit
	    elsif Mx > 106 and Mx < 393 and My > 45 and My < 225 then
		diff := 3
		exit
	    elsif Mx > 506 and Mx < 792 and My > 45 and My < 225 then
		diff := 4
		exit
	    elsif Mx > maxx - 12 - Font.Width("How To Play",MGmid) and Mx < maxx - 2 and My > 2 and My < 32 then
		bool := true
		cls
		Font.Draw("How to play",maxx div 2 - Font.Width("How to play",MGlarge) div 2,maxy - 80,MGlarge,7)
		TypeInColumn("Welcome to Picture Puzzle Jigsaw Xtreme!",80,maxx - 80,maxy - 150,21,MGSMALL,7)
		TypeInColumn("A picture has been cut into tiles and scrambled in the playing area. You must unscramble the picture. The tile from the upper right hand corner of the picture has been removed, allowing you to slide tiles around the playing area.",80,maxx - 80,maxy - 191,21,MGSMALL,7)
		TypeInColumn("Press the up arrow key to move the tile below the empty space up into the empty space. The down arrow key moves the tile above the empty space down. This works as well for the left and right arrow keys.",80,maxx - 80,maxy - 275,21,MGSMALL,7)
		TypeInColumn("Hold the spacebar down to view what the unscrambled picture should look like. The game ends when the picture has been fully unscrambled.",80,maxx - 80,maxy - 359,21,MGSMALL,7)
		Font.Draw("Good luck!",maxx div 2 - Font.Width("Good luck!",MGlarge) div 2,120,MGlarge,7)
		View.Update
		ClickToCont
		exit
	    end if
	end if
    end loop
    exit when bool = false
end loop

%assigning values based on selected difficulty
if diff = 1 then
    MaxX := 3
    MaxY := 2
    pic := Pic.FileNew("Pictures/CatPic1.bmp")
elsif diff = 2 then
    MaxX := 4
    MaxY := 3
    pic := Pic.FileNew("Pictures/CatPic1.bmp")
elsif diff = 3 then
    MaxX := 8
    MaxY := 5
    pic := Pic.FileNew("Pictures/Pic2.bmp")
elsif diff = 4 then
    MaxX := 16
    MaxY := 10
    pic := Pic.FileNew("Pictures/Pic2.bmp")
end if

%-----------------------------------------------------------------------------------------------------------------------------    
var Tile : array 1 .. MaxX, 1 .. MaxY of gridSQ %2D array declared based on the difficulty
var XYcheck : array 1 .. MaxX*MaxY of XYcordNote %1D array declared based on the difficulty
var note1,note2,tableXY : XYcordNote

%DrawTiles procedure - draws all the tiles. This procedure had to be declared after the Tiles were declared
procedure DrawTiles
    for y : 1 .. MaxY
	for x : 1 .. MaxX
	    if Tile(x,y) .X not= MaxX or Tile(x,y) .Y not= MaxY then
		Pic.Draw(Tile(x,y) .img,(x - 1)*(800 div MaxX) + 50,(y - 1)*(500 div MaxY) + 50,picCopy)
	    end if
	end for
    end for
    
    drawbox(51,51,849,549,7)
    drawbox(50,50,850,550,7) %these drawboxes make a nice border for the playing area
    drawbox(49,49,851,551,7)
    
end DrawTiles

Pic.Draw(pic,49,49,picCopy) %image is put on the screen so that it can be cut up

%set of for loops that cuts up the picture and assigns a piece of the picture to each Tile. Also assigns the X and Y values for each Tile
for y : 1 .. MaxY
    for x : 1 .. MaxX
	Tile(x,y) .TileNum := (y - 1)*MaxX + x
	Tile(x,y) .X := x
	Tile(x,y) .Y := y
	Tile(x,y) .img := Pic.New((x - 1)*(800 div MaxX) + 50,(y - 1)*(500 div MaxY) + 50,x*(800 div MaxX) + 50,y*(500 div MaxY) + 50)
    end for
end for

%loop to fill XYcheck
for i : 1 .. MaxX*MaxY
    XYcheck(i) .X := ((i - 1) mod MaxX) + 1 %assigns numbers from 1 to MaxX
    XYcheck(i) .Y := (i - (((i - 1) mod MaxX) + 1)) div MaxX + 1 %assigns numbers from 1 to MaxY
    XYcheck(i) .used := false
    XYcheck(i) .img := Tile(XYcheck(i) .X,XYcheck(i) .Y) .img %XYcheck with some .X and .Y value will have the same img as the Tile with the same .X and .Y
end for

cls
%stuff for the loading screen
CenterFontDraw("Loading...",300,MGlarge,7)
drawbox(148,98,752,122,black)

%This scrambles the tiles in such a way that it is still possible to complete the puzzle (it just does a bunch of random moves).
for i : 1 .. MaxX*MaxX*MaxY*MaxY
    randint(table,1,4) %randomly generate a num from 1 to 4 to decide which of four moves to attempt
    View.Update
    %loadingbar code
    if i mod MaxX*MaxX*MaxY*MaxY = 0 then
	drawfillbox(150,100,150 + round(i*600/(MaxX*MaxX*MaxY*MaxY)),120,black)
	View.Update
    end if
    if table = 1 then %empty tile is swapped with the tile beneath it
	for y : 2 .. MaxY %y = 1 is not considered since Tile(x,1) cannot be swapped with the nonexistant (Tilex,0)
	    for x : 1 .. MaxX
		if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then %the swapping happens below
		    tableXY .X := Tile(x,y) .X %.X value swap
		    tableXY .Y := Tile(x,y) .Y %.Y value swap
		    tableXY .img := Tile(x,y) .img %.img swap
		    Tile(x,y) .X := Tile(x,y - 1) .X
		    Tile(x,y) .Y := Tile(x,y - 1) .Y
		    Tile(x,y) .img := Tile(x,y - 1) .img
		    Tile(x,y - 1) .X := tableXY .X
		    Tile(x,y - 1) .Y := tableXY .Y
		    Tile(x,y - 1) .img := tableXY .img
		    bool := true
		    exit
		end if
	    end for
	    if bool = true then
		bool := false
		exit
	    end if
	end for
    elsif table = 2 then %empty tile swapped with tile to its right
	for y : 1 .. MaxY
	    for x : 1 .. MaxX - 1 % x = MaxX not considered since Tile(MaxX,y) cannot be swapped with the nonexistant Tile(MaxX +1,y)
		if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then
		    tableXY .X := Tile(x,y) .X
		    tableXY .Y := Tile(x,y) .Y
		    tableXY .img := Tile(x,y) .img
		    Tile(x,y) .X := Tile(x + 1,y) .X
		    Tile(x,y) .Y := Tile(x + 1,y) .Y
		    Tile(x,y) .img := Tile(x + 1,y) .img
		    Tile(x + 1,y) .X := tableXY .X
		    Tile(x + 1,y) .Y := tableXY .Y
		    Tile(x + 1,y) .img := tableXY .img
		    bool := true
		    exit
		end if
	    end for
	    if bool = true then
		bool := false
		exit
	    end if
	end for
    elsif table = 3 then %empty tile swapped with tile to its left
	for y : 1 .. MaxY
	    for x : 2 .. MaxX %x = 1 not considered since Tile(1,y) cannot be swapped with the nonexistant Tile(0,y)
		if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then
		    tableXY .X := Tile(x,y) .X
		    tableXY .Y := Tile(x,y) .Y
		    tableXY .img := Tile(x,y) .img
		    Tile(x,y) .X := Tile(x - 1,y) .X
		    Tile(x,y) .Y := Tile(x - 1,y) .Y
		    Tile(x,y) .img := Tile(x - 1,y) .img
		    Tile(x - 1,y) .X := tableXY .X
		    Tile(x - 1,y) .Y := tableXY .Y
		    Tile(x - 1,y) .img := tableXY .img
		    bool := true
		    exit
		end if
	    end for
	    if bool = true then
		bool := false
		exit
	    end if
	end for
    elsif table = 4 then %empty tile swapped with tile above it
	for y : 1 .. MaxY - 1 %y = MaxY not considered since Tile(x,MaxY) cannot be swapped with the nonexistant Tile(x,MaxY + 1)
	    for x : 1 .. MaxX
		if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then
		    tableXY .X := Tile(x,y) .X
		    tableXY .Y := Tile(x,y) .Y
		    tableXY .img := Tile(x,y) .img
		    Tile(x,y) .X := Tile(x,y + 1) .X
		    Tile(x,y) .Y := Tile(x,y + 1) .Y
		    Tile(x,y) .img := Tile(x,y + 1) .img
		    Tile(x,y + 1) .X := tableXY .X
		    Tile(x,y + 1) .Y := tableXY .Y
		    Tile(x,y + 1) .img := tableXY .img
		    bool := true
		    exit
		end if
	    end for
	    if bool = true then
		bool := false
		exit
	    end if
	end for
    end if
end for

cls
DrawTiles
View.Update
table := 0

%allows the user to move the tiles around and determines when the game is won
loop    
    if hasch then %detect key press
	getch(ch) %record it
	if ord(ch) = 200 then %if it's the up arrow key then Tile below empty slot moves up. Swap happens using the same code as in the scrambling part
	    for y : 2 .. MaxY
		for x : 1 .. MaxX
		    if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then
			tableXY .X := Tile(x,y) .X
			tableXY .Y := Tile(x,y) .Y
			tableXY .img := Tile(x,y) .img
			Tile(x,y) .X := Tile(x,y - 1) .X
			Tile(x,y) .Y := Tile(x,y - 1) .Y
			Tile(x,y) .img := Tile(x,y - 1) .img
			Tile(x,y - 1) .X := tableXY .X
			Tile(x,y - 1) .Y := tableXY .Y
			Tile(x,y - 1) .img := tableXY .img
			bool := true
			exit
		    end if
		end for
		if bool = true then
		    bool := false
		    exit
		end if
	    end for
	elsif ord(ch) = 203 then %if it's the left arrow key then Tile right of empty slot moves left.
	    for y : 1 .. MaxY
		for x : 1 .. MaxX - 1
		    if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then
			tableXY .X := Tile(x,y) .X
			tableXY .Y := Tile(x,y) .Y
			tableXY .img := Tile(x,y) .img
			Tile(x,y) .X := Tile(x + 1,y) .X
			Tile(x,y) .Y := Tile(x + 1,y) .Y
			Tile(x,y) .img := Tile(x + 1,y) .img
			Tile(x + 1,y) .X := tableXY .X
			Tile(x + 1,y) .Y := tableXY .Y
			Tile(x + 1,y) .img := tableXY .img
			bool := true
			exit
		    end if
		end for
		if bool = true then
		    bool := false
		    exit
		end if
	    end for
	elsif ord(ch) = 205 then %if it's the right arrow key then Tile left of empty slot moves right.
	    for y : 1 .. MaxY
		for x : 2 .. MaxX
		    if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then
			tableXY .X := Tile(x,y) .X
			tableXY .Y := Tile(x,y) .Y
			tableXY .img := Tile(x,y) .img
			Tile(x,y) .X := Tile(x - 1,y) .X
			Tile(x,y) .Y := Tile(x - 1,y) .Y
			Tile(x,y) .img := Tile(x - 1,y) .img
			Tile(x - 1,y) .X := tableXY .X
			Tile(x - 1,y) .Y := tableXY .Y
			Tile(x - 1,y) .img := tableXY .img
			bool := true
			exit
		    end if
		end for
		if bool = true then
		    bool := false
		    exit
		end if
	    end for
	elsif ord(ch) = 208 then %if it's the down arrow key then Tile above empty slot moves down.
	    for y : 1 .. MaxY - 1
		for x : 1 .. MaxX
		    if Tile(x,y) .X = MaxX and Tile(x,y) .Y = MaxY then
			tableXY .X := Tile(x,y) .X
			tableXY .Y := Tile(x,y) .Y
			tableXY .img := Tile(x,y) .img
			Tile(x,y) .X := Tile(x,y + 1) .X
			Tile(x,y) .Y := Tile(x,y + 1) .Y
			Tile(x,y) .img := Tile(x,y + 1) .img
			Tile(x,y + 1) .X := tableXY .X
			Tile(x,y + 1) .Y := tableXY .Y
			Tile(x,y + 1) .img := tableXY .img
			bool := true
			exit
		    end if
		end for
		if bool = true then
		    bool := false
		    exit
		end if
	    end for
	elsif ord(ch) = 32 then %during gameplay, when the spacebar is held, the solved picture is displayed
	    Pic.Draw(pic,49,49,picCopy)
	    View.Update
	    loop
		Input.KeyDown(Char)
		exit when Char (' ') = false
	    end loop
	end if
	cls
	DrawTiles
	View.Update
    end if       
    
    %win detection. When the .X and .Y of each Tile matches the x and y of Tile(x,y), a win is declared
    for y : 1 .. MaxY
	for x : 1 .. MaxX
	    if Tile(x,y) .X not= x or Tile(x,y) .Y not= y then
		bool := true
		exit
	    end if
	end for
	exit when bool = true
    end for
    if bool = true then
	bool := false
    elsif bool = false then
	ClickToCont
	exit
    end if
end loop

%ending screen
Pic.Draw(pic,49,49,picCopy) %draws the pic

%fades in Font.Draw "Congratulations!"
for decreasing i : 63 .. 0
    table := RGB.AddColour(abs(i)/63,abs(i)/63,abs(i)/63)
    drawfillbox(0,0,maxx,48,white)
    CenterFontDraw("Congratulations!",10,MGlarge,table)
    View.Update
    delay(20)
end for
