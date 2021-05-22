module tb_statemachine();

 logic slow_clock, resetb, reset, err, player_win_light,  dealer_win_light, load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3, error;
 logic [3:0] pcard3_out, pscore_out,dscore_out;
                    

 statemachine Dut (.slow_clock(slow_clock),.resetb(resetb),.dscore(dscore_out),.pscore(pscore_out),.pcard3(pcard3_out),.load_pcard1(load_pcard1), 
			.load_pcard2(load_pcard2), .load_pcard3(load_pcard3),
                        .load_dcard1(load_dcard1), .load_dcard2(load_dcard2), .load_dcard3(load_dcard3), .player_win_light(player_win_light), .dealer_win_light(dealer_win_light)
	              );
                   

    initial forever begin 
        slow_clock = !slow_clock; 
	#5;
    end


    initial begin
	error = 0;
	{slow_clock, resetb, pscore_out, dscore_out} = 4'b0100; //testing reset
	#10;
        resetb = 0; 
	#10;
	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0) //should be 0 cuz reset
	else begin $display("Error1"); error = 1; end
   	
	#15;

        resetb = 1; #10; //releast reset

   	assert(load_pcard1 == 1 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0) //now start distributing cards in order
	else begin $display("Error2"); error = 1; end
	 #10;

   	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 1 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error3"); error = 1; end
	#10;

    	assert(load_pcard1 == 0 && load_pcard2 == 1 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error4"); error = 1; end
	#10;
       assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 1 && load_dcard3 == 0)
	else begin $display("Error5"); error = 1; end
	#10;

       //Check for win condition 
       pscore_out = 8; #15;
        	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0) //should all be 0 in this stage
	else begin $display("Error6"); error = 1; end#5;


	//Player gets third card; game ends
        resetb = 0;
	#20;
        resetb = 1;
	#45;
        pscore_out = 0;
	dscore_out = 7;
	#5
        	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error7"); error = 1; end
       
	#10;

         	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 1 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error8"); error = 1; end
	#5;
        

	//player gets third card, dealer only gets third card if player card >= 4
        resetb = 0;
	#15;
        resetb = 1;
	#30;
        pscore_out = 4; 
	dscore_out = 5;
	#25;
	pcard3_out = 4;
	#10;
       assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 1 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error"); error = 1; end

	//player gets third card, dealer gets card if player card >= 2, <=7 
        resetb = 0;
	#15;
        resetb = 1;
	#30;
        pcard3_out = 7; 
        pscore_out = 3; 
        dscore_out = 3; 
        #25;
        #10;
   	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 1 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error9"); error = 1; end#15; 
   	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error10"); error = 1; end;
#15;


 //player doesn't get a third card but dealer does
        resetb = 0;
	#20;
        resetb = 1;
	#30;
        pcard3_out = 1;
        pscore_out = 6;
	dscore_out = 5;
	#35;
   	assert(load_pcard1 == 0 && load_pcard2 == 0 && load_pcard3 == 0 && load_dcard1 == 0 && load_dcard2 == 0 && load_dcard3 == 0)
	else begin $display("Error11"); error = 1; end
#15;
   	if(error == 0)
	$display("Tests passed!");
	else
	$display("Check error messages.");
        $stop;
    end
endmodule
