`ifndef UART_ENV_SV
`define UART_ENV_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_env.sv
//
// Description:
// UART Verification Environment
//
// Contains:
//   - TX Agent (Active)
//   - RX Agent (Passive)
//   - Scoreboard
//   - Functional Coverage
//
//////////////////////////////////////////////////////////////////////////////////

class uart_env extends uvm_env;

    `uvm_component_utils(uart_env)

    //------------------------------------------------------------
    // Components
    //------------------------------------------------------------
    uart_tx_agent     tx_agent;
    uart_rx_agent     rx_agent;
    uart_scoreboard   sb;
    uart_coverage     cov;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name = "uart_env",
                 uvm_component parent = null);

        super.new(name,parent);

    endfunction

    //------------------------------------------------------------
    // Build Phase
    //------------------------------------------------------------
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        `uvm_info(get_type_name(),
                  "Building UART Environment",
                  UVM_LOW)

        //--------------------------------------------------------
        // Create Components
        //--------------------------------------------------------
        tx_agent = uart_tx_agent::type_id::create(
                        "tx_agent",
                        this);

        rx_agent = uart_rx_agent::type_id::create(
                        "rx_agent",
                        this);

        sb = uart_scoreboard::type_id::create(
                        "sb",
                        this);

        cov = uart_coverage::type_id::create(
                        "cov",
                        this);

    endfunction

    //------------------------------------------------------------
    // Connect Phase
    //------------------------------------------------------------
    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        //--------------------------------------------------------
        // Write Monitor --> Scoreboard (Expected)
        //--------------------------------------------------------
        tx_agent.wr_mon.ap.connect(sb.exp_imp);

        //--------------------------------------------------------
        // TX Monitor --> Scoreboard (Actual)
        //--------------------------------------------------------
        rx_agent.mon.ap.connect(sb.act_imp);

        //--------------------------------------------------------
        // Write Monitor --> Coverage
        //--------------------------------------------------------
        tx_agent.wr_mon.ap.connect(cov.txcov_imp);

        //--------------------------------------------------------
        // TX Monitor --> Coverage
        //--------------------------------------------------------
        rx_agent.mon.ap.connect(cov.rxcov_imp);

        `uvm_info(get_type_name(),
                  "Environment Connections Completed",
                  UVM_LOW)

    endfunction

    //------------------------------------------------------------
    // End of Elaboration
    //------------------------------------------------------------
    function void end_of_elaboration_phase(uvm_phase phase);

        super.end_of_elaboration_phase(phase);

        `uvm_info(get_type_name(),
                  "Printing UVM Topology",
                  UVM_LOW)

        uvm_root::get().print_topology();
      
    endfunction

    //------------------------------------------------------------
    // Report Phase
    //------------------------------------------------------------
    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "UART Environment Completed Successfully",
                  UVM_LOW)

    endfunction

endclass

`endif