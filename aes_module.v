module aes_module (
  input [7:0] iDATA,
  input [3:0] iADDR,
  input iWR,
  input iRD,
  input iENC,
  input iDEC,
  output reg oBUSY,
  output reg [7:0] oDATA
);

  reg [7:0] temp_block [0:15];
  reg [7:0] out_block [0:15];
  reg [127:0] data_block;
  wire [127:0] result_block;

  reg [127:0] cipher_key = 128'h00112233445566778899aabbccddeeff;
  wire [127:0] round_key;
  reg [3:0] round_number;
  reg [3:0] state = 0;

  keygen key_generator(.cipher_key(cipher_key),
                       .round_number(round_number),
                       .round_key(round_key));
  aes_encode encode(.round_number(round_number),
                    .round_key(round_key),
                    .data_block(data_block),
                    .result_block(result_block));

  always @(posedge iWR) begin
    temp_block[iADDR] <= iDATA;
  end

  always @(posedge iRD) begin
    oDATA <= out_block[iADDR];
  end

  
  always @(posedge iENC) begin
    case (state)
      4'd0:
        begin
          oBUSY <= 0;
          data_block <= {temp_block[0], temp_block[1], temp_block[2], temp_block[3],
                         temp_block[4], temp_block[5], temp_block[6], temp_block[7],
                       temp_block[8], temp_block[9], temp_block[10], temp_block[11],
                     temp_block[12], temp_block[13], temp_block[14], temp_block[15]};
          round_number <= 4'd0;
          state <= 4'd1;
        end
        4'd1:
        begin
          data_block <= result_block;
          round_number <= 4'd1;
          state <= 4'd2;
        end
        4'd2:
        begin
          data_block <= result_block;
          round_number <= 4'd2;
          state <= 4'd3;
        end
        4'd3:
        begin
          data_block <= result_block;
          round_number <= 4'd3;
          state <= 4'd4;
        end
        4'd4:
        begin
          data_block <= result_block;
          round_number <= 4'd4;
          state <= 4'd5;
        end
        4'd5:
        begin
          data_block <= result_block;
          round_number <= 4'd5;
          state <= 4'd6;
        end
        4'd6:
        begin
          data_block <= result_block;
          round_number <= 4'd6;
          state <= 4'd7;
        end
        4'd7:
        begin
          data_block <= result_block;
          round_number <= 4'd7;
          state <= 4'd8;
        end
        4'd8:
        begin
          data_block <= result_block;
          round_number <= 4'd8;
          state <= 4'd9;
        end
        4'd9:
        begin
          data_block <= result_block;
          round_number <= 4'd9;
          state <= 4'd10;
        end
        4'd10:
        begin
          data_block <= result_block;
          round_number <= 4'd10;
          state <= 4'd11;
        end
        default:
        begin
         out_block[15] <= result_block[7:0];
         out_block[14] <= result_block[15:8];
         out_block[13] <= result_block[23:16];
         out_block[12] <= result_block[31:24];

         out_block[11] <= result_block[39:32];
         out_block[10] <= result_block[47:40];
         out_block[9] <= result_block[55:48];
         out_block[8] <= result_block[63:56];

         out_block[7] <= result_block[71:64];
         out_block[6] <= result_block[79:72];
         out_block[5] <= result_block[87:80];
         out_block[4] <= result_block[95:88];

         out_block[3] <= result_block[103:96];
         out_block[2] <= result_block[111:104];
         out_block[1] <= result_block[119:112];
         out_block[0] <= result_block[127:120];
          
         oBUSY <= 1;
         state <= 4'd0;
        end
    endcase
  end

  always @(posedge iDEC) begin
    /* NOT YET IMPLEMENTED */
  end

endmodule