`ifndef UART_BASE_SEQ_SV
`define UART_BASE_SEQ_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_base_seq.sv
//
// Description:
// Base random sequence for UART FIFO TX verification
//////////////////////////////////////////////////////////////////////////////////

class uart_base_seq extends uvm_sequence #(uart_seq_item);

    `uvm_object_utils(uart_base_seq)

    //------------------------------------------------------------
    // Number of Transactions
    //------------------------------------------------------------
    rand int unsigned num_transactions;

    constraint num_transactions_c {
        num_transactions inside {[10:30]};
    }

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name = "uart_base_seq");
        super.new(name);
    endfunction

    //------------------------------------------------------------
    // Sequence Body
    //------------------------------------------------------------
    virtual task body();

        uart_seq_item req;
        int txn_id = 0;

        `uvm_info(get_type_name(),
                  "========================================",
                  UVM_LOW)

        `uvm_info(get_type_name(),
                  "Starting UART Base Sequence",
                  UVM_LOW)

        `uvm_info(get_type_name(),
                  "========================================",
                  UVM_LOW)

        repeat(num_transactions)
        begin

            req = uart_seq_item::type_id::create($sformatf("req_%0d", txn_id));

            start_item(req);

            if(!req.randomize())
            begin
                `uvm_fatal(get_type_name(),
                           "Transaction Randomization Failed")
            end

            finish_item(req);

            `uvm_info(get_type_name(),
                      {"Generated Transaction\n",
                       req.convert2string()},
                      UVM_MEDIUM)

            txn_id++;

        end

        `uvm_info(get_type_name(),
                  "========================================",
                  UVM_LOW)

        `uvm_info(get_type_name(),
                  $sformatf("Sequence Completed Successfully. Total Transactions = %0d",
                            txn_id),
                  UVM_LOW)

        `uvm_info(get_type_name(),
                  "========================================",
                  UVM_LOW)

    endtask

endclass

`endif