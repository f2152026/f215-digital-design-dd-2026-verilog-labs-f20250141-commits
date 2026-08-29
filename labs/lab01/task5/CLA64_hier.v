module cla64_hier (
    input  [63:0] a,
    input  [63:0] b,
    input         cin,
    output [63:0] sum,
    output        cout
);

    wire [63:0] p;
    wire [63:0] g;

    genvar i;

    generate
        for (i = 0; i < 64; i = i + 1) begin : GEN_PG
            xor #(2) p_gate(p[i], a[i], b[i]);
            and #(2) g_gate(g[i], a[i], b[i]);
        end
    endgenerate

    wire [15:0] BP;
    wire [15:0] BG;

    genvar j;

    generate
        for (j = 0; j < 16; j = j + 1) begin : GEN_BLOCK_PG
            wire p0, p1, p2, p3;
            wire g0, g1, g2, g3;

            assign #2 p0 = p[(j*4)+0];
            assign #2 p1 = p[(j*4)+1];
            assign #2 p2 = p[(j*4)+2];
            assign #2 p3 = p[(j*4)+3];

            assign #2 g0 = g[(j*4)+0];
            assign #2 g1 = g[(j*4)+1];
            assign #2 g2 = g[(j*4)+2];
            assign #2 g3 = g[(j*4)+3];

            assign #2 BP[j] = p3 & p2 & p1 & p0;

            assign #2 BG[j] =
                    g3 |
                    (p3 & g2) |
                    (p3 & p2 & g1) |
                    (p3 & p2 & p1 & g0);
        end
    endgenerate

    wire [3:0] GP;
    wire [3:0] GG;

    assign #2 GP[0] = BP[3] & BP[2] & BP[1] & BP[0];

    assign #2 GG[0] =
            BG[3] |
            (BP[3] & BG[2]) |
            (BP[3] & BP[2] & BG[1]) |
            (BP[3] & BP[2] & BP[1] & BG[0]);

    assign #2 GP[1] = BP[7] & BP[6] & BP[5] & BP[4];

    assign #2 GG[1] =
            BG[7] |
            (BP[7] & BG[6]) |
            (BP[7] & BP[6] & BG[5]) |
            (BP[7] & BP[6] & BP[5] & BG[4]);

    assign #2 GP[2] = BP[11] & BP[10] & BP[9] & BP[8];

    assign #2 GG[2] =
            BG[11] |
            (BP[11] & BG[10]) |
            (BP[11] & BP[10] & BG[9]) |
            (BP[11] & BP[10] & BP[9] & BG[8]);

    assign #2 GP[3] = BP[15] & BP[14] & BP[13] & BP[12];

    assign #2 GG[3] =
            BG[15] |
            (BP[15] & BG[14]) |
            (BP[15] & BP[14] & BG[13]) |
            (BP[15] & BP[14] & BP[13] & BG[12]);

    wire [4:0] GC;

    assign #2 GC[0] = cin;

    assign #2 GC[1] =
            GG[0] |
            (GP[0] & GC[0]);

    assign #2 GC[2] =
            GG[1] |
            (GP[1] & GG[0]) |
            (GP[1] & GP[0] & GC[0]);

    assign #2 GC[3] =
            GG[2] |
            (GP[2] & GG[1]) |
            (GP[2] & GP[1] & GG[0]) |
            (GP[2] & GP[1] & GP[0] & GC[0]);

    assign #2 GC[4] =
            GG[3] |
            (GP[3] & GG[2]) |
            (GP[3] & GP[2] & GG[1]) |
            (GP[3] & GP[2] & GP[1] & GG[0]) |
            (GP[3] & GP[2] & GP[1] & GP[0] & GC[0]);

    wire [16:0] C;

    assign #2 C[0] = GC[0];

    assign #2 C[1] =
            BG[0] |
            (BP[0] & C[0]);

    assign #2 C[2] =
            BG[1] |
            (BP[1] & BG[0]) |
            (BP[1] & BP[0] & C[0]);

    assign #2 C[3] =
            BG[2] |
            (BP[2] & BG[1]) |
            (BP[2] & BP[1] & BG[0]) |
            (BP[2] & BP[1] & BP[0] & C[0]);

    assign #2 C[4] = GC[1];

    assign #2 C[5] =
            BG[4] |
            (BP[4] & C[4]);

    assign #2 C[6] =
            BG[5] |
            (BP[5] & BG[4]) |
            (BP[5] & BP[4] & C[4]);

    assign #2 C[7] =
            BG[6] |
            (BP[6] & BG[5]) |
            (BP[6] & BP[5] & BG[4]) |
            (BP[6] & BP[5] & BP[4] & C[4]);

    assign #2 C[8] = GC[2];

    assign #2 C[9] =
            BG[8] |
            (BP[8] & C[8]);

    assign #2 C[10] =
            BG[9] |
            (BP[9] & BG[8]) |
            (BP[9] & BP[8] & C[8]);

    assign #2 C[11] =
            BG[10] |
            (BP[10] & BG[9]) |
            (BP[10] & BP[9] & BG[8]) |
            (BP[10] & BP[9] & BP[8] & C[8]);

    assign #2 C[12] = GC[3];

    assign #2 C[13] =
            BG[12] |
            (BP[12] & C[12]);

    assign #2 C[14] =
            BG[13] |
            (BP[13] & BG[12]) |
            (BP[13] & BP[12] & C[12]);

    assign #2 C[15] =
            BG[14] |
            (BP[14] & BG[13]) |
            (BP[14] & BP[13] & BG[12]) |
            (BP[14] & BP[13] & BP[12] & C[12]);

    assign #2 C[16] = GC[4];

    wire [15:0] unused_block_cout;

    generate
        for (j = 0; j < 16; j = j + 1) begin : GEN_CLA4
            cla4 block (
                .a   (a[(j*4)+3 : (j*4)]),
                .b   (b[(j*4)+3 : (j*4)]),
                .cin (C[j]),
                .sum (sum[(j*4)+3 : (j*4)]),
                .cout(unused_block_cout[j])
            );
        end
    endgenerate

    assign cout = C[16];

endmodule