// FA_Gate.v
// Gate-level model of a 1-bit full adder. No delays yet -- that starts in
// Task 2. This task is purely about gate ordering.
//
// Part (a): leave this file exactly as it is, compile, and simulate.
// Part (b): AFTER completing part (a), come back and reorder the five gate
//           instantiations below into any different sequence, then
//           re-simulate with the same tb.v and compare.

module FA_Gate(
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  wire ps;
  wire pc1;
  wire pc2;

  xor #(2) x1(ps, a, b);
  and #(2) a1(pc1, a, b);
  and #(2) a2(pc2, cin, ps);
  xor #(2) x2(sum, cin, ps);
  or  #(2) o1(cout, pc1, pc2);

endmodule
