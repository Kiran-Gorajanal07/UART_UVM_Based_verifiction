`ifndef UART_COVERAGE_SV
`define UART_COVERAGE_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_coverage.sv
//
// Description:
// Functional coverage for UART FIFO TX verification
//
//////////////////////////////////////////////////////////////////////////////////

class uart_coverage extends uvm_component;

    `uvm_component_utils(uart_coverage)

    //------------------------------------------------------------
    // Analysis Imports
    //------------------------------------------------------------
    uvm_analysis_imp_txcov #(uart_seq_item, uart_coverage) txcov_imp;
    uvm_analysis_imp_rxcov #(uart_seq_item, uart_coverage) rxcov_imp;

    //------------------------------------------------------------
    // Sample Objects
    //------------------------------------------------------------
    uart_seq_item tx_item;
    uart_seq_item rx_item;

    //------------------------------------------------------------
    // Coverage : FIFO Write Data
    //------------------------------------------------------------
    covergroup cg_tx;

        option.per_instance = 1;

        //--------------------------------------------------------
        // Data Coverage
        //--------------------------------------------------------
        cp_data : coverpoint tx_item.data
        {
            bins zero      = {8'h00};
            bins ones      = {8'hFF};
            bins alt55     = {8'h55};
            bins altAA     = {8'hAA};

            bins low[]     = {[8'h01:8'h3F]};
            bins middle[]  = {[8'h40:8'hBF]};
            bins high[]    = {[8'hC0:8'hFE]};
        }

    endgroup

    //------------------------------------------------------------
    // Coverage : UART Output
    //------------------------------------------------------------
    covergroup cg_rx;

        option.per_instance = 1;

        //--------------------------------------------------------
        // Received Data
        //--------------------------------------------------------
        cp_rx_data : coverpoint rx_item.data
        {
            bins zero      = {8'h00};
            bins ones      = {8'hFF};
            bins others[]  = default;
        }

        //--------------------------------------------------------
        // Parity Error
        //--------------------------------------------------------
        cp_parity : coverpoint rx_item.parity_error
        {
            bins no_error = {0};
            bins error    = {1};
        }

        //--------------------------------------------------------
        // Framing Error
        //--------------------------------------------------------
        cp_frame : coverpoint rx_item.framing_error
        {
            bins no_error = {0};
            bins error    = {1};
        }

        //--------------------------------------------------------
        // Error Cross
        //--------------------------------------------------------
        cross cp_parity, cp_frame;

    endgroup

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name="uart_coverage",
                 uvm_component parent);

        super.new(name,parent);

        txcov_imp = new("txcov_imp",this);
        rxcov_imp = new("rxcov_imp",this);

        cg_tx = new();
        cg_rx = new();

    endfunction

    //------------------------------------------------------------
    // From Write Monitor
    //------------------------------------------------------------
    function void write_txcov(uart_seq_item tr);

        tx_item = tr;

        cg_tx.sample();

    endfunction

    //------------------------------------------------------------
    // From TX Monitor
    //------------------------------------------------------------
    function void write_rxcov(uart_seq_item tr);

        rx_item = tr;

        cg_rx.sample();

    endfunction

    //------------------------------------------------------------
    // Report
    //------------------------------------------------------------
    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "======================================",
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  "UART COVERAGE REPORT",
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  "======================================",
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("FIFO Write Coverage : %0.2f%%",
                            cg_tx.get_coverage()),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("UART TX Coverage    : %0.2f%%",
                            cg_rx.get_coverage()),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  "======================================",
                  UVM_NONE)

    endfunction

endclass

`endif