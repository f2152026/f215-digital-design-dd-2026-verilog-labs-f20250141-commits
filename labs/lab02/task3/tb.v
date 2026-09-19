module tb;

    reg [1:0] t_A;
    reg [1:0] t_B;

    wire t_GT;
    wire t_LT;
    wire t_EQ;

    reg exp_GT;
    reg exp_LT;
    reg exp_EQ;

    integer errors;
    integer total;
    integer i;

    comp2 U1 (
        .A  (t_A),
        .B  (t_B),
        .GT (t_GT),
        .LT (t_LT),
        .EQ (t_EQ)
    );

    initial begin
        errors = 0;
        total = 0;

        for (i = 0; i < 16; i = i + 1) begin
            t_A = i[3:2];
            t_B = i[1:0];

            #1;

            exp_GT = 0;
            exp_LT = 0;
            exp_EQ = 0;

            if (t_A > t_B)
                exp_GT = 1;
            else if (t_A < t_B)
                exp_LT = 1;
            else
                exp_EQ = 1;

            total = total + 1;

            if ({t_GT, t_LT, t_EQ} !== {exp_GT, exp_LT, exp_EQ}) begin
                $display("FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
                         $time, t_A, t_B,
                         t_GT, t_LT, t_EQ,
                         exp_GT, exp_LT, exp_EQ);
                errors = errors + 1;
            end
            else begin
                $display("PASS at time %0t: A=%b B=%b GT=%b LT=%b EQ=%b",
                         $time, t_A, t_B,
                         t_GT, t_LT, t_EQ);
            end
        end

        $display("----------------------------------------");
        $display("TASK 3: %0d/%0d tests passed", total-errors, total);
        $display("Errors: %0d", errors);
        $display("----------------------------------------");

        $finish;
    end

endmodule