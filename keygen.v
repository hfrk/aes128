module keygen (
  input [127:0] cipher_key,
  input [3:0] round_number,
  output reg [127:0] round_key
);
  always @(round_number) begin
    case (round_number)
      4'd0 : round_key = 128'h00112233445566778899aabbccddeeff;
      4'd1 : round_key = 128'hc0393478846c520f0cf5f8b4c028164b;
      4'd2 : round_key = 128'hf67e87c27212d5cd7ee72d79becf3b32;
      4'd3 : round_key = 128'h789ca46c0a8e71a174695cd8caa667ea;
      4'd4 : round_key = 128'h541923185e9752b92afe0e61e058698b;
      4'd5 : round_key = 128'h2ee01ef970774c405a894221bad12baa;
      4'd6 : round_key = 128'h3011b20d4066fe4d1aefbc6ca03e97c6;
      4'd7 : round_key = 128'hc29906ed82fff8a0981044cc382ed30a;
      4'd8 : round_key = 128'h73ff61eaf100994a6910dd86513e0e8c;
      4'd9 : round_key = 128'hda54053b2b549c71424441f7137a4f7b;
      4'd10: round_key = 128'h36d024461d84b8375fc0f9c04cbab6bb;
      default:
      begin
        round_key = 128'h0;
      end
    endcase
  end
endmodule

/*
Fixed key expansion for key: 0x00112233445566778899AABBCCDDEEFF
TODO: make a true key generator for arbitrary cipher key

obtained from the following Python script:
def expand_key(key):
  mask = 0xffffffff
  keys = [(key >> 96) & mask, (key >> 64) & mask, (key >> 32) & mask, key & mask]
  rci = [1]
  for index in range(len(keys), 11 * len(keys)):
    if index % 4 == 0:
      keys.append(
          keys[index-4] ^ \
          (rci[len(rci)-1] << 24) ^ \
          ( \
            (sbox[(keys[index-1] >> 16) & 0xff] << 24) | \
            (sbox[(keys[index-1] >> 8) & 0xff] << 16) | \
            (sbox[(keys[index-1]) & 0xff] << 8) | \
            (sbox[(keys[index-1] >> 24) & 0xff]) \
          ) \
        )
      rci.append(2 * rci[len(rci)-1] if rci[len(rci)-1] < 0x80 \
            else ((2 * rci[len(rci)-1]) ^ 0x11b) & 0xff)
    else:
      keys.append(keys[index-4] ^ keys[index-1])
  return [ \
    (keys[4*index] << 96) | \
     (keys[4*index+1] << 64) | \
     (keys[4*index+2] << 32) | \
     (keys[4*index+3]) & \
     0xffffffffffffffffffffffffffffffff \
     for index in range(int(len(keys)/4)) \
  ]
*/
  
/*
  reg [127:0] round_keys [0:10];
  reg [3:0] index;
  reg [7:0] rcon = 1;
  reg [7:0] sbox0_in, sbox1_in, sbox2_in, sbox3_in;
  wire [7:0] sbox0_out, sbox1_out, sbox2_out, sbox3_out;
  reg [31:0] w0, w1, w2, w3, w4, w5, w6, w7, www;

  sbox sbox0(.input_byte(sbox0_in), .output_byte(sbox0_out));
  sbox sbox1(.input_byte(sbox1_in), .output_byte(sbox1_out));
  sbox sbox2(.input_byte(sbox2_in), .output_byte(sbox2_out));
  sbox sbox3(.input_byte(sbox3_in), .output_byte(sbox3_out));
  always @(cipher_key) begin
    round_keys[0] = cipher_key;
    w0 = cipher_key[127:96];
    w1 = cipher_key[95:64];
    w2 = cipher_key[63:32];
    w3 = cipher_key[31:0];
    for (index = 0; index <= 10; index = index + 1) begin
      sbox0_in = w3[31:24]; sbox1_in = w3[23:16];
      sbox2_in = w3[15:08]; sbox3_in = w3[07:00];
      www = {rcon, 24'h0} ^ {sbox1_out, sbox2_out, sbox3_out, sbox0_out};
      w4 = w0 ^ www;
      w5 = w1 ^ w0 ^ www;
      w6 = w2 ^ w1 ^ w0 ^ www;
      w7 = w3 ^ w2 ^ w1 ^ w0 ^ www;
      rcon = (rcon < 8'h80) ? rcon << 1 : (rcon << 1) ^ 8'h1b;
      round_keys[index] = {w4, w5, w6, w7};
      w0 = w4;
      w1 = w5;
      w2 = w6;
      w3 = w7;
    end
  end
*/
