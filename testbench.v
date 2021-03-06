`timescale 1ns / 1ps

module general_tb #(
        parameter N_FLITS = 10000

    )();

    reg clk;
    reg [127 : 0] in;
    wire [127 : 0] comp_out;
    wire [7 : 0] count;
    wire [2:0] en_bits;
    // reg [127: 0] ram [4 : 0];

    integer i=0;
    real compr_ratio=0, avg_ratio=0;

    compressor compr(
                   .clk_in(clk),
                   .data_in(in),
                   .data_out(comp_out),
                   .en_out(en_bits),
                   .is_head(1'b0)
               );

    en_table en_tab(
                 .en_bits(en_bits),
                 .count(count) // compressed data count
             );

    always #5
        clk = ~clk; // flip clk every 5ns


    always #30 begin
        in <= {{$random}, {$random}, {$random}, {$random}}; // typical base flit
        #20
         $display("[DATA LOG] flit %0d - input=0x%H    compressed=0x%H    en_bits=%b    compressed-size=%0d", i, in, comp_out, en_bits, count);
        compr_ratio = (128 - count)/128.0;



        if (i == N_FLITS) begin
            $display("[TEST RESULT] Average compression ratio=%0.2f%%", 100*(avg_ratio)/N_FLITS);
            $stop;
        end
        i = i + 1;
        avg_ratio = avg_ratio + compr_ratio;

    end

    initial begin
        clk <= 0;

    end

endmodule  //general_tb

