`ifndef UART_DRIVER_SV
`define UART_DRIVER_SV

class uart_driver extends uvm_driver #(uart_seq_item);

    `uvm_component_utils(uart_driver)

    //------------------------------------------------------------
    // Virtual Interface
    //------------------------------------------------------------
    virtual uart_if.DRIVER vif;

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name="uart_driver",
                 uvm_component parent);
        super.new(name,parent);
    endfunction

    //------------------------------------------------------------
    // Build Phase
    //------------------------------------------------------------
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(virtual uart_if.DRIVER)::get(
                this,"","vif",vif))
        begin
            `uvm_fatal(get_type_name(),
                       "Failed to get DRIVER Virtual Interface")
        end

    endfunction

    //------------------------------------------------------------
    // Initialize Interface
    //------------------------------------------------------------
    task initialize_interface();

        vif.wr_en   <= 0;
        vif.data_in <= 8'h00;

    endtask

    //------------------------------------------------------------
    // Drive Transaction
    //------------------------------------------------------------
    task drive_transaction(uart_seq_item tr);

        @(posedge vif.clk);

        vif.wr_en   <= 1'b1;
        vif.data_in <= tr.data;

        tr.timestamp = $time;

        `uvm_info(get_type_name(),
                  $sformatf("Writing DATA = 0x%02h",tr.data),
                  UVM_MEDIUM)

        @(posedge vif.clk);

        vif.wr_en   <= 1'b0;
        vif.data_in <= 8'h00;

        repeat(tr.gap)
            @(posedge vif.clk);

    endtask

    //------------------------------------------------------------
    // Run Phase
    //------------------------------------------------------------
    task run_phase(uvm_phase phase);

        uart_seq_item tr;

        initialize_interface();

        wait(vif.rst == 0);

        `uvm_info(get_type_name(),
                  "Reset Released",
                  UVM_LOW)

        forever
        begin

            seq_item_port.get_next_item(tr);

            drive_transaction(tr);

            seq_item_port.item_done();

        end

    endtask

endclass

`endif