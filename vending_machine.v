/* Author : Santosh Raghav Srivatsan 	2017A8PS1924G */
/* BITS Pilani K.K. Birla Goa Campus */
/* B.E. Electronics & Instrumentation Engineering */
/* Bengaluru, Karnataka */

/* Railway station platform ticket vending machine */

module vending_machine(
	input clk, rst,
	input [1:0] coin,
	output reg ticket
);

	reg [3:0] state, next_state;

	/* Listing the 16 possible states */
	localparam [3:0] S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011,
		  	 S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111,
		  	 S8 = 4'b1000, S9 = 4'b1001, S10 = 4'b1010, S11 = 4'b1011,
		  	 S12 = 4'b1100, S13 = 4'b1101, S14 = 4'b1110, S15 = 4'b1111;

	

	/* Go to S0 if rst (active high) */
	always @(posedge clk, posedge rst)
	begin	
		if(rst) state <= S0;
		else state <= next_state;
	end
	

	/* Form the next state */
	/* Each state has 4 possible input combinations associated with it */
	/* coin[1:0] = 00 => Penny (jump to the next state) */
	/* coin[1:0] = 01 => Nickel (jump 5 states ahead) */
	/* coin[1:0] = 10 => Dime (jump 10 states ahead) */
	/* coin[1:0] = 11 => Invalid coin (Stay at the same state) */
	always @(state, coin)
	begin
		case(state)
		S0:     case(coin)
			2'b00: next_state = S1;
			2'b01: next_state = S5;
			2'b10: next_state = S10;
			2'b11: next_state = S0;
			endcase

		S1:     case(coin)
			2'b00: next_state = S2;
			2'b01: next_state = S6;
			2'b10: next_state = S11;
			2'b11: next_state = S1;
			endcase

		S2:     case(coin)
			2'b00: next_state = S3;
			2'b01: next_state = S7;
			2'b10: next_state = S12;
			2'b11: next_state = S2;
			endcase
		    
		S3:     case(coin)
			2'b00: next_state = S4;
			2'b01: next_state = S8;
			2'b10: next_state = S13;
			2'b11: next_state = S3;
			endcase
		   
		S4:     case(coin)
			2'b00: next_state = S5;
			2'b01: next_state = S9;
			2'b10: next_state = S14;
			2'b11: next_state = S4;
			endcase
		    
		S5:     case(coin)
			2'b00: next_state = S6;
			2'b01: next_state = S10;
			2'b10: next_state = S15;
			2'b11: next_state = S5;
			endcase
		 
		S6:     case(coin)
			2'b00: next_state = S7;
			2'b01: next_state = S11;
			2'b10: next_state = S15;
			2'b11: next_state = S6;
			endcase
		    
		S7:     case(coin)
			2'b00: next_state = S8;
			2'b01: next_state = S12;
			2'b10: next_state = S15;
			2'b11: next_state = S7;
			endcase
		   
		S8:     case(coin)
			2'b00: next_state = S9;
			2'b01: next_state = S13;
			2'b10: next_state = S15;
			2'b11: next_state = S8;
			endcase
		   
		S9:     case(coin)
			2'b00: next_state = S10;
			2'b01: next_state = S14;
			2'b10: next_state = S15;
			2'b11: next_state = S9;
			endcase

		S10:    case(coin)
			2'b00: next_state = S11;
			2'b01: next_state = S15;
			2'b10: next_state = S15;
			2'b11: next_state = S10;
			endcase

		S11:    case(coin)
			2'b00: next_state = S12;
			2'b01: next_state = S15;
			2'b10: next_state = S15;
			2'b11: next_state = S11;
			endcase
		 
		S12:    case(coin)
			2'b00: next_state = S13;
			2'b01: next_state = S15;
			2'b10: next_state = S15;
			2'b11: next_state = S12;
			endcase
		    
		S13:    case(coin)
			2'b00: next_state = S14;
			2'b01: next_state = S15;
			2'b10: next_state = S15;
			2'b11: next_state = S13;
			endcase		    

		S14:    case(coin)
			2'b00: next_state = S15;
			2'b01: next_state = S15;
			2'b10: next_state = S15;
			2'b11: next_state = S14;
			endcase

		S15:    case(coin)
			2'b00: next_state = S15;
			2'b01: next_state = S15;
			2'b10: next_state = S15;
			2'b11: next_state = S15;
			endcase		

		default: next_state = S0;
		endcase
			
	end
		
	/* Form the output */
	/* ticket = 1 only if the S15 has been reached */
	always @(state, coin)
		case(state)
		S15: ticket = 1'b1;
		default: ticket = 1'b0;
		endcase
endmodule

/*********************************************************************************************************/

/* Testbench */

module vending_machine_tb;
	reg tb_clk, tb_rst;
	reg [1:0] tb_coin;
	wire tb_ticket;

	vending_machine V(.clk(tb_clk), .rst(tb_rst), .coin(tb_coin), .ticket(tb_ticket));

	/* Clock generation */	
	/* Positive clock edge occurs at 5ns, 15ns, 25ns ..... */
	initial
	begin
		$dumpfile("vending_machine_tb.vcd");
		$dumpvars(0, vending_machine_tb);
		tb_clk = 0;
		forever #5 tb_clk = ~tb_clk;
	end

	initial 
	fork
		tb_rst = 1'b1;
		#20 tb_rst = 1'b0;
	        tb_coin = 2'b00; 	/* 1 Penny (1 cent) */
		#30 tb_coin = 2'b01; 	/* 1 Penny + 1 Nickel (6 cents) */
		#40 tb_coin = 2'b00; 	/* 1 Penny + 1 Nickel + 1 Penny (7 cents) */
		#50 tb_coin = 2'b10; 	/* 1 Penny + 1 Nickel + 1 Penny + 1 Dime (17 cents) => ticket = 1 */

		#56 tb_rst = 1'b1;	
		#58 tb_rst = 1'b0;
		#60 tb_coin = 2'b10; 	/* 1 Dime (10 cents) */
		#70 tb_coin = 2'b10; 	/* 1 Dime + 1 Dime (20 cents) => ticket = 1 */

		#80 $finish;
	join
endmodule
