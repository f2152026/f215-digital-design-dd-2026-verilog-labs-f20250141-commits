`timescale 1ns/1ps

module tb;

    reg [3:0] a;
    reg [3:0] b;
    reg       op;
    wire [3:0] result;

    integer errors;
    integer expected;

    alu DUT (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    task check;
        input [3:0] ta;
        input [3:0] tb;
        input       top;
        begin
            a = ta;
            b = tb;
            op = top;
            #1;

            if (top == 1'b0)
                expected = ta + tb;
            else
                expected = ta - tb;

            if (result !== expected[3:0]) begin
                $display("FAIL: a=%b b=%b op=%b result=%b expected=%b",
                         ta, tb, top, result, expected[3:0]);
                errors = errors + 1;
            end
            else begin
                $display("PASS: a=%b b=%b op=%b result=%b",
                         ta, tb, top, result);
            end
        end
    endtask

    initial begin
        errors = 0;

        check(4'b0011, 4'b0001, 1'b0);
        check(4'b0011, 4'b0001, 1'b1);

        check(4'b0111, 4'b0010, 1'b0);
        check(4'b0111, 4'b0010, 1'b1);

        check(4'b0000, 4'b0001, 1'b0);
        check(4'b0000, 4'b0001, 1'b1);

        check(4'b1111, 4'b0001, 1'b0);
        check(4'b1111, 4'b0001, 1'b1);

        check(4'b1010, 4'b0011, 1'b0);
        check(4'b1010, 4'b0011, 1'b1);

        check(4'b0101, 4'b1001, 1'b0);
        check(4'b0101, 4'b1001, 1'b1);

        check(4'b1100, 4'b0110, 1'b0);
        check(4'b1100, 4'b0110, 1'b1);

        check(4'b0010, 4'b1011, 1'b0);
        check(4'b0010, 4'b1011, 1'b1);

        $display("----------------------------------------");
        $display("TASK 5: %0d errors", errors);

        if (errors == 0)
            $display("TASK 5 PASS");
        else
            $display("TASK 5 FAIL");

        $finish;
    end

endmodule