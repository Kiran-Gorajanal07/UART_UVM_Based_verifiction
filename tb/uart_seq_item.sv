`ifndef UART_SEQ_ITEM_SV
`define UART_SEQ_ITEM_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_seq_item.sv
// Description:
// Transaction used between Sequence, Driver, Monitor and Scoreboard.
//////////////////////////////////////////////////////////////////////////////////

class uart_seq_item extends uvm_sequence_item;

    `uvm_object_utils(uart_seq_item)

    //------------------------------------------------------------
    // Stimulus Fields
    //------------------------------------------------------------
    rand bit [7:0] data;

    // Gap between two write operations
    rand int unsigned gap;

    //------------------------------------------------------------
    // Response Fields
    //------------------------------------------------------------
    bit parity_error;
    bit framing_error;

    //------------------------------------------------------------
    // Debug Fields
    //------------------------------------------------------------
    int unsigned transaction_id;
    time timestamp;

    //------------------------------------------------------------
    // Constraints
    //------------------------------------------------------------
    constraint gap_c
    {
        gap inside {[5:40]};
    }

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name="uart_seq_item");
        super.new(name);
    endfunction

    //------------------------------------------------------------
    // Copy Function
    //------------------------------------------------------------
    function void do_copy(uvm_object rhs);

        uart_seq_item rhs_;

        if(!$cast(rhs_, rhs))
            `uvm_fatal(get_type_name(),
                       "do_copy() Cast Failed")

        super.do_copy(rhs);

        data            = rhs_.data;
        gap             = rhs_.gap;
        parity_error    = rhs_.parity_error;
        framing_error   = rhs_.framing_error;
        transaction_id  = rhs_.transaction_id;
        timestamp       = rhs_.timestamp;

    endfunction

    //------------------------------------------------------------
    // Compare Function
    //------------------------------------------------------------
    function bit do_compare(uvm_object rhs,
                        uvm_comparer comparer);

    uart_seq_item rhs_;

    if(!$cast(rhs_, rhs))
        return 0;

    return (data == rhs_.data);

endfunction
    //------------------------------------------------------------
    // Print Function
    //------------------------------------------------------------
    function string convert2string();

    return $sformatf(
        "DATA=0x%02h GAP=%0d PARITY=%0b FRAME=%0b",
        data,
        gap,
        parity_error,
        framing_error
    );

endfunction

endclass

`endif