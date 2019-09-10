`include "openMSP430_defines.v"

module toplevel (
		 clk_sys,
		 reset_n,
		 p1_din,
		 p1_dout_en,
		 p1_dout,
		 p2_din,
		 p2_dout_en,
		 p2_dout,
		 p3_din,
		 p3_dout_en,
		 p3_dout,
		 p4_din,
		 p4_dout_en,
		 p4_dout,
		 p5_din,
		 p5_dout_en,
		 p5_dout,
		 p6_din,
		 p6_dout_en,
		 p6_dout,
		 debug_uart_rx,
		 debug_uart_tx,
		 user_uart_rx,
		 user_uart_tx);
   
   input                    clk_sys;
   input                    reset_n;
   
   input [7:0] 		    p1_din;
   output [7:0] 	    p1_dout;
   output [7:0] 	    p1_dout_en;
   
   input [7:0] 		    p2_din;
   output [7:0] 	    p2_dout;
   output [7:0] 	    p2_dout_en;
   
   input [7:0] 		    p3_din;
   output [7:0] 	    p3_dout;
   output [7:0] 	    p3_dout_en;

   input [7:0] 		    p4_din;
   output [7:0] 	    p4_dout;
   output [7:0] 	    p4_dout_en;
   
   input [7:0] 		    p5_din;
   output [7:0] 	    p5_dout;
   output [7:0] 	    p5_dout_en;
   
   input [7:0] 		    p6_din;
   output [7:0] 	    p6_dout;
   output [7:0] 	    p6_dout_en;

   input                    debug_uart_rx;
   output 		    debug_uart_tx;
   input                    user_uart_rx;
   output 		    user_uart_tx;
   
   // openMSP430 output buses
   wire [13:0] 		    per_addr;
   wire [15:0] 		    per_din;
   wire [1:0] 		    per_we;
   wire [`DMEM_MSB:0] 	    dmem_addr;
   wire [15:0] 		    dmem_din;
   wire [1:0] 		    dmem_wen;
   wire [`PMEM_MSB:0] 	    pmem_addr;
   wire [15:0] 		    pmem_din;
   wire [1:0] 		    pmem_wen;
   wire [13:0] 		    irq_acc;
   
   // openMSP430 input buses
   wire [13:0] 		    irq_bus;
   wire [15:0] 		    per_dout;
   wire [15:0] 		    dmem_dout;
   wire [15:0] 		    pmem_dout;

   // peripheral busses
   wire [15:0] 		    per_dout_dio;
   wire [15:0] 		    per_dout_tA;
   wire [15:0] 		    per_dout_uart;
   
   openMSP430 openMSP430_0 (
			    .aclk              (),             // ASIC ONLY: ACLK
       			    .aclk_en           (aclk_en),      // FPGA ONLY: ACLK enable
			    .dbg_freeze        (dbg_freeze),   // Freeze peripherals
			    .dbg_i2c_sda_out   (),             // Debug interface: I2C SDA OUT
			    .dbg_uart_txd      (debug_uart_tx), // Debug interface: UART TXD
			    .dco_enable        (),             // ASIC ONLY: Fast oscillator enable
			    .dco_wkup          (),             // ASIC ONLY: Fast oscillator wake-up (asynchronous)
			    .dmem_addr         (dmem_addr),    // Data Memory address
			    .dmem_cen          (dmem_cen),     // Data Memory chip enable (low active)
			    .dmem_din          (dmem_din),     // Data Memory data input
			    .dmem_wen          (dmem_wen),     // Data Memory write enable (low active)
			    .irq_acc           (irq_acc),      // Interrupt request accepted (one-hot signal)
			    .lfxt_enable       (),             // ASIC ONLY: Low frequency oscillator enable
			    .lfxt_wkup         (),             // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
			    .mclk              (mclk),         // Main system clock
			    .dma_dout          (),             // Direct Memory Access data output
			    .dma_ready         (),             // Direct Memory Access is complete
			    .dma_resp          (),             // Direct Memory Access response (0:Okay / 1:Error)
			    .per_addr          (per_addr),     // Peripheral address
			    .per_din           (per_din),      // Peripheral data input
			    .per_we            (per_we),       // Peripheral write enable (high active)
			    .per_en            (per_en),       // Peripheral enable (high active)
			    .pmem_addr         (pmem_addr),    // Program Memory address
			    .pmem_cen          (pmem_cen),     // Program Memory chip enable (low active)
			    .pmem_din          (pmem_din),     // Program Memory data input (optional)
			    .pmem_wen          (pmem_wen),     // Program Memory write enable (low active) (optional)
			    .puc_rst           (puc_rst),      // Main system reset
			    .smclk             (),             // ASIC ONLY: SMCLK
			    .smclk_en          (smclk_en),     // FPGA ONLY: SMCLK enable
			    
			    // INPUTs
			    .cpu_en            (1'b1),         // Enable CPU code execution (asynchronous and non-glitchy)
			    .dbg_en            (1'b1),         // Debug interface enable (asynchronous and non-glitchy)
			    .dbg_i2c_addr      (7'h00),        // Debug interface: I2C Address
			    .dbg_i2c_broadcast (7'h00),        // Debug interface: I2C Broadcast Address (for multicore systems)
			    .dbg_i2c_scl       (1'b1),         // Debug interface: I2C SCL
			    .dbg_i2c_sda_in    (1'b1),         // Debug interface: I2C SDA IN
			    .dbg_uart_rxd      (debug_uart_rx), // Debug interface: UART RXD (asynchronous)
			    .dco_clk           (clk_sys),      // Fast oscillator (fast clock)
			    .dmem_dout         (dmem_dout),    // Data Memory data output
			    .irq               (irq_bus),      // Maskable interrupts
			    .lfxt_clk          (1'b0),         // Low frequency oscillator (typ 32kHz)
			    .dma_addr          (15'h0000),     // Direct Memory Access address
			    .dma_din           (16'h0000),     // Direct Memory Access data input
			    .dma_en            (1'b0),         // Direct Memory Access enable (high active)
			    .dma_priority      (1'b0),         // Direct Memory Access priority (0:low / 1:high)
			    .dma_we            (2'b00),        // Direct Memory Access write byte enable (high active)
			    .dma_wkup          (1'b0),         // ASIC ONLY: DMA Sub-System Wake-up (asynchronous and non-glitchy)
			    .nmi               (nmi),          // Non-maskable interrupt (asynchronous)
			    .per_dout          (per_dout),     // Peripheral data output
			    .pmem_dout         (pmem_dout),    // Program Memory data output
			    .reset_n           (reset_n),      // Reset Pin (low active, asynchronous and non-glitchy)
			    .scan_enable       (1'b0),         // ASIC ONLY: Scan enable (active during scan shifting)
			    .scan_mode         (1'b0),         // ASIC ONLY: Scan mode
			    .wkup              (1'b0)          // ASIC ONLY: System Wake-up (asynchronous and non-glitchy)             
			    );
   
   omsp_gpio #(.P1_EN(1),
               .P2_EN(1),
               .P3_EN(1),
               .P4_EN(1),
               .P5_EN(1),
               .P6_EN(1)) gpio_0 (
				  // OUTPUTs
				  .irq_port1    (irq_port1),     
				  .irq_port2    (irq_port2),     
				  .p1_dout      (p1_dout),       
				  .p1_dout_en   (p1_dout_en),    
				  .p1_sel       (),        
				  .p2_dout      (p2_dout),       
				  .p2_dout_en   (p2_dout_en),    
				  .p2_sel       (),        
				  .p3_dout      (p3_dout),              
				  .p3_dout_en   (p3_dout_en),    
				  .p3_sel       (),        
				  .p4_dout      (p4_dout),              
				  .p4_dout_en   (p4_dout_en),              
				  .p4_sel       (),              
				  .p5_dout      (p5_dout),              
				  .p5_dout_en   (p5_dout_en),              
				  .p5_sel       (),              
				  .p6_dout      (p6_dout),              
				  .p6_dout_en   (p6_dout_en),              
				  .p6_sel       (),              
				  .per_dout     (per_dout_dio),  
				  
				  // INPUTs
				  .mclk         (mclk),          
				  .p1_din       (p1_din),        
				  .p2_din       (p2_din),        
				  .p3_din       (p3_din),              
				  .p4_din       (p4_din),         
				  .p5_din       (p5_din),         
				  .p6_din       (p6_din),         
				  .per_addr     (per_addr),      
				  .per_din      (per_din),       
				  .per_en       (per_en),        
				  .per_we       (per_we),        
				  .puc_rst      (puc_rst)        
				  );
   
   omsp_timerA timerA_0 (
			 // OUTPUTs
			 .irq_ta0      (irq_ta0),       
			 .irq_ta1      (irq_ta1),       
			 .per_dout     (per_dout_tA),   
			 .ta_out0      (ta_out0),       
			 .ta_out0_en   (ta_out0_en),    
			 .ta_out1      (ta_out1),       
			 .ta_out1_en   (ta_out1_en),    
			 .ta_out2      (ta_out2),       
			 .ta_out2_en   (ta_out2_en),    
			 
			 // INPUTs
			 .aclk_en      (aclk_en),       
			 .dbg_freeze   (dbg_freeze),    
			 .inclk        (inclk),         
			 .irq_ta0_acc  (irq_acc[9]),    
			 .mclk         (mclk),          
			 .per_addr     (per_addr),      
			 .per_din      (per_din),       
			 .per_en       (per_en),        
			 .per_we       (per_we),        
			 .puc_rst      (puc_rst),       
			 .smclk_en     (smclk_en),      
			 .ta_cci0a     (ta_cci0a),      
			 .ta_cci0b     (ta_cci0b),      
			 .ta_cci1a     (ta_cci1a),      
			 .ta_cci1b     (1'b0),          
			 .ta_cci2a     (ta_cci2a),      
			 .ta_cci2b     (1'b0),          
			 .taclk        (taclk)              
			 );
   
   omsp_uart #(.BASE_ADDR(15'h0080)) 
   uart_0 (
	   .irq_uart_rx  (irq_uart_rx),   // UART receive interrupt
	   .irq_uart_tx  (irq_uart_tx),   // UART transmit interrupt
	   .per_dout     (per_dout_uart), // Peripheral data output
	   .uart_txd     (user_uart_tx),  // UART Data Transmit (TXD)
	   .mclk         (mclk),          // Main system clock
	   .per_addr     (per_addr),      // Peripheral address
	   .per_din      (per_din),       // Peripheral data input
	   .per_en       (per_en),        // Peripheral enable (high active)
	   .per_we       (per_we),        // Peripheral write enable (high active)
	   .puc_rst      (puc_rst),       // Main system reset
	   .smclk_en     (smclk_en),      // SMCLK enable (from CPU)
	   .uart_rxd     (user_uart_rx)   // UART Data Receive (RXD)
	   );
   
   assign per_dout = per_dout_dio  |
                     per_dout_tA   |
		     per_dout_uart;
   
   assign nmi        =  1'b0;
   assign irq_bus    = {1'b0,         // Vector 13  (0xFFFA)
			1'b0,         // Vector 12  (0xFFF8)
			1'b0,         // Vector 11  (0xFFF6)
			1'b0,         // Vector 10  (0xFFF4) - Watchdog -
			irq_ta0,      // Vector  9  (0xFFF2)
			irq_ta1,      // Vector  8  (0xFFF0)
			irq_uart_rx,  // Vector  7  (0xFFEE)
			irq_uart_tx,  // Vector  6  (0xFFEC)
			1'b0,         // Vector  5  (0xFFEA)
			1'b0,         // Vector  4  (0xFFE8)
			irq_port2,    // Vector  3  (0xFFE6)
			irq_port1,    // Vector  2  (0xFFE4)
			1'b0,         // Vector  1  (0xFFE2)
			1'b0};        // Vector  0  (0xFFE0)
   
   ram16x4096 ram (
		   .address (dmem_addr[11:0]),
		   .clken   (~dmem_cen),
		   .clock   (clk_sys),
		   .data    (dmem_din[15:0]),
		   .q       (dmem_dout[15:0]),
		   .wren    ( ~(&dmem_wen[1:0]) ),
		   .byteena ( ~dmem_wen[1:0] )
		   );

   ram16x27648 rom (
`ifdef PMEM_SIZE_1_KB
		    .address ({6'b111111, pmem_addr[8:0]}),
`endif
`ifdef PMEM_SIZE_54_KB
		    .address (pmem_addr[14:0]),
`endif
		    .clken   (~pmem_cen),
		    .clock   (clk_sys),
		    .data    (pmem_din[15:0]),
		    .q       (pmem_dout[15:0]),
		    .wren    (~(&pmem_wen[1:0]) ),
		    .byteena (~pmem_wen[1:0])
		    );
   
endmodule
