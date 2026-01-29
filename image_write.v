/****************** Module for writing .bmp image *************/ 
/***********************************************************/ 
// Verilog project: Image processing in Verilog

module image_write #(parameter 
    WIDTH = 768,           // Image width 
    HEIGHT = 512,          // Image height 
    INFILE = "output.bmp", // Output image 
    BMP_HEADER_NUM = 54    // Header size
) 
( 
    input HCLK,           // Clock input 
    input HRESETn,        // Reset active low 
    input hsync,          // Hsync pulse 

    input [7:0] DATA_WRITE_R0, 
    input [7:0] DATA_WRITE_G0, 
    input [7:0] DATA_WRITE_B0, 

    input [7:0] DATA_WRITE_R1, 
    input [7:0] DATA_WRITE_G1, 
    input [7:0] DATA_WRITE_B1, 

    output reg Write_Done 
); 

//--------------------------------------------------
// Internal declarations (YOU MISSED THESE)
//--------------------------------------------------

reg [7:0] BMP_header [0:53];
reg [7:0] out_BMP [0:WIDTH*HEIGHT*3-1];

integer fd;
integer i;
integer data_count;

//-----------------------------------
// BMP HEADER
//-----------------------------------

initial begin 
    BMP_header[0] = 66;   BMP_header[28] = 24; 
    BMP_header[1] = 77;   BMP_header[29] = 0; 
    BMP_header[2] = 54;   BMP_header[30] = 0; 
    BMP_header[3] = 0;    BMP_header[31] = 0;
    BMP_header[4] = 18;   BMP_header[32] = 0;
    BMP_header[5] = 0;    BMP_header[33] = 0; 
    BMP_header[6] = 0;    BMP_header[34] = 0; 
    BMP_header[7] = 0;    BMP_header[35] = 0; 
    BMP_header[8] = 0;    BMP_header[36] = 0; 
    BMP_header[9] = 0;    BMP_header[37] = 0; 
    BMP_header[10] = 54;  BMP_header[38] = 0; 
    BMP_header[11] = 0;   BMP_header[39] = 0; 
    BMP_header[12] = 0;   BMP_header[40] = 0; 
    BMP_header[13] = 0;   BMP_header[41] = 0; 
    BMP_header[14] = 40;  BMP_header[42] = 0; 
    BMP_header[15] = 0;   BMP_header[43] = 0; 
    BMP_header[16] = 0;   BMP_header[44] = 0; 
    BMP_header[17] = 0;   BMP_header[45] = 0; 
    BMP_header[18] = 0;   BMP_header[46] = 0; 
    BMP_header[19] = 3;   BMP_header[47] = 0;
    BMP_header[20] = 0;   BMP_header[48] = 0;
    BMP_header[21] = 0;   BMP_header[49] = 0; 
    BMP_header[22] = 0;   BMP_header[50] = 0; 
    BMP_header[23] = 2;   BMP_header[51] = 0; 
    BMP_header[24] = 0;   BMP_header[52] = 0; 
    BMP_header[25] = 0;   BMP_header[53] = 0; 
    BMP_header[26] = 1;   
    BMP_header[27] = 0; 
end

//--------------------------------------------------
// Open BMP file
//--------------------------------------------------

initial begin
    fd = $fopen(INFILE,"wb+");
    data_count = 0;
    Write_Done = 0;
end

//--------------------------------------------------
// Collect image data
//--------------------------------------------------

always @(posedge HCLK or negedge HRESETn) begin
    if(!HRESETn) begin
        data_count <= 0;
        Write_Done <= 0;
    end
    else begin
        if(hsync) begin
            out_BMP[data_count]     <= DATA_WRITE_B0;
            out_BMP[data_count+1]   <= DATA_WRITE_G0;
            out_BMP[data_count+2]   <= DATA_WRITE_R0;

            out_BMP[data_count+3]   <= DATA_WRITE_B1;
            out_BMP[data_count+4]   <= DATA_WRITE_G1;
            out_BMP[data_count+5]   <= DATA_WRITE_R1;

            data_count <= data_count + 6;

            if(data_count >= WIDTH*HEIGHT*3 - 6)
                Write_Done <= 1'b1;
        end
    end
end

//--------------------------------------------------
// Write BMP file when done
//--------------------------------------------------

always @(Write_Done) begin
    if(Write_Done == 1'b1) begin

        // Write header
        for(i=0;i<BMP_HEADER_NUM;i=i+1)
            $fwrite(fd,"%c",BMP_header[i]);

        // Write image data
        for(i=0;i<WIDTH*HEIGHT*3;i=i+1)
            $fwrite(fd,"%c",out_BMP[i]);

        $fclose(fd);
    end
end

endmodule
