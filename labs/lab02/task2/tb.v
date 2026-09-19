module tb;

  reg [2:0] t_sel;
  wire [7:0] t_dout;

  lut #(
    .WIDTH(8),
    .DEPTH(8)
  ) U1 (
    .sel  (t_sel),
    .dout (t_dout)
  );

  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, U1);
    end
  end

  integer i;
  integer errors;

  initial begin
    errors = 0;
    t_sel = 0;

    #1;

    for (i = 0; i < 8; i = i + 1) begin
      t_sel = i;
      #1;

      if (t_dout !== (i * i)) begin
        $display("FAIL: sel=%0d dout=%0d expected=%0d",
                 i, t_dout, i*i);
        errors = errors + 1;
      end
      else begin
        $display("PASS: sel=%0d dout=%0d",
                 i, t_dout);
      end
    end

    if (errors == 0)
      $display("TASK 2 PASS: 8/8 locations correct");
    else
      $display("TASK 2 FAIL: %0d errors", errors);

    $finish;
  end

endmodule