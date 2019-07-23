// ArithmeticLogicUnit
// This is a basic implementation of the essential operations needed
// in the ALU. Adding futher instructions to this file will increase 
// your marks.

// Load information about the instruction set. 
import InstructionSetPkg::*;

// Define the connections into and out of the ALU.
module ArithmeticLogicUnit
(
	// The Operation variable is an example of an enumerated type and
	// is defined in InstructionSetPkg.
	input eOperation Operation,
	
	// The InFlags and OutFlags variables are examples of structures
	// which have been defined in InstructionSetPkg. They group together
	// all the single bit flags described by the Instruction set.
	input  sFlags    InFlags,
	output sFlags    OutFlags,
	
	// All the input and output busses have widths determined by the 
	// parameters defined in InstructionSetPkg.
	input  signed [ImmediateWidth-1:0] InImm,
	
	// InSrc and InDest are the values in the source and destination
	// registers at the start of the instruction.
	input  signed [DataWidth-1:0] InSrc,
	input  signed [DataWidth-1:0]	InDest,
	
	// OutDest is the result of the ALU operation that is written 
	// into the destination register at the end of the operation.
	output logic signed [DataWidth-1:0] OutDest
);

	// This block allows each OpCode to be defined. Any opcode not
	// defined outputs a zero. The names of the operation are defined 
	// in the InstructionSetPkg. 
	always_comb
	begin
	
		// By default the flags are unchanged. Individual operations
		// can override this to change any relevant flags.
		OutFlags  = InFlags;
		
		// The basic implementation of the ALU only has the NAND and
		// ROL operations as examples of how to set ALU outputs 
		// based on the operation and the register / flag inputs.
		case(Operation)		
		
			ROL:     {OutFlags.Carry,OutDest} = {InSrc,InFlags.Carry};	
			
			NAND:    OutDest = ~(InSrc & InDest);

			LIU:
				begin
				
					if (InImm[ImmediateWidth - 1] ==  1)
						OutDest = {InImm[ImmediateWidth - 2:0], InDest[ImmediateHighStart - 1:0]};
					else if  (InImm[ImmediateWidth - 1] ==  0)	
						OutDest = $signed({InImm[ImmediateWidth - 2:0], InDest[ImmediateMidStart - 1:0]});
					else
						OutDest = InDest;	
				end


			// ***** ONLY CHANGES BELOW THIS LINE ARE ASSESSED *****
			
			MOVE:		OutDest = InSrc;												//Assigns InSrc to OutDest
			
			NOR:		OutDest = ~(InSrc | InDest);								//OutDest equal to logical bitwise Nor of InSrc and InDest
				
			ROR:		{OutDest,OutFlags.Carry} = {InFlags.Carry,InSrc};	//Performs opposite of ROL
			
			LIL:		OutDest = $signed(InImm);									//Performs sign extension of InImm
				
			ADC: 		
				begin 
				
					{OutFlags.Carry, OutDest} = InDest + InSrc + InFlags.Carry;	//Completes Addition including Input carry flag, and sets Output carry flag
					
					if (OutDest == 0)
						OutFlags.Zero = 1;	//If OutDest is zero value, Output flag zero is high, else low
					else
						OutFlags.Zero = 0;
					
					if (OutDest[DataWidth-2] == 1 && InSrc[DataWidth-2]== 0 && InDest[DataWidth-2] == 0)	//If OutDest and Input values cause overflow (table 5), Output flag overflow is high, else low
						OutFlags.Overflow = 1;
					else if (OutDest[DataWidth-2] == 0 && InSrc[DataWidth-2]== 1 && InDest[DataWidth-2] == 1)
						OutFlags.Overflow = 1;
					else
						OutFlags.Overflow = 0;
						
					if (OutDest[DataWidth-1] == 1)	//If OutDest is negative, Output flag negative is high, else low
						OutFlags.Negative = 1;
					else
						OutFlags.Negative = 0;
						
					if (^OutDest == 0)				//If OutDest features parity, Output flag parity is high, else low
						OutFlags.Parity = 1;
					else 
						OutFlags.Parity = 0;
					
				  
				end
				
			SUB:	
				begin
				
					{OutFlags.Carry, OutDest} = InDest - (InSrc + InFlags.Carry);	//Completes Subtraction including Input carry flag, and sets Output carry flag
			
					if (OutDest == 0)
						OutFlags.Zero = 1;
					else
						OutFlags.Zero = 0;
					
					if (OutDest[DataWidth-1] == 1 && InSrc[DataWidth-1]== 1 && InDest[DataWidth-1] == 0)
						OutFlags.Overflow = 1;
					else if (OutDest[DataWidth-1] == 0 && InSrc[DataWidth-1]== 0 && InDest[DataWidth-1] == 1)
						OutFlags.Overflow = 1;
					else
						OutFlags.Overflow = 0;
						
					if (OutDest[DataWidth-1] == 1)
						OutFlags.Negative = 1;
					else
						OutFlags.Negative = 0;
						
					if (^OutDest == 0)
						OutFlags.Parity = 1;
					else 
						OutFlags.Parity = 0;
						
				end
					
			DIV:	
				begin
				
					OutDest = InDest / InSrc; //Completes Division 
					
					if (OutDest == 0)
						OutFlags.Zero = 1;
					else
						OutFlags.Zero = 0;
						
					if (OutDest[DataWidth-1] == 1)
						OutFlags.Negative = 1;
					else
						OutFlags.Negative = 0;
						
					if (^OutDest == 0)
						OutFlags.Parity = 1;
					else 
						OutFlags.Parity = 0;
				end
				
			MOD:	
				begin 
				
					OutDest = InDest%InSrc;	//Sets OutDest to remainder of Indest/Insrc
					
					if (OutDest == 0)
						OutFlags.Zero = 1;
					else
						OutFlags.Zero = 0;
						
					if (OutDest[DataWidth-1] == 1)
						OutFlags.Negative = 1;
					else
						OutFlags.Negative = 0;
						
					if (^OutDest == 0)
						OutFlags.Parity = 1;
					else 
						OutFlags.Parity = 0;
				end
			
			MUL:	
				begin
				
					logic signed [2*DataWidth-1:0] Result1;
					Result1 = InDest*InSrc;
					
					OutDest = Result1[DataWidth-1:0];	//Assigns OutDest to Lower half of Indest*Insrc product
					
					if (OutDest == 0)
						OutFlags.Zero = 1;
					else
						OutFlags.Zero = 0;
						
					if (OutDest[DataWidth-1] == 1)
						OutFlags.Negative = 1;
					else
						OutFlags.Negative = 0;
						
					if (^OutDest == 0)
						OutFlags.Parity = 1;
					else 
						OutFlags.Parity = 0;
				end
				
			MUH:	
				begin
				
					logic signed [2*DataWidth-1:0] Result2;
					Result2 = InDest*InSrc;
					
					OutDest = Result2[2*DataWidth-1:DataWidth];	//Assigns OutDest to Upper half of Indest*Insrc product
					
					if (OutDest == 0)
						OutFlags.Zero = 1;
					else
						OutFlags.Zero = 0;
					
					if (OutDest[DataWidth-1] == 1)
						OutFlags.Negative = 1;
					else
						OutFlags.Negative = 0;
						
					if (^OutDest == 0)
						OutFlags.Parity = 1;
					else 
						OutFlags.Parity = 0;
				end
			
			// ***** ONLY CHANGES ABOVE THIS LINE ARE ASSESSED	*****		
			
			default:	OutDest = '0;
			
		endcase;
	end

endmodule
