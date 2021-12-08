module sbox_32bit (
  input [31:0] in_32bit,
  output [31:0] out_32bit
);
  sbox sbox0(.input_byte(in_32bit[7:0]), .output_byte(out_32bit[7:0]));
  sbox sbox1(.input_byte(in_32bit[15:8]), .output_byte(out_32bit[15:8]));
  sbox sbox2(.input_byte(in_32bit[23:16]), .output_byte(out_32bit[23:16]));
  sbox sbox3(.input_byte(in_32bit[31:24]), .output_byte(out_32bit[31:24]));
endmodule

module sub_bytes_and_shiftrows (
  input [127:0] in_data,
  output [127:0] out_data
);
  
  sbox_32bit s32_0(.in_32bit({in_data[127:120],in_data[95:88],in_data[63:56],in_data[31:24]}),
                   .out_32bit({out_data[127:120],out_data[95:88],out_data[63:56],out_data[31:24]}));
  sbox_32bit s32_1(.in_32bit({in_data[119:112],in_data[87:80],in_data[55:48],in_data[23:16]}),
                   .out_32bit({out_data[23:16],out_data[119:112],out_data[87:80],out_data[55:48]}));
  sbox_32bit s32_2(.in_32bit({in_data[111:104],in_data[79:72],in_data[47:40],in_data[15:8]}),
                   .out_32bit({out_data[47:40],out_data[15:8],out_data[111:104],out_data[79:72]}));
  sbox_32bit s32_3(.in_32bit({in_data[103:96],in_data[71:64],in_data[39:32],in_data[7:0]}),
                   .out_32bit({out_data[71:64],out_data[39:32],out_data[7:0],out_data[103:96]}));

endmodule

module mixcolumns (
  input [127:0] a,
  output [127:0] mcl
);

  assign mcl[31:0]   = {mixcolumn32(a[031:00]), mixcolumn32({a[023:00],a[031:024]}), mixcolumn32({a[15:0],a[31:16]}), mixcolumn32({a[7:0],a[31:8]})};
  assign mcl[63:32]  = {mixcolumn32(a[063:32]), mixcolumn32({a[055:32],a[063:056]}), mixcolumn32({a[47:32],a[63:48]}), mixcolumn32({a[39:32],a[63:40]})};
  assign mcl[95:64]  = {mixcolumn32(a[095:64]), mixcolumn32({a[087:64],a[095:088]}), mixcolumn32({a[79:64],a[95:80]}), mixcolumn32({a[71:64],a[95:72]})};
  assign mcl[127:96] = {mixcolumn32(a[127:96]), mixcolumn32({a[119:96],a[127:120]}), mixcolumn32({a[111:96],a[127:112]}), mixcolumn32({a[103:96],a[127:104]})};

  function [7:0] mixcolumn32;
    input [31:0] i;
    reg [7:0] i1, i2, i3, i4; 
    begin
      i1 = i[31:24]; i2 = i[23:16]; i3 = i[15:8]; i4 = i[7:0];
      mixcolumn32[7] = i1[6]         ^ i2[6] ^ i2[7]         ^ i3[7] ^ i4[7];
      mixcolumn32[6] = i1[5]         ^ i2[5] ^ i2[6]         ^ i3[6] ^ i4[6];
      mixcolumn32[5] = i1[4]         ^ i2[4] ^ i2[5]         ^ i3[5] ^ i4[5];
      mixcolumn32[4] = i1[3] ^ i1[7] ^ i2[3] ^ i2[4] ^ i2[7] ^ i3[4] ^ i4[4];
      mixcolumn32[3] = i1[2] ^ i1[7] ^ i2[2] ^ i2[3] ^ i2[7] ^ i3[3] ^ i4[3];
      mixcolumn32[2] = i1[1]         ^ i2[1] ^ i2[2]         ^ i3[2] ^ i4[2];
      mixcolumn32[1] = i1[0] ^ i1[7] ^ i2[0] ^ i2[1] ^ i2[7] ^ i3[1] ^ i4[1];
      mixcolumn32[0] = i1[7]         ^ i2[7] ^ i2[0]         ^ i3[0] ^ i4[0];
    end
  endfunction
endmodule

module aes_encode (
    input [3:0] round_number,
    input [127:0] round_key,
    input [127:0] data_block,
    output reg [127:0] result_block
);

  wire [127:0] sub_shift_out;
  wire [127:0] mix_out;
   
  sub_bytes_and_shiftrows sub_shift(.in_data(data_block), .out_data(sub_shift_out));
  mixcolumns mix(.a(sub_shift_out), .mcl(mix_out));
  always @(round_number) begin
    case(round_number)
    4'd0:
      begin
        result_block = data_block ^ round_key; // addroundkey
      end
    4'd10:
      begin
        result_block = sub_shift_out ^ round_key; // addroundkey
      end
    default:
      begin
        result_block = mix_out ^ round_key; // addroundkey
      end
    endcase
  end
endmodule
