`ifndef UART_TX_AGENT_SV
`define UART_TX_AGENT_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_tx_agent.sv
//
// Description:
// Active UART TX Agent
// Contains:
//      1. Sequencer
//      2. Driver
//      3. Write Monitor
//
//////////////////////////////////////////////////////////////////////////////////

class uart_tx_agent extends uvm_agent;

    `uvm_component_utils(uart_tx_agent)

    //------------------------------------------------------------
    // Components
    //------------------------------------------------------------

    uart_driver                    drv;
    uart_wr_monitor                wr_mon;
    uvm_sequencer #(uart_seq_item) sqr;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------

    function new(string name="uart_tx_agent",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    //------------------------------------------------------------
    // Build Phase
    //------------------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        `uvm_info(get_type_name(),
                  "Building UART TX Agent",
                  UVM_LOW)

        //--------------------------------------------------------
        // Active Agent
        //--------------------------------------------------------

        is_active = UVM_ACTIVE;

        //--------------------------------------------------------
        // Create Components
        //--------------------------------------------------------

        sqr =
        uvm_sequencer #(uart_seq_item)::type_id::create(
        "sqr",this);

        drv =
        uart_driver::type_id::create(
        "drv",this);

        wr_mon =
        uart_wr_monitor::type_id::create(
        "wr_mon",this);

    endfunction

    //------------------------------------------------------------
    // Connect Phase
    //------------------------------------------------------------

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        //--------------------------------------------------------
        // Driver <-> Sequencer Connection
        //--------------------------------------------------------

        drv.seq_item_port.connect(
        sqr.seq_item_export);

        `uvm_info(get_type_name(),
                  "Driver Connected To Sequencer",
                  UVM_LOW)

    endfunction

    //------------------------------------------------------------
    // Report Phase
    //------------------------------------------------------------

    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "UART TX Agent Build Successful",
                  UVM_LOW)

    endfunction

endclass

`endif