

module tb_task5;

	logic CLOCK_50;
	logic [3:0] KEY;
	logic [9:0] LEDR;
	logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
  	logic error;  

    task4 DUT (.CLOCK_50(CLOCK_50), 
               .KEY(KEY), 
               .LEDR(LEDR), 
               .HEX5(HEX5), 
               .HEX4(HEX4), 
               .HEX3(HEX3), 
               .HEX2(HEX2), 
               .HEX1(HEX1), 
               .HEX0(HEX0));
  initial begin
 	CLOCK_50 = 1'b0; #10;
	forever begin
        CLOCK_50 = 1'b1; #25; //50 mHz
        CLOCK_50 = 1'b0; #25;
        end
    end

    // generate slow clock
    initial begin
        KEY[0] = 1'b0; #11;
        forever begin
        KEY[0] = 1'b1; #50; //arbitrary longer delay
        KEY[0] = 1'b0; #50;
        end
    end

    initial begin
	error = 0;
        KEY[3] = 1'b0; //press reset
        #29; //29, random delays to simulate real design
		
        KEY[3] = 1'b1; // release reset 

	#166 //random delay within 2 cycles, 195

	assert(HEX0 !== 8'b11111111) //HEX0 should display player's first card
	else begin $display("Error1"); error=1; end;

	#2; //197

	assert(LEDR !== 0)
	else begin $display("Error2"); error =1; end 

	#105//302

	assert((HEX3 !== 8'b11111111) && (HEX0 !== 8'b11111111) && (LEDR !== 0)) //display player's first card and dealer's first card
	else begin $display("Error3"); error=1; end;

	#75//377

	assert((HEX3 !== 8'b11111111) && (HEX0 !== 8'b11111111) && (HEX1 != 8'b11111111) && (LEDR !== 0)) //adds player's second card
	else begin $display("Error4"); error=1; end;

	#131

	assert((HEX3 !== 8'b11111111) && (HEX0 !== 8'b11111111) && (HEX1 != 8'b11111111) && (HEX4 != 8'b11111111) && (LEDR !== 0)) //each side should have both their cards
	else begin $display("Error5"); error=1; end;

        #1500; //The pseudo-random cards are hard to predict so I used the visual waveforms
        KEY[3] = 1'b0; // reset
	#55
	KEY[3] = 1'b1; //release reset
        #50;
    
	if(error == 0)
	$display("Current tests passed!");
	else
	$display("Check error messags...");
        $stop;
    end

endmodule