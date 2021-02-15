/* Author : Santosh Raghav Srivatsan 	2017A8PS1924G */
/* BITS Pilani K.K. Birla Goa Campus */
/* B.E. Electronics & Instrumentation Engineering */
/* Bengaluru, Karnataka */

/* Testbench for vending_machine */

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

/*********************************************************************************************************/
