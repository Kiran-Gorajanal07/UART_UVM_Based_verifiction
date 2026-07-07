`ifndef UART_WR_MONITOR_SV
`define UART_WR_MONITOR_SV

//////////////////////////////////////////////////////////////////////////////////
// Project : UART FIFO TX Verification
// File    : uart_wr_monitor.sv
//
// Description:
// Passive monitor for FIFO write interface.
// Captures every write transaction entering the FIFO.
//
//////////////////////////////////////////////////////////////////////////////////

class uart_wr_monitor extends uvm_monitor;

    `uvm_component_utils(uart_wr_monitor)

    //------------------------------------------------------------
    // Virtual Interface
    //------------------------------------------------------------
    virtual uart_if.WR_MONITOR vif;

    //------------------------------------------------------------
    // Analysis Port
    //------------------------------------------------------------
    uvm_analysis_port #(uart_seq_item) ap;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name="uart_wr_monitor",
                 uvm_component parent);

        super.new(name,parent);

        ap = new("ap",this);

    endfunction

    //------------------------------------------------------------
    // Build Phase
    //------------------------------------------------------------
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(virtual uart_if.WR_MONITOR)::get(
                this,
                "",
                "vif",
                vif))
        begin
            `uvm_fatal(get_type_name(),
                       "Failed to get WR_MONITOR Virtual Interface")
        end

    endfunction

    //------------------------------------------------------------
    // Run Phase
    //------------------------------------------------------------
    task run_phase(uvm_phase phase);

        uart_seq_item tr;
        int transaction_count = 0;

        `uvm_info(get_type_name(),
                  "Write Monitor Started",
                  UVM_LOW)

        forever
        begin

            @(posedge vif.clk);

            //----------------------------------------------------
            // Ignore Reset
            //----------------------------------------------------
            if(vif.rst)
                continue;

            //----------------------------------------------------
            // Capture FIFO Write
            //----------------------------------------------------
            if(vif.wr_en)
            begin

                tr = uart_seq_item::type_id::create(
                        $sformatf("wr_tr_%0d",
                        transaction_count));

                tr.transaction_id = transaction_count;
                tr.timestamp      = $time;
                tr.data           = vif.data_in;

                //------------------------------------------------
                // Report
                //------------------------------------------------
                `uvm_info(get_type_name(),
                          {"Captured FIFO Write\n",
                           tr.convert2string()},
                          UVM_MEDIUM)

                //------------------------------------------------
                // Broadcast Transaction
                //------------------------------------------------
                ap.write(tr);

                transaction_count++;

            end

        end

    endtask

endclass

`endif