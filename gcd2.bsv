package GCD;

import FIFO :: *;
import GetPut :: *;
import ClientServer :: *;
import StmtFSM :: *;

// ----------------------------
// GCD Interface
// ----------------------------
interface GCD_IFC;
    method Action start(UInt#(32) x, UInt#(32) y);
    method Bool done();
    method UInt#(32) result();
endinterface

// ----------------------------
// GCD Module Implementation
// ----------------------------
module mkGCD(GCD_IFC);

    Reg#(UInt#(32)) a <- mkReg(0);
    Reg#(UInt#(32)) b <- mkReg(0);
    Reg#(Bool) running <- mkReg(False);

    rule gcd_compute(running && (a != b));
        if (a > b) 
            a <= a - b;
        else 
            b <= b - a;
    endrule

    rule done_rule(running && (a == b));
        running <= False;
    endrule

    // Methods MUST come after rules!
    method Action start(UInt#(32) x, UInt#(32) y);
        a <= x;
        b <= y;
        running <= True;
    endmethod

    method Bool done();
        return running && (a == b);
    endmethod

    method UInt#(32) result();
        return a;
    endmethod

endmodule

// ----------------------------
// Testbench Top Module
// ----------------------------
module mkGCD_Top();

    GCD_IFC dut <- mkGCD;

    Stmt test = seq
        $display("Starting GCD simulation...");
        dut.start(48, 18);
        while (!dut.done()) 
            $display("Computing...");
        $display("GCD result: %0d", dut.result());
        $finish;
    endseq;

    mkAutoFSM(test);

endmodule

endpackage
