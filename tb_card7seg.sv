module tb_card7seg();
  logic [3:0] SW;
  logic [6:0] HEX0;
  logic err;
  card7seg DUT(.SW(SW),.HEX0(HEX0));

  initial begin 
	err=0; //set error signal to 0
	//Here we test every possible case 
	SW = 4'b0000;
	#2;
	assert(DUT.HEX0 == 7'b1111111) //check if HEX displays correctly
	else begin $error("case 0 failed"); err = 1; end //print error if incorrect
        #10;
	SW = 1;
	#2;
	assert(DUT.HEX0 == ~7'b1110111)
	else begin $error("case A failed"); err = 1; end
        #10;
	SW = 2;
	#2;
	assert(DUT.HEX0 ==  ~7'b1011011)
	else begin $error("case 2 failed"); err = 1; end
        #10;
	SW = 3;
	#2;
	assert(DUT.HEX0 ==  ~7'b1001111)
	else begin $error("case 3 failed"); err = 1; end
        #10;
	SW = 4;
	#2;
	assert(DUT.HEX0 ==  ~7'b1100110)
	else begin $error("case 4 failed"); err = 1; end
        #10;
	SW = 5;
	#2;
	assert(DUT.HEX0 ==  ~7'b1101101)
	else begin $error("case 5 failed"); err = 1; end
        #10;
	SW = 6;
	#2;
	assert(DUT.HEX0 ==  ~7'b1111101)
	else begin $error("case 6 failed"); err = 1; end
        #10;
	SW = 7;
	#2;
	assert(DUT.HEX0 == ~7'b0000111)
	else begin $error("case 7 failed"); err = 1; end
        #10;
	SW = 8;
	#2;
	assert(DUT.HEX0 == ~7'b1111111)
	else begin $error("case 8 failed"); err = 1; end
        #10;
	SW = 9;
	#2;
	assert(DUT.HEX0 == ~7'b1101111)
	else begin $error("case 9 failed"); err = 1; end
        #10;
	SW = 10;
	#2;
	assert(DUT.HEX0 == ~7'b0111111)
	else begin $error("case 10 failed"); err = 1; end
        #10;
	SW = 11;
	#2;
	assert(DUT.HEX0 ==  ~7'b0011110)
	else begin $error("case J failed"); err = 1; end
        #10;
	SW = 12;
	#2;
	assert(DUT.HEX0 ==  ~7'b1100111)
	else begin $error("case Q failed"); err = 1; end
        #10;
	SW = 13;
	#2;
	assert(DUT.HEX0 ==  ~7'b1110110)
	else begin $error("case K failed"); err = 1; end
        #10;
	SW = 14;
	#2;
	assert(DUT.HEX0 ==  ~7'b0000000)
	else begin $error("case 15 failed"); err = 1; end
        #10;
	SW = 4'b1111;
	#2;
	assert(DUT.HEX0 ==  ~7'b0000000)
	else begin $error("case 16 failed"); err = 1; end
        #10;

	if(err == 0)
	$display("All tests passed!");
	else
	$display("Check the error messages.");
	$stop;
  end

endmodule

