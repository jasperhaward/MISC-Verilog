
module rightbar
#(				
	RbLeft = 720,			//X position of right bar
	RbTop = 225,			//Y position of right bar
	oHeight = 150,			//Height of right bar
	oWidth = 50,			//Width of right bar
	sWidth = 800,			//Width of screen
	sHeight = 600,			//Height of screen
	yDirMove = 0			//Initial Right bar y location
)
(
	input PixelClock, 			//Clock to display pixels
	input Reset,
	input UpR,
	input DownR,
	input  logic [11:0] xPos,	//Stores X position 
	input  logic [11:0] yPos,	//Stores Y position 
	output logic drawRBar,		//Stores whether bar is drawn
	output logic [10:0] Rtop,
	output logic [10:0] Rbottom,
	output logic [10:0] Rleft,
	output logic [10:0] Rright
);

	
	logic ydir = yDirMove;	
	logic [10:0] RBarX = RbLeft;
	logic [10:0] RBarY = RbTop;


	assign Rtop = RBarY;						//Assigns heighest position of the right bar	
	assign Rbottom = RBarY + oHeight;	//Assigns lowest position of the right bar
	assign Rleft = RBarX;					//ASsigns left most position of the right bar
	assign Rright = RBarX + oWidth;		//Assigns right most position of the right bar
		
	always_ff @(posedge PixelClock)
	begin
	
		if( Reset == 1 )						//If reset switch is high, values are initialised
			begin									
				RBarY <= RbTop;
			end
			
		else
			begin
			
				if (UpR == 1 && DownR == 0 && RBarY<450)		//RBar is incremented if UpR is high and within parameter
					RBarY <= RBarY + 1;
				else if (UpR == 0 && DownR == 1 && RBarY>0)	//RBar is incremented down UpR is high and within parameter
					RBarY <= RBarY - 1;
				else
					RBarY <= RBarY; 
					
			end
	end


	//DrawRBar is high if the position counters are in the area of the RBar
	//otherwise LBar and Ball are not drawn
	assign drawRBar = ((xPos > Rleft) & (yPos > Rtop) & (xPos < Rright) & (yPos < Rbottom)) ? 1 : 0;
endmodule 