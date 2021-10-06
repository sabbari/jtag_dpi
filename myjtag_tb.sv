

`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps


module jtag_tb; 


reg tck,tms,tdi,tdo ;
reg [7:0] data;
reg [2:0] count ;

localparam period = 20;  

jtag_dpi DUT (
    .tck(tck),
    .tms(tms),
    .tdi(tdi),
    .tdo(tdo),
    .sys_clk(sys_clk)
);

// reset
initial 
begin 
	data=56;
	$vcdpluson();
    	$vcdplusmemon();
count =7;	
end

always 
begin

    sys_clk = 1'b1; 
    #10; // high for 10 * timescale = 10 ns

    sys_clk = 1'b0;
    #10; // low for 10 * timescale = 10 ns

end


endmodule