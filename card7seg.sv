module card7seg(input logic [3:0] SW, output logic [6:0] HEX0);
  always @(SW) begin
	case (SW) 
	  4'b0000: HEX0 = ~7'b0000000; //empty
	  4'b0001: HEX0 = ~7'b1110111; //Ace
	  4'b0010: HEX0 = ~7'b1011011; //2 
	  4'b0011: HEX0 = ~7'b1001111; //3
	  4'b0100: HEX0 = ~7'b1100110; //4
	  4'b0101: HEX0 = ~7'b1101101; //5
	  4'b0110: HEX0 = ~7'b1111101; 
	  4'b0111: HEX0 = ~7'b0000111; 
	  4'b1000: HEX0 = ~7'b1111111; 
	  4'b1001: HEX0 = ~7'b1101111; 
	  4'b1010: HEX0 = ~7'b0111111; 
	  4'b1011: HEX0 = ~7'b0011110;  //Jack
	  4'b1100: HEX0 = ~7'b1100111; 
	  4'b1101: HEX0 = ~7'b1110110; 
	  4'b1110: HEX0 = ~7'b0000000; //not used
	  4'b1111: HEX0 = ~7'b0000000; //not used	
	endcase
  end
	
endmodule
