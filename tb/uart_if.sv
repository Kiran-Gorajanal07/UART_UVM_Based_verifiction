`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO Transmitter Verification
// File    : uart_if.sv
//////////////////////////////////////////////////////////////////////////////////

interface uart_if(input logic clk);

    //------------------------------------------------------------
    // DUT Signals
    //------------------------------------------------------------
    logic rst;
    logic wr_en;
    logic [7:0] data_in;
    logic tx;

    //------------------------------------------------------------
    // Driver Modport
    //------------------------------------------------------------
    modport DRIVER
    (
        input  clk,
        input  rst,

        output wr_en,
        output data_in,

        input  tx
    );

    //------------------------------------------------------------
    // Write Monitor Modport
    //------------------------------------------------------------
    modport WR_MONITOR
    (
        input clk,
        input rst,
        input wr_en,
        input data_in
    );

    //------------------------------------------------------------
    // TX Monitor Modport
    //------------------------------------------------------------
    modport TX_MONITOR
    (
        input clk,
        input rst,
        input tx
    );

endinterface