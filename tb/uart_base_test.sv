`ifndef UART_BASE_TEST_SV
`define UART_BASE_TEST_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_base_test.sv
//
// Description:
// Base Test
//
//////////////////////////////////////////////////////////////////////////////////

class uart_base_test extends uvm_test;

    `uvm_component_utils(uart_base_test)

    //------------------------------------------------------------
    // Environment
    //------------------------------------------------------------

    uart_env env;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------

    function new(string name="uart_base_test",
                 uvm_component parent=null);

        super.new(name,parent);

    endfunction

    //------------------------------------------------------------
    // Build Phase
    //------------------------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        `uvm_info(get_type_name(),
                  "Building UART Base Test",
                  UVM_LOW)

        env = uart_env::type_id::create(
              "env",
              this);

    endfunction

    //------------------------------------------------------------
    // End Of Elaboration
    //------------------------------------------------------------

    function void end_of_elaboration_phase(uvm_phase phase);

        super.end_of_elaboration_phase(phase);

        uvm_root::get().print_topology();
      
    endfunction

    //------------------------------------------------------------
    // Run Phase
    //------------------------------------------------------------

    task run_phase(uvm_phase phase);

        uart_base_seq seq;

        phase.raise_objection(this);

        `uvm_info(get_type_name(),
                  "Starting UART Base Test",
                  UVM_LOW)

        //--------------------------------------------------------
        // Create Sequence
        //--------------------------------------------------------

        seq = uart_base_seq::type_id::create("seq");

        //--------------------------------------------------------
        // Randomize Number Of Transactions
        //--------------------------------------------------------

        if(!seq.randomize())
        begin
            `uvm_fatal(get_type_name(),
                       "Sequence Randomization Failed")
        end

        //--------------------------------------------------------
        // Start Sequence
        //--------------------------------------------------------

        seq.start(env.tx_agent.sqr);

        //--------------------------------------------------------
        // Wait For UART To Finish
        //--------------------------------------------------------

        #50000;

        `uvm_info(get_type_name(),
                  "UART Base Test Completed",
                  UVM_LOW)

        phase.drop_objection(this);

    endtask

    //------------------------------------------------------------
    // Report Phase
    //------------------------------------------------------------

    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "UART Base Test Finished",
                  UVM_NONE);

    endfunction

endclass

`endif