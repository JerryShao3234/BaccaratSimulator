module scorehand(input logic [3:0] card1, input logic [3:0] card2, input logic [3:0] card3, output logic [3:0] total);

reg [3:0] int1;
reg [3:0] int2;
reg [3:0] int3;

always @(card1 or card2 or card3) begin

  if (card1 >= 10 ) //anything greater than 10 is worth 0
	int1 = 0;
  else
	int1 = card1;

  if (card2 >= 10 )
	int2 = 0;
  else
	int2 = card2;

  if (card3 >= 10 )
	int3 = 0;
  else
	int3 = card3;

  total = (int1+int2+int3) % 10;


end
endmodule

