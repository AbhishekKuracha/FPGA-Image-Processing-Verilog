`timescale 1ns/1ps

`include "parameter.v"

// ================= Testbench ==================

module tb_simulation;

// -------- Signals --------

reg HCLK;
reg HRESETn;

wire vsync;
wire hsync;

wire [7:0] data_R0;
wire [7:0] data_G0;
wire [7:0] data_B0;
wire [7:0] data_R1;
wire [7:0] data_G1;
wire [7:0] data_B1;

wire enc_done;

// -------- Instantiate image_read --------

image_read #(.INFILE(`INPUTFILENAME)) u_image_read
(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .VSYNC(vsync),
    .HSYNC(hsync),

    .DATA_R0(data_R0),
    .DATA_G0(data_G0),
    .DATA_B0(data_B0),

    .DATA_R1(data_R1),
    .DATA_G1(data_G1),
    .DATA_B1(data_B1),

    .ctrl_done(enc_done)
);

// -------- Instantiate image_write --------

image_write #(.INFILE(`OUTPUTFILENAME)) u_image_write
(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .hsync(hsync),

    .DATA_WRITE_R0(data_R0),
    .DATA_WRITE_G0(data_G0),
    .DATA_WRITE_B0(data_B0),

    .DATA_WRITE_R1(data_R1),
    .DATA_WRITE_G1(data_G1),
    .DATA_WRITE_B1(data_B1),

    .Write_Done()
);

// -------- Clock generation --------

initial begin
    HCLK = 0;
    forever #10 HCLK = ~HCLK;   // 50 MHz clock
end

// -------- Reset + Stop Simulation --------

initial begin
    HRESETn = 0;
    #25;
    HRESETn = 1;

    // Wait enough time for full image processing
    #300000000;   // 300 ms (safe for large image)

    $display("Simulation completed.");
    $finish;
end

endmodule
