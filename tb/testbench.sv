`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

/////////////////////////////////////////////////////////
// Interface
/////////////////////////////////////////////////////////

`include "uart_if.sv"

/////////////////////////////////////////////////////////
// Package
/////////////////////////////////////////////////////////

package uart_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `uvm_analysis_imp_decl(_exp)
    `uvm_analysis_imp_decl(_act)
    `uvm_analysis_imp_decl(_txcov)
    `uvm_analysis_imp_decl(_rxcov)

    `include "uart_seq_item.sv"
    `include "uart_base_seq.sv"
    `include "uart_driver.sv"
    `include "uart_wr_monitor.sv"
    `include "uart_tx_monitor.sv"
    `include "uart_scoreboard.sv"
    `include "uart_coverage.sv"
    `include "uart_tx_agent.sv"
    `include "uart_rx_agent.sv"
    `include "uart_env.sv"
    `include "uart_base_test.sv"

endpackage

/////////////////////////////////////////////////////////
// Import Package
/////////////////////////////////////////////////////////

import uart_test_pkg::*;

/////////////////////////////////////////////////////////
// Top Module
/////////////////////////////////////////////////////////

module uart_tb_top;

    //------------------------------------------------------------
    // Clock
    //------------------------------------------------------------
    logic clk = 0;

    always #5 clk = ~clk;

    //------------------------------------------------------------
    // Interface
    //------------------------------------------------------------
    uart_if u_if(clk);

    //------------------------------------------------------------
    // Reset
    //------------------------------------------------------------
    initial begin

        u_if.rst     = 1'b1;
        u_if.wr_en   = 1'b0;
        u_if.data_in = 8'h00;

        #50;

        u_if.rst = 1'b0;

    end

    //------------------------------------------------------------
    // DUT
    //------------------------------------------------------------
    UART_FIFO_TX_TOP dut(

        .clk     (clk),
        .rst     (u_if.rst),
        .wr_en   (u_if.wr_en),
        .data_in (u_if.data_in),
        .tx      (u_if.tx)

    );

    //------------------------------------------------------------
    // UVM Configuration
    //------------------------------------------------------------
    initial begin

        // Driver
        uvm_config_db#(virtual uart_if.DRIVER)::set(
            null,
            "uvm_test_top.env.tx_agent.drv",
            "vif",
            u_if
        );

        // Write Monitor
        uvm_config_db#(virtual uart_if.WR_MONITOR)::set(
            null,
            "uvm_test_top.env.tx_agent.wr_mon",
            "vif",
            u_if
        );

        // TX Monitor
        uvm_config_db#(virtual uart_if.TX_MONITOR)::set(
            null,
            "uvm_test_top.env.rx_agent.mon",
            "vif",
            u_if
        );

        // Baud Divider
        uvm_config_db#(int unsigned)::set(
            null,
            "*",
            "baud_div",
            4
        );

        run_test("uart_base_test");

    end

endmodule