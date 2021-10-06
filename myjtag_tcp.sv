module jtag_dpi(
    output reg tck,
    output reg tms,
    output reg tdi,
    input tdo,
    input sys_clk
);

parameter port = 7894;





import "DPI-C" context function int jtag_server( output bit tck,
                                             output bit tms,
                                             output bit tdi,
                                             input  bit tdo,
                                             input  int port
); // spi() defined in file server_spi.c




always @(posedge sys_clk)
begin

	jtag_server(spi_cs_o,spi_clk_o,spi_mosi_o,spi_miso_i,port);
    	
end
endmodule
