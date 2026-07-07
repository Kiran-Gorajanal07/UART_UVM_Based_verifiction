`ifndef UART_SCOREBOARD_SV
`define UART_SCOREBOARD_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_scoreboard.sv
//
// Description:
// Scoreboard compares the data written into FIFO with the data
// transmitted by UART TX.
//////////////////////////////////////////////////////////////////////////////////

class uart_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(uart_scoreboard)

    //------------------------------------------------------------
    // Analysis Imports
    //------------------------------------------------------------
    uvm_analysis_imp_exp #(uart_seq_item, uart_scoreboard) exp_imp;
    uvm_analysis_imp_act #(uart_seq_item, uart_scoreboard) act_imp;

    //------------------------------------------------------------
    // Expected Queue
    //------------------------------------------------------------
    uart_seq_item exp_queue[$];

    //------------------------------------------------------------
    // Statistics
    //------------------------------------------------------------
    int total_expected;
    int total_received;
    int compare_count;
    int pass_count;
    int fail_count;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name="uart_scoreboard",
                 uvm_component parent);

        super.new(name,parent);

        exp_imp = new("exp_imp", this);
        act_imp = new("act_imp", this);

    endfunction

    //------------------------------------------------------------
    // Expected Transaction
    //------------------------------------------------------------
    function void write_exp(uart_seq_item tr);

        uart_seq_item item;

        item = uart_seq_item::type_id::create("item");
        item.copy(tr);

        exp_queue.push_back(item);

        total_expected++;

        `uvm_info(get_type_name(),
                  $sformatf("Expected Data Queued : 0x%02h",
                            item.data),
                  UVM_MEDIUM)

    endfunction

    //------------------------------------------------------------
    // Actual Transaction
    //------------------------------------------------------------
    function void write_act(uart_seq_item tr);

        uart_seq_item exp_tr;

        total_received++;

        //--------------------------------------------------------
        // Queue Empty
        //--------------------------------------------------------
        if(exp_queue.size()==0)
        begin

            fail_count++;

            `uvm_error(get_type_name(),
                $sformatf("Unexpected UART Data = 0x%02h (Expected Queue Empty)",
                          tr.data))

            return;

        end

        //--------------------------------------------------------
        // Pop Expected Transaction
        //--------------------------------------------------------
        exp_tr = exp_queue.pop_front();

        compare_count++;

        //--------------------------------------------------------
        // Compare
        //--------------------------------------------------------
        if((exp_tr.data == tr.data) &&
           (!tr.parity_error) &&
           (!tr.framing_error))
        begin

            pass_count++;

            `uvm_info(get_type_name(),
                $sformatf("COMPARE[%0d] PASS | Expected=0x%02h | Received=0x%02h",
                          compare_count,
                          exp_tr.data,
                          tr.data),
                UVM_LOW)

        end
        else
        begin

            fail_count++;

            `uvm_error(get_type_name(),
                $sformatf("COMPARE[%0d] FAIL | Expected=0x%02h | Received=0x%02h | Parity=%0b | Framing=%0b",
                          compare_count,
                          exp_tr.data,
                          tr.data,
                          tr.parity_error,
                          tr.framing_error))

        end

    endfunction

    //------------------------------------------------------------
    // Report Phase
    //------------------------------------------------------------
    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "==========================================",
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  "UART SCOREBOARD REPORT",
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  "==========================================",
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("Expected Transactions : %0d",
                            total_expected),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("Received Transactions : %0d",
                            total_received),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("Total Comparisons     : %0d",
                            compare_count),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("PASS                  : %0d",
                            pass_count),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("FAIL                  : %0d",
                            fail_count),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("Pending Queue Entries : %0d",
                            exp_queue.size()),
                  UVM_NONE)

        if((fail_count == 0) && (exp_queue.size() == 0))
        begin
            `uvm_info(get_type_name(),
                      "*************** TEST PASSED ***************",
                      UVM_NONE)
        end
        else
        begin
            `uvm_error(get_type_name(),
                       "*************** TEST FAILED ***************")
        end

        `uvm_info(get_type_name(),
                  "==========================================",
                  UVM_NONE)

    endfunction

endclass

`endif