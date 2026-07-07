`ifndef UART_TX_MONITOR_SV
`define UART_TX_MONITOR_SV

class uart_tx_monitor extends uvm_monitor;

    `uvm_component_utils(uart_tx_monitor)

    //------------------------------------------------------------
    // Virtual Interface
    //------------------------------------------------------------
    virtual uart_if.TX_MONITOR vif;

    //------------------------------------------------------------
    // Analysis Port
    //------------------------------------------------------------
    uvm_analysis_port #(uart_seq_item) ap;

    //------------------------------------------------------------
    // UART Configuration
    //------------------------------------------------------------
    int unsigned baud_div = 4;

    //------------------------------------------------------------
    // Statistics
    //------------------------------------------------------------
    int frame_count;
    int parity_error_count;
    int framing_error_count;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name="uart_tx_monitor",
                 uvm_component parent);

        super.new(name,parent);

        ap = new("ap",this);

    endfunction

    //------------------------------------------------------------
    // Build Phase
    //------------------------------------------------------------
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(virtual uart_if.TX_MONITOR)::get(
                this,"","vif",vif))
        begin
            `uvm_fatal(get_type_name(),
                       "TX_MONITOR Virtual Interface Not Found")
        end

        void'(uvm_config_db#(int unsigned)::get(
                this,"","baud_div",baud_div));

    endfunction

    //------------------------------------------------------------
    // Run Phase
    //------------------------------------------------------------
    task run_phase(uvm_phase phase);

        uart_seq_item tr;

        bit [7:0] rx_data;
        bit parity_bit;
        bit stop_bit;

        forever
        begin

            wait(vif.rst == 0);

            //----------------------------------------------------
            // Wait for Start Bit
            //----------------------------------------------------
            @(negedge vif.tx);

            //----------------------------------------------------
            // Middle of Start Bit
            //----------------------------------------------------
            repeat(baud_div/2)
                @(posedge vif.clk);

            if(vif.tx !== 1'b0)
            begin
                `uvm_warning(get_type_name(),
                             "False Start Bit")
                continue;
            end

            //----------------------------------------------------
            // Receive Data
            //----------------------------------------------------
            rx_data = 8'h00;

            for(int i=0;i<8;i++)
            begin
                repeat(baud_div)
                    @(posedge vif.clk);

                rx_data[i] = vif.tx;
            end

            //----------------------------------------------------
            // Receive Parity
            //----------------------------------------------------
            repeat(baud_div)
                @(posedge vif.clk);

            parity_bit = vif.tx;

            //----------------------------------------------------
            // Receive Stop
            //----------------------------------------------------
            repeat(baud_div)
                @(posedge vif.clk);

            stop_bit = vif.tx;

            //----------------------------------------------------
            // Create Transaction
            //----------------------------------------------------
            tr = uart_seq_item::type_id::create("tr");

            tr.timestamp      = $time;
            tr.data           = rx_data;
            tr.parity_error   = (parity_bit !== (^rx_data));
            tr.framing_error  = (stop_bit   !== 1'b1);

            frame_count++;

            if(tr.parity_error)
                parity_error_count++;

            if(tr.framing_error)
                framing_error_count++;

            `uvm_info(get_type_name(),
                      {"UART Frame Received\n",
                       tr.convert2string()},
                      UVM_MEDIUM)

            ap.write(tr);

        end

    endtask

    //------------------------------------------------------------
    // Report Phase
    //------------------------------------------------------------
    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "========================================",
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("Frames Received : %0d",
                            frame_count),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("Parity Errors  : %0d",
                            parity_error_count),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  $sformatf("Framing Errors : %0d",
                            framing_error_count),
                  UVM_NONE)

        `uvm_info(get_type_name(),
                  "========================================",
                  UVM_NONE)

    endfunction

endclass

`endif