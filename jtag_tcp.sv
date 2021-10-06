import "DPI-C" function int jtag_tcp_tick
(
 input int port,
 output bit jtag_TCK,
 output bit jtag_TMS,
 output bit jtag_TDI,
 output bit jtag_TRSTn,

 input bit  jtag_TDO
);

module jtag_tcp #(
   parameter TICK_DELAY = 50,
   parameter PORT = 7894
   )(
      input         clock,
      input         reset,

      input         enable,
      input         init_done,

      output        jtag_TCK,
      output        jtag_TMS,
      output        jtag_TDI,
      output        jtag_TRSTn,

      input         jtag_TDO_data,
      input         jtag_TDO_driven,

      output [31:0] exit
   );

   reg [31:0]                    tickCounterReg;
   wire [31:0]                   tickCounterNxt;

   assign tickCounterNxt = (tickCounterReg == 0) ? TICK_DELAY :  (tickCounterReg - 1);

   bit          r_reset;

   wire [31:0]  random_bits = $random;

   wire         #0.1 __jtag_TDO = jtag_TDO_driven ?
                jtag_TDO_data : random_bits[0];

   bit          __jtag_TCK;
   bit          __jtag_TMS;
   bit          __jtag_TDI;
   bit          __jtag_TRSTn;
   int          __exit;

   reg          init_done_sticky;

   assign #7 jtag_TCK   = __jtag_TCK;
   assign #7 jtag_TMS   = __jtag_TMS;
   assign #7 jtag_TDI   = __jtag_TDI;
   assign #7 jtag_TRSTn = __jtag_TRSTn;

   assign #0.1 exit = __exit;

    initial begin
        __jtag_TDI = 0;
        __jtag_TCK = 0;
        __jtag_TMS = 0;
        __jtag_TRSTn = 1 ;
    end

   always @(posedge clock) begin
      r_reset <= reset;
      if (reset || r_reset) begin
         __exit <= 0;
         tickCounterReg <= TICK_DELAY;
         init_done_sticky <= 1'b0;
      end else if(__exit) begin
         __exit <= 0;
      end else begin
         init_done_sticky <= init_done | init_done_sticky;
         //$display("1111");
         if (enable && init_done_sticky) begin
            //$display("2222");
            tickCounterReg <= tickCounterNxt;
            if (tickCounterReg == 0) begin
               //$display("3333");
               __exit <= jtag_tcp_tick(PORT,
                                  __jtag_TCK,
                                  __jtag_TMS,
                                  __jtag_TDI,
                                  __jtag_TRSTn,
                                  __jtag_TDO);
               //$display("4444");
            end
         end // if (enable && init_done_sticky)
      end // else: !if(reset || r_reset)
   end // always @ (posedge clock)
endmodule
