
module leftbar
#(								
	LbLeft = 30,			//X position of left bar
	LbTop = 225,			//Y position of left bar
	sWidth = 800,			//Width of screen
	sHeight = 600,			//Height of screen
	oHeight = 150,			//Height of left bar
	oWidth = 50,			//Width of left bar
	yDirMove = 0			//Initial left bar y location
)
(
	input PixelClock, 			//Clock to display pixels
	input Reset,					//Reset val
	input UpL,						
	input DownL,
	input  logic [11:0] xPos,	//Stores X position 
	input  logic [11:0] yPos,	//Stores Y position 
	output logic drawLBar,		//Stores whether bar is drawn
	output logic [10:0] Ltop,
	output logic [10:0] Lbottom,
	output logic [10:0] Lright,
	output logic [10:0] Lleft
);
	
	
	logic ydir = yDirMove;	
	logic [10:0] LBarX = LbLeft;
	logic [10:0] LBarY = LbTop;


	assign Ltop = LBarY;						//Assigns heighest position of the left bar	
	assign Lbottom = LBarY + oHeight;	//Assigns lowest position of the left bar
	assign Lleft = LBarX;					//ASsigns left most position of the left bar
	assign Lright = LBarX + oWidth;		//Assigns right most position of the left bars
		
	always_ff @(posedge PixelClock)
	begin
	
		if( Reset == 1 )						//If reset switch is high, values are initialised
			begin									
				LBarY <= LbTop;
			end
			
		else
			begin
			
				if (UpL == 1 && DownL == 0 && LBarY<450)		//LBar is incremented if UpL is high and within parameter
					LBarY <= LBarY + 1;
				else if (UpL == 0 && DownL == 1 && LBarY>0)	//LBar is incremented down UpL is high and within parameter
					LBarY <= LBarY - 1;
				else
					LBarY <= LBarY; 
					
			end
	end


	//DrawLBar is high if the position counters are in the area of the LBar
	//otherwise LBar and Ball are not drawn
	assign drawLBar = ((xPos > Lleft) & (yPos > Ltop) & (xPos < Lright) & (yPos < Lbottom)) ? 1 : 0;
endmodule 