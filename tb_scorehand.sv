module tb_scorehand();
  reg [3:0] card1, card2, card3;
  wire [3:0] total;
  logic err;

  scorehand DUT(.card1(card1),.card2(card2),.card3(card3),.total(total));

  initial begin
	err = 0;

	card1 = 2; //test standard case
	card2 = 3;
	card3 = 1;
	#2
	assert(DUT.total == 6)
	else begin $display("error 1"); err=1; end
	#10;
	card1 = 2; 
	card2 = 10;
	card3 = 10;
	#2
	assert(DUT.total == 2)
	else begin $display("error 2"); err=1; end
	#10;
	card1 = 10; //test values >= 10
	card2 = 10;
	card3 = 11;
	#2
	assert(DUT.total == 0)
	else begin $display("error 3"); err=1; end
	#10;
	card1 = 10; //test values >= 10
	card2 = 11;
	card3 = 12;
	#2
	assert(DUT.total == 0)
	else begin $display("error 4"); err=1; end
	#10;
	card1 = 2; 
	card2 = 11;
	card3 = 12;
	#2
	assert(DUT.total == 2)
	else begin $display("error 5"); err=1; end
	#10;
	if(err == 0)
	$display("All tests passed!");
	else
	$display("Something failed...");

	$stop;
  end
endmodule
