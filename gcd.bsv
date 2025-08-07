interface GCD;
  method Action start (Bit#(32)) a, Bit#(32) b);
  method ActionValue#(Bit#(32)) getResult;
endinterface

rule invokeGCD;
  let x = tpl_1(inQ.first);
  let y = tpl_2(inQ.first);
    gcd.start(x,y);
    inQ.deq;
  endrule

rule getResult;
    let x <- gcd.getResult;
    outQ.enq(x)
endrule

module mkGCD (GCD);
  Reg#(Bit#(32)) x <- mkReg(0);
  Reg#(Bit#(32)) y <- mkReg(0);
  Reg#(Bool) busy_flag <- mkReg(False);

  rule gcd;
    if (x >= y) begin x <= x - y; end //subtract
    else if (x != 0) begin x <= y; y <= x; end //swap
  endrule

  method Action start(Bit#(32) a, Bit#(32) b) if (!busy_flag);
    x <= a; y<= b; busy_flag <= True;
  endmethod

  method ActionValue(Bit#(32)) getResult if (busy_flag && (x==0));
    busy_flag <= False; return y;
  endmethod
endmodule
