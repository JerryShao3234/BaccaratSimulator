module tb_datapath;
    
    logic slow_clock, fast_clock, resetb; 
    logic load_pcard1, load_pcard2, load_pcard3; 
    logic load_dcard1, load_dcard2, load_dcard3;
    logic [3:0] pcard3_out, pscore_out, dscore_out;
    logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    logic error;

datapath dp(.slow_clock(slow_clock),
            .fast_clock(fast_clock),
            .resetb(resetb),
            .load_pcard1(load_pcard1),
            .load_pcard2(load_pcard2),
            .load_pcard3(load_pcard3),
            .load_dcard1(load_dcard1),
            .load_dcard2(load_dcard2),
            .load_dcard3(load_dcard3),
            .pcard3_out(pcard3_out),
	    .pscore_out(pscore_out),
	    .dscore_out(dscore_out),
            .HEX5(HEX5),
            .HEX4(HEX4),
            .HEX3(HEX3),
            .HEX2(HEX2),
            .HEX1(HEX1),
            .HEX0(HEX0));

    
    initial forever begin
	fast_clock = !fast_clock;
	#5;
    end

    initial begin
	error = 0; //set error to 0
	fast_clock = 0; slow_clock = 1; //change fast clock
	resetb = 1;
	load_pcard1 = 0; load_pcard2 = 0; load_pcard3 = 0;  //disable
  	load_dcard1 = 0; load_dcard2 = 0; load_dcard3 = 0;

	#2;

	resetb = 0; //press reset

	slow_clock = 0;
	#5;
	slow_clock = 1;	//press and release slow_clock
	#5;


	resetb = 1; //release reset

	assert(((load_pcard1 | load_pcard2 | load_pcard3) == 0) && ((load_dcard1 | load_dcard2 | load_dcard3) == 0))
	else begin $display("Error"); error = 1; end

        $display("%d %d %d %d %d %d", load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3); //print results (should be 0 since we just reset it)

	//*******************************************************************************************************************************
	//test load 
	
	slow_clock = 0; //reset first
	load_pcard1 = 1; //enable for each reg progressively, 6 in all, 3 for player, 3 for dealer
	#10;
	
	slow_clock = 1;
	load_pcard1 = 0; //disable
        assert((dp.new_card !== 0) && (dp.PCard1 !== 0) )
	else begin $display("Error"); error = 1; end


	$display("%d %d", dp.new_card, dp.PCard1); //should be non zero now
	#10;

	//**********************************************************************************

	slow_clock = 0; //reset first
	load_pcard2 = 1; //enable
	#10;
	
	slow_clock = 1;
	load_pcard2 = 0; //disable
	assert((dp.new_card !== 0) && (dp.PCard2 !== 0) )
	else begin $display("Error"); error = 1; end
	$display("%d %d", dp.new_card, dp.PCard2); //should be non zero now
	#10;

        //*******************************

	slow_clock = 0; //reset first
	load_pcard3 = 1; //enable
	#10;
	
	slow_clock = 1;
	load_pcard3 = 0; //disable
	assert((dp.new_card !== 0) && (dp.pcard3_out !== 0) )
	else begin $display("Error"); error = 1; end
	$display("%d %d", dp.new_card, dp.pcard3_out); //should be non zero now
	#10;
//*******************************************

	$display("%b %b %b %b %b %b" , HEX0, HEX1, HEX2, HEX3, HEX4, HEX5); //display HEX digits, see if they match

	$display ("%d %d", pscore_out, dscore_out); 

		//test score see if that matches with displayed stuff
	

//********************************************
slow_clock = 0; //reset first
	load_dcard1 = 1; //enable
	#10;
	
	slow_clock = 1;
	load_dcard1 = 0; //disable
	assert((dp.new_card !== 0) && (dp.DCard1 !== 0) )
	else begin $display("Error"); error = 1; end
	$display("%d %d", dp.new_card, dp.DCard1); //should be non zero now
	#10;

	//**********************************************************************************

	slow_clock = 0; //reset first
	load_dcard2 = 1; //enable
	#10;
	
	slow_clock = 1;
	load_dcard2 = 0; //disable
	assert((dp.new_card !== 0) && (dp.DCard2 !== 0) )
	else begin $display("Error"); error = 1; end
	$display("%d %d", dp.new_card, dp.DCard2); //should be non zero now
	#10;

        //*******************************

	slow_clock = 0; //reset first
	load_dcard3 = 1; //enable
	#10;
	
	slow_clock = 1;
	load_dcard3 = 0; //disable
	assert((dp.new_card !== 0) && (dp.DCard3 !== 0) )
	else begin $display("Error"); error = 1; end
	$display("%d %d", dp.new_card, dp.DCard3); //should be non zero now
	#10;
//********************************************************************************************
	$display("%b %b %b %b %b %b" , HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);//display HEX digits, see if they match

	$display ("%d %d", pscore_out, dscore_out); //test score see if that matches with displayed stuff
	
	if(error == 0) begin //check error signal again
	  $display("All tests passed!");
	end
	else begin
	  $display("Error in design (check lines of code)");
	end

   $stop;

    end
endmodule
