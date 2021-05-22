module datapath(input logic slow_clock, input logic fast_clock, input logic resetb,
                input logic load_pcard1, input logic load_pcard2, input logic load_pcard3,
                input logic load_dcard1, input logic load_dcard2, input logic load_dcard3,
                output logic [3:0] pcard3_out,
                output logic [3:0] pscore_out, output logic [3:0] dscore_out,
                output logic [6:0] HEX5, output logic [6:0] HEX4, output logic [6:0] HEX3,
                output logic [6:0] HEX2, output logic [6:0] HEX1, output logic [6:0] HEX0);



  wire [3:0] new_card, PCard1, PCard2, DCard1, DCard2, DCard3; //wires necessary to connect different modules in dp, PCard3 is a predefined output

  dealcard d1 (.clock(fast_clock),.resetb(resetb),.new_card(new_card));
  
  
  reg4b PCar1 (.new_card(new_card), .slow_clock(slow_clock), .resetb(resetb), .load_xcard1(load_pcard1), .out_card(PCard1));
  reg4b PCar2 (.new_card(new_card), .slow_clock(slow_clock), .resetb(resetb), .load_xcard1(load_pcard2), .out_card(PCard2));
  reg4b PCar3 (.new_card(new_card), .slow_clock(slow_clock), .resetb(resetb), .load_xcard1(load_pcard3), .out_card(pcard3_out));

  reg4b DCar1 (.new_card(new_card), .slow_clock(slow_clock), .resetb(resetb), .load_xcard1(load_dcard1), .out_card(DCard1));
  reg4b DCar2 (.new_card(new_card), .slow_clock(slow_clock), .resetb(resetb), .load_xcard1(load_dcard2), .out_card(DCard2));
  reg4b DCar3 (.new_card(new_card), .slow_clock(slow_clock), .resetb(resetb), .load_xcard1(load_dcard3), .out_card(DCard3));

  card7seg playerc1 (.SW(PCard1),.HEX0(HEX0));
  card7seg playerc2 (.SW(PCard2),.HEX0(HEX1));
  card7seg playerc3 (.SW(pcard3_out),.HEX0(HEX2));

  card7seg dealerc1 (.SW(DCard1),.HEX0(HEX3));
  card7seg dealerc2 (.SW(DCard2),.HEX0(HEX4));
  card7seg dealerc3 (.SW(DCard3),.HEX0(HEX5));

  scorehand player (.card1(PCard1), .card2(PCard2), .card3(pcard3_out), .total(pscore_out));
  scorehand dealer (.card1(DCard1), .card2(DCard2), .card3(DCard3), .total(dscore_out));

  

// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.

endmodule

/*module reg4b (input logic [3:0] new_card, input logic slow_clock, input logic resetb, input logic load_xcard1, output logic [3:0] out_card); 

  always @(negedge slow_clock) begin
    if(resetb == 0)
      out_card <= 0;
    else if (load_xcard1 == 1)
      out_card <= new_card;
    else if (load_xcard1 == 0)
      out_card <= out_card;
    else 
      out_card <= 4'bxxxx;
  end

endmodule*/

module reg4b (input logic [3:0] new_card, input logic slow_clock, input logic resetb, input logic load_xcard1, output logic [3:0] out_card); 

  always @(negedge slow_clock) begin
    if(resetb == 0)
      out_card <= 0;
    else
      out_card <= load_xcard1 ? new_card:out_card;
  end

endmodule



