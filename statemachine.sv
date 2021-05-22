module statemachine(input logic slow_clock, input logic resetb,
                    input logic [3:0] dscore, input logic [3:0] pscore, input logic [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2, output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);

// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.


  reg [3:0] state, nstate;

  `define R0 4'b0110 //reset state
  `define S0 4'b0000 //player gets first card
  `define S1 4'b0001 //dealer gets first card
  `define S2 4'b0010 //player gets second card
  `define S3 4'b0011 //dealer gets second card
  `define S4 4'b0100 //choose next step
  `define S5 4'b0101 //player gets third card
  `define S6 4'b0111 //dealer gets third card
  `define S7 4'b1000 //calculate score
  


  always_ff @(negedge slow_clock)begin //FSM for determining next state
    case(state)
      `R0: nstate = `S0;
      `S0: nstate = `S1;
      `S1: nstate = `S2;
      `S2: nstate = `S3;
      `S3: nstate = `S4; //now both sides have 2 cards
      `S4: if(pscore == 8 || pscore == 9 || dscore == 8 || dscore == 9)
             nstate = `S7;
           else if(pscore >= 0 && pscore <= 5)
             nstate = `S5;
           else if((pscore == 6 || pscore == 7) && dscore < 6)
             nstate = `S6;
           else 
             nstate = `S7;
      `S5: if(dscore == 7)
             nstate = `S7;
           else if(dscore == 6 && (pcard3 == 6 || pcard3 == 7))
             nstate = `S6;
           else if(dscore == 5 &&(pcard3 >= 4 && pcard3 <= 7))
             nstate = `S6;
           else if(dscore == 4 && (pcard3 >= 2 && pcard3 <= 7))
             nstate = `S6;
           else if(dscore == 3 && pcard3 !== 8)
             nstate = `S6;
           else if(dscore >= 0 && dscore <= 2)
             nstate = `S6;
           else
             nstate = `S7;
      `S6: nstate = `S7;
      `S7: nstate = `S7;
   endcase
//  end

 // always_ff @(negedge slow_clock)begin //updating current state, which depends on resetb and nstate
    if(resetb == 0) //sync reset
      state <= `R0;
    else
      state <= nstate;
  end

 always_comb begin //to determine load enable for the six different reg4's 

    case(state)
      `R0: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b00000000; //doesn't enable anything   
      `S0: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b10000000; //mass concatenation
      `S1: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b00010000;
      `S2: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b01000000;
      `S3: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b00001000;
      `S5: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b00100000;
      `S6: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b00000100;
      `S4: {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b00000000; //doesn't enable anything, simply a decode stage

      `S7: begin 
	     {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3} = 6'b000000; //doesn't enable anything, score calculation stage
             if(pscore > dscore) begin 
               player_win_light = 1;
	       dealer_win_light = 0;
	      end
             else if(dscore > pscore) begin
               dealer_win_light = 1;
	       player_win_light = 0;
	      end
             else begin
               player_win_light = 1;
               dealer_win_light = 1;
             end
           end
      
             
    endcase
  end 
endmodule

