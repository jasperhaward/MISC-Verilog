module ProgramCounter
(
	//Forms input and output variables
	input  logic							Clock,
	input	 logic							Reset,
	input  logic	signed	[15:0]	LoadValue,
	input  logic					  		LoadEnable,
	input  logic 	signed	[8:0]		Offset,
	input  logic							OffsetEnable,
	output logic	signed	[15:0]	CounterValue
  );
  
	//On every positive clock edge the loop is executed
	always_ff @(posedge Clock, posedge Reset)
	begin	
	
				if			  (Reset)			CounterValue <= '0;							//On high reset value, counter is set to 0
				else	if	(LoadEnable)		CounterValue <= LoadValue;					//Loadvalue is loaded into counter if LoadEnable is high
				else	if	(OffsetEnable)		CounterValue <= CounterValue + Offset; //Offset is added to the counter value if OffsetEnable is high
				else								CounterValue <= CounterValue + 1;		//Else counter is incrememented each clock cycle
				
	end
	
endmodule