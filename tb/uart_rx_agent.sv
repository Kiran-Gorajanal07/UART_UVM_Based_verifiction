`ifndef UART_RX_AGENT_SV
`define UART_RX_AGENT_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_rx_agent.sv
//
// Description:
// Passive UART RX Agent
//
// Current Project
// ----------------
// Contains uart_tx_monitor which monitors the DUT serial TX line.
//
// Future Project
// --------------
// When UART_RX is added inside the DUT,
// replace uart_tx_monitor with uart_rx_monitor.
// No other environment changes are required.
//
//////////////////////////////////////////////////////////////////////////////////

class uart_rx_agent extends uvm_agent;

    `uvm_component_utils(uart_rx_agent)

    //------------------------------------------------------------
    // Components
    //------------------------------------------------------------

    uart_tx_monitor mon;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------

    function new(string name="uart_rx_agent",
                 uvm_component parent);

        super.new(name,parent);

    endfunction

    //------------------------------------------------------------
    // Build Phase
    //------------------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        `uvm_info(get_type_name(),
                  "Building UART RX Agent",
                  UVM_LOW)

        //--------------------------------------------------------
        // Passive Agent
        //--------------------------------------------------------

        is_active = UVM_PASSIVE;

        //--------------------------------------------------------
        // Create Monitor
        //--------------------------------------------------------

        mon = uart_tx_monitor::type_id::create(
              "mon",
              this);

    endfunction

    //------------------------------------------------------------
    // Connect Phase
    //------------------------------------------------------------

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        `uvm_info(get_type_name(),
                  "UART RX Agent Connected",
                  UVM_LOW)

    endfunction

    //------------------------------------------------------------
    // Report Phase
    //------------------------------------------------------------

    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "UART RX Agent Build Successful",
                  UVM_LOW)

    endfunction

endclass

`endif