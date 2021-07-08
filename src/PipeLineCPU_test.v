`timescale 1ns / 1ps

module test ();
    reg reset;
    reg clk;
    
    PipeLineCPU PipeLineCPU_1(reset, clk);
    
    initial begin
        reset = 1;
        clk = 1;
        #100 reset = 0;
    end
    
    always #50 clk = ~clk;
endmodule