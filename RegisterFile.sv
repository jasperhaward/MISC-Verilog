module RegisterFile
(
	//Forms input and output variables
	input	 logic							Clock,
	input  logic 				[5:0]		AddressA,
	input  logic 				[15:0]	WriteData,
	input  logic 							WriteEnable,
	input  logic 				[5:0]		AddressB,
	output logic 				[15:0]	ReadDataA,
	output logic 				[15:0]	ReadDataB
  );
	
	
	logic [15:0] Registers [64]; //Instantiates the register array
		
	assign ReadDataA = Registers[AddressA];	//Assigns data from AddressA to ReadDataA
	assign ReadDataB = Registers[AddressB];	//Assigns data from AddressB to ReadDataB

	//On every positive clock edge the loop is executed
	always_ff @(posedge Clock)
	begin 
			if (WriteEnable)		Registers[AddressA] <= WriteData;				//Assigns input WriteData to AddressA when WriteEnable is high
			else						Registers[AddressA] = Registers[AddressA];	//Else AddressA retains same information
	end
			
endmodule


OutDest = {InDest*InSrc}[15:0];