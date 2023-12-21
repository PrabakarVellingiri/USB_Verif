class wb_slave_sequence extends uvm_sequence#(wb_slave_sequence_item);

   `uvm_object_utils(wb_slave_sequence)

  function new(string name = "wb_slave_sequence");
      super.new(name);
   endfunction
  
  virtual task body();
    begin
      repeat(5)
        begin
          req=wb_slave_sequence_item::type_id::create("req");
          wait_for_grant();
          req.randomize();
          send_request(req);
          wait_for_item_done();
        end
    end
  endtask


endclass
