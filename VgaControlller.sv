module VgaController
(
	input		logic 			Clock,
	input		logic				Reset,
	output	logic				blank_n,
	output	logic				sync_n,
	output	logic				hSync_n,
	output	logic 			vSync_n,
	output	logic	[11:0]	nextX,
	output	logic	[11:0]	nextY
);

		//Counter signal for the horizontal axis 
		logic [11:0] hCount;

		//Counter signal for the vertical axis
		logic [11:0] vCount;
	
		
		assign hSync_n = hCount < (800 + 56) || hCount >= (800 + 56 + 120);	//hSync and vSync are high except when vCount or hCount are in sync pulse
		assign vSync_n = vCount < (600 + 37) || vCount >= (600 + 37 + 6);
		
		assign nextX = (hCount < 800)? hCount : nextX;		//If hCount or Vcount are in visible area, nextX = hCount
		assign nextY = (vCount < 600)? vCount : nextY;		//and nextY = vCount, else no change
		
		assign blank_n = (vCount <= 600 || hCount <= 800); //blank_n signal is high if vCount or hCount is in visible area
		assign sync_n 	= hCount < (800 + 56) || hCount >= (800 + 56 + 120) || vCount < (600 + 37) || vCount >= (600 + 37 + 6); 
		//sync_n signal is high except when vCount or hCount are in sync pulse
		
		//Loop executed on each clock cycle
		always_ff @(posedge Clock)
		begin
		
				if	(Reset)	//If reset is high, hCount and vCount are set to high value
					begin
					vCount <= 1;
					hCount <= 1;
					end
					
				else if (hCount >= 1040) //If hCount is outside of the boundary, hCount is set to high and vCount is incremented
					begin
					hCount <= 1;
					vCount <= vCount + 1;
					end
					
				else if (vCount >= 666)	 //If vCount is outside of the boundary, vCount is set to high
					vCount <= 1;	
					
				else
					hCount <= hCount + 1; //Else hCount is incremented
						
		end
		
endmodule