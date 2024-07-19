/* Generated by Yosys 0.36+67 (git sha1 1ddb0892c, aarch64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

(* top =  1  *)
(* src = "mmu.sv:4.1-78.10" *)
module mmu(clk, reset, load_weight, valid, a_in1, a_in2, weight1, weight2, weight3, weight4, acc_out1, acc_out2);
  (* src = "mmu.sv:10.20-10.25" *)
  input [7:0] a_in1;
  wire [7:0] a_in1;
  (* src = "mmu.sv:11.20-11.25" *)
  input [7:0] a_in2;
  wire [7:0] a_in2;
  (* src = "mmu.sv:23.14-23.24" *)
  wire [7:0] a_inter_01;
  (* src = "mmu.sv:23.26-23.36" *)
  wire [7:0] a_inter_11;
  (* src = "mmu.sv:24.14-24.26" *)
  wire [7:0] acc_inter_00;
  (* src = "mmu.sv:24.28-24.40" *)
  wire [7:0] acc_inter_01;
  (* src = "mmu.sv:19.21-19.29" *)
  output [7:0] acc_out1;
  wire [7:0] acc_out1;
  (* src = "mmu.sv:20.21-20.29" *)
  output [7:0] acc_out2;
  wire [7:0] acc_out2;
  (* src = "mmu.sv:5.14-5.17" *)
  input clk;
  wire clk;
  (* src = "mmu.sv:7.14-7.25" *)
  input load_weight;
  wire load_weight;
  (* src = "mmu.sv:6.14-6.19" *)
  input reset;
  wire reset;
  (* src = "mmu.sv:8.14-8.19" *)
  input valid;
  wire valid;
  (* src = "mmu.sv:13.20-13.27" *)
  input [7:0] weight1;
  wire [7:0] weight1;
  (* src = "mmu.sv:14.20-14.27" *)
  input [7:0] weight2;
  wire [7:0] weight2;
  (* src = "mmu.sv:15.20-15.27" *)
  input [7:0] weight3;
  wire [7:0] weight3;
  (* src = "mmu.sv:16.20-16.27" *)
  input [7:0] weight4;
  wire [7:0] weight4;
  (* module_not_derived = 32'd1 *)
  (* src = "mmu.sv:27.22-37.4" *)
  processing_element PE00 (
    .a_in(a_in1),
    .a_out(a_inter_01),
    .acc_in(8'h00),
    .acc_out(acc_inter_00),
    .clk(clk),
    .load_weight(load_weight),
    .reset(reset),
    .valid(valid),
    .weight(weight1)
  );
  (* module_not_derived = 32'd1 *)
  (* src = "mmu.sv:40.22-50.4" *)
  processing_element PE01 (
    .a_in(a_inter_01),
    .acc_in(8'h00),
    .acc_out(acc_inter_01),
    .clk(clk),
    .load_weight(load_weight),
    .reset(reset),
    .valid(valid),
    .weight(weight3)
  );
  (* module_not_derived = 32'd1 *)
  (* src = "mmu.sv:53.22-63.4" *)
  processing_element PE10 (
    .a_in(a_in2),
    .a_out(a_inter_11),
    .acc_in(acc_inter_00),
    .acc_out(acc_out1),
    .clk(clk),
    .load_weight(load_weight),
    .reset(reset),
    .valid(valid),
    .weight(weight2)
  );
  (* module_not_derived = 32'd1 *)
  (* src = "mmu.sv:66.22-76.4" *)
  processing_element PE11 (
    .a_in(a_inter_11),
    .acc_in(acc_inter_01),
    .acc_out(acc_out2),
    .clk(clk),
    .load_weight(load_weight),
    .reset(reset),
    .valid(valid),
    .weight(weight4)
  );
endmodule

(* src = "processing_element.sv:4.1-42.10" *)
module processing_element(clk, reset, load_weight, valid, a_in, weight, acc_in, a_out, acc_out);
  wire _000_;
  wire _001_;
  wire _002_;
  wire _003_;
  wire _004_;
  wire _005_;
  wire _006_;
  wire _007_;
  wire _008_;
  wire _009_;
  wire _010_;
  wire _011_;
  wire _012_;
  wire _013_;
  wire _014_;
  wire _015_;
  wire _016_;
  wire _017_;
  wire _018_;
  wire _019_;
  wire _020_;
  wire _021_;
  wire _022_;
  wire _023_;
  wire _024_;
  wire _025_;
  wire _026_;
  wire _027_;
  wire _028_;
  wire _029_;
  wire _030_;
  wire _031_;
  wire _032_;
  wire _033_;
  wire _034_;
  wire _035_;
  wire _036_;
  wire _037_;
  wire _038_;
  wire _039_;
  wire _040_;
  wire _041_;
  wire _042_;
  wire _043_;
  wire _044_;
  wire _045_;
  wire _046_;
  wire _047_;
  wire _048_;
  wire _049_;
  wire _050_;
  wire _051_;
  wire _052_;
  wire _053_;
  wire _054_;
  wire _055_;
  wire _056_;
  wire _057_;
  wire _058_;
  wire _059_;
  wire _060_;
  wire _061_;
  wire _062_;
  wire _063_;
  wire _064_;
  wire _065_;
  wire _066_;
  wire _067_;
  wire _068_;
  wire _069_;
  wire _070_;
  wire _071_;
  wire _072_;
  wire _073_;
  wire _074_;
  wire _075_;
  wire _076_;
  wire _077_;
  wire _078_;
  wire _079_;
  wire _080_;
  wire _081_;
  wire _082_;
  wire _083_;
  wire _084_;
  wire _085_;
  wire _086_;
  wire _087_;
  wire _088_;
  wire _089_;
  wire _090_;
  wire _091_;
  wire _092_;
  wire _093_;
  wire _094_;
  wire _095_;
  wire _096_;
  wire _097_;
  wire _098_;
  wire _099_;
  wire _100_;
  wire _101_;
  wire _102_;
  wire _103_;
  wire _104_;
  wire _105_;
  wire _106_;
  wire _107_;
  wire _108_;
  wire _109_;
  wire _110_;
  wire _111_;
  wire _112_;
  wire _113_;
  wire _114_;
  wire _115_;
  wire _116_;
  wire _117_;
  wire _118_;
  wire _119_;
  wire _120_;
  wire _121_;
  wire _122_;
  wire _123_;
  wire _124_;
  wire _125_;
  wire _126_;
  wire _127_;
  wire _128_;
  wire _129_;
  wire _130_;
  wire _131_;
  wire _132_;
  wire _133_;
  wire _134_;
  wire _135_;
  wire _136_;
  wire _137_;
  wire _138_;
  wire _139_;
  wire _140_;
  wire _141_;
  wire _142_;
  wire _143_;
  wire _144_;
  wire _145_;
  wire _146_;
  wire _147_;
  wire _148_;
  wire _149_;
  wire _150_;
  wire _151_;
  wire _152_;
  wire _153_;
  wire _154_;
  wire _155_;
  wire _156_;
  wire _157_;
  wire _158_;
  wire _159_;
  wire _160_;
  wire _161_;
  wire _162_;
  wire _163_;
  wire _164_;
  wire _165_;
  wire _166_;
  wire _167_;
  wire _168_;
  wire _169_;
  wire _170_;
  wire _171_;
  wire _172_;
  wire _173_;
  wire _174_;
  wire _175_;
  wire _176_;
  wire _177_;
  (* force_downto = 32'd1 *)
  (* src = "/Users/evanlin/Desktop/ZeroToAsic/oss-cad-suite/libexec/../share/yosys/techmap.v:200.24-200.25" *)
  (* unused_bits = "1 2 3 4 5 6 7" *)
  wire [7:0] _178_;
  (* force_downto = 32'd1 *)
  (* src = "/Users/evanlin/Desktop/ZeroToAsic/oss-cad-suite/libexec/../share/yosys/techmap.v:200.24-200.25" *)
  (* unused_bits = "2 3 4 5 6 7" *)
  wire [7:0] _179_;
  (* force_downto = 32'd1 *)
  (* src = "/Users/evanlin/Desktop/ZeroToAsic/oss-cad-suite/libexec/../share/yosys/techmap.v:200.24-200.25" *)
  (* unused_bits = "3 4 5 6 7" *)
  wire [7:0] _180_;
  (* force_downto = 32'd1 *)
  (* src = "/Users/evanlin/Desktop/ZeroToAsic/oss-cad-suite/libexec/../share/yosys/techmap.v:270.23-270.24" *)
  (* unused_bits = "4 5 6 7" *)
  wire [7:0] _181_;
  (* force_downto = 32'd1 *)
  (* src = "/Users/evanlin/Desktop/ZeroToAsic/oss-cad-suite/libexec/../share/yosys/techmap.v:270.26-270.27" *)
  wire [7:0] _182_;
  (* src = "processing_element.sv:10.20-10.24" *)
  input [7:0] a_in;
  wire [7:0] a_in;
  (* src = "processing_element.sv:14.20-14.25" *)
  output [7:0] a_out;
  reg [7:0] a_out;
  (* src = "processing_element.sv:12.20-12.26" *)
  input [7:0] acc_in;
  wire [7:0] acc_in;
  (* src = "processing_element.sv:15.20-15.27" *)
  output [7:0] acc_out;
  reg [7:0] acc_out;
  (* src = "processing_element.sv:5.14-5.17" *)
  input clk;
  wire clk;
  (* src = "processing_element.sv:7.14-7.25" *)
  input load_weight;
  wire load_weight;
  (* src = "processing_element.sv:6.14-6.19" *)
  input reset;
  wire reset;
  (* src = "processing_element.sv:8.14-8.19" *)
  input valid;
  wire valid;
  (* src = "processing_element.sv:11.20-11.26" *)
  input [7:0] weight;
  wire [7:0] weight;
  (* src = "processing_element.sv:18.13-18.23" *)
  reg [7:0] weight_reg;
  assign _114_ = ~(weight_reg[0] & a_in[0]);
  assign _178_[0] = ~(_114_ ^ acc_in[0]);
  assign _115_ = ~(weight_reg[1] & a_in[2]);
  assign _116_ = ~(weight_reg[3] & a_in[0]);
  assign _117_ = _116_ ^ _115_;
  assign _118_ = ~(weight_reg[0] & a_in[3]);
  assign _119_ = ~(weight_reg[2] & a_in[1]);
  assign _120_ = ~(_119_ ^ _118_);
  assign _121_ = ~(_120_ ^ acc_in[3]);
  assign _122_ = ~(weight_reg[0] & a_in[2]);
  assign _123_ = weight_reg[2] & a_in[0];
  assign _124_ = _122_ | ~(_123_);
  assign _125_ = _123_ ^ _122_;
  assign _126_ = acc_in[2] & ~(_125_);
  assign _127_ = _124_ & ~(_126_);
  assign _128_ = _127_ ^ _121_;
  assign _129_ = _128_ ^ _117_;
  assign _130_ = _125_ ^ acc_in[2];
  assign _131_ = weight_reg[0] & a_in[1];
  assign _132_ = _131_ & acc_in[1];
  assign _133_ = _132_ ^ _130_;
  assign _134_ = ~(weight_reg[1] & a_in[1]);
  assign _135_ = _134_ | _133_;
  assign _136_ = _135_ ^ _129_;
  assign _137_ = _130_ | ~(_132_);
  assign _138_ = _137_ ^ _136_;
  assign _139_ = ~(_134_ ^ _133_);
  assign _140_ = _131_ ^ acc_in[1];
  assign _141_ = acc_in[0] & ~(_114_);
  assign _142_ = _141_ ^ _140_;
  assign _143_ = weight_reg[1] & a_in[0];
  assign _144_ = _143_ & _142_;
  assign _145_ = _139_ | ~(_144_);
  assign _146_ = _141_ & _140_;
  assign _147_ = _144_ ^ _139_;
  assign _148_ = _146_ & ~(_147_);
  assign _149_ = _145_ & ~(_148_);
  assign _181_[3] = _149_ ^ _138_;
  assign _150_ = ~(weight_reg[4] & a_in[0]);
  assign _151_ = ~(weight_reg[1] & a_in[3]);
  assign _152_ = _151_ ^ _150_;
  assign _153_ = ~(weight_reg[3] & a_in[1]);
  assign _154_ = ~(_153_ ^ _152_);
  assign _155_ = _116_ | _115_;
  assign _156_ = ~(weight_reg[0] & a_in[4]);
  assign _157_ = ~(weight_reg[2] & a_in[2]);
  assign _158_ = ~(_157_ ^ _156_);
  assign _159_ = _158_ ^ acc_in[4];
  assign _160_ = _159_ ^ _155_;
  assign _161_ = _119_ | _118_;
  assign _162_ = acc_in[3] & ~(_120_);
  assign _163_ = _161_ & ~(_162_);
  assign _164_ = _163_ ^ _160_;
  assign _165_ = _164_ ^ _154_;
  assign _166_ = _128_ | ~(_117_);
  assign _167_ = _166_ ^ _165_;
  assign _168_ = _127_ | ~(_121_);
  assign _169_ = _168_ ^ _167_;
  assign _170_ = _135_ | _129_;
  assign _171_ = _136_ & ~(_137_);
  assign _172_ = _170_ & ~(_171_);
  assign _173_ = ~(_172_ ^ _169_);
  assign _174_ = ~(_149_ | _138_);
  assign _182_[4] = ~(_174_ ^ _173_);
  assign _175_ = weight_reg[5] & a_in[0];
  assign _176_ = ~(weight_reg[4] & a_in[1]);
  assign _177_ = ~(a_in[4] & weight_reg[1]);
  assign _000_ = _177_ ^ _176_;
  assign _001_ = ~(weight_reg[3] & a_in[2]);
  assign _002_ = _001_ ^ _000_;
  assign _003_ = ~(_002_ ^ _175_);
  assign _004_ = _151_ | _150_;
  assign _005_ = _152_ & ~(_153_);
  assign _006_ = _004_ & ~(_005_);
  assign _007_ = ~(weight_reg[0] & a_in[5]);
  assign _008_ = weight_reg[2] & a_in[3];
  assign _009_ = _008_ ^ _007_;
  assign _010_ = _009_ ^ acc_in[5];
  assign _011_ = _010_ ^ _006_;
  assign _012_ = _157_ | _156_;
  assign _013_ = acc_in[4] & ~(_158_);
  assign _014_ = _012_ & ~(_013_);
  assign _015_ = _014_ ^ _011_;
  assign _016_ = _015_ ^ _003_;
  assign _017_ = _164_ | ~(_154_);
  assign _018_ = _017_ ^ _016_;
  assign _019_ = _159_ | _155_;
  assign _020_ = _160_ & ~(_163_);
  assign _021_ = _019_ & ~(_020_);
  assign _022_ = _021_ ^ _018_;
  assign _023_ = _166_ | _165_;
  assign _024_ = _167_ & ~(_168_);
  assign _025_ = _023_ & ~(_024_);
  assign _026_ = ~(_025_ ^ _022_);
  assign _027_ = _172_ | _169_;
  assign _028_ = _174_ & ~(_173_);
  assign _029_ = _027_ & ~(_028_);
  assign _182_[5] = _029_ ^ _026_;
  assign _030_ = weight_reg[6] & a_in[0];
  assign _031_ = weight_reg[5] & a_in[1];
  assign _032_ = ~(_031_ ^ _030_);
  assign _033_ = ~_032_;
  assign _034_ = ~(weight_reg[4] & a_in[2]);
  assign _035_ = a_in[5] & weight_reg[1];
  assign _036_ = _035_ ^ _034_;
  assign _037_ = weight_reg[3] & a_in[3];
  assign _038_ = _037_ ^ _036_;
  assign _039_ = _038_ ^ _033_;
  assign _040_ = _175_ & ~(_002_);
  assign _041_ = _040_ ^ _039_;
  assign _042_ = _177_ | _176_;
  assign _043_ = _000_ & ~(_001_);
  assign _044_ = _042_ & ~(_043_);
  assign _045_ = ~(weight_reg[0] & a_in[6]);
  assign _046_ = weight_reg[2] & a_in[4];
  assign _047_ = _046_ ^ _045_;
  assign _048_ = _047_ ^ acc_in[6];
  assign _049_ = _048_ ^ _044_;
  assign _050_ = _007_ | ~(_008_);
  assign _051_ = acc_in[5] & ~(_009_);
  assign _052_ = _050_ & ~(_051_);
  assign _053_ = _052_ ^ _049_;
  assign _054_ = _053_ ^ _041_;
  assign _055_ = _003_ & ~(_015_);
  assign _056_ = _055_ ^ _054_;
  assign _057_ = _010_ | _006_;
  assign _058_ = _011_ & ~(_014_);
  assign _059_ = _057_ & ~(_058_);
  assign _060_ = _059_ ^ _056_;
  assign _061_ = _017_ | _016_;
  assign _062_ = _018_ & ~(_021_);
  assign _063_ = _061_ & ~(_062_);
  assign _064_ = _063_ ^ _060_;
  assign _065_ = _025_ | _022_;
  assign _066_ = ~(_027_ | _026_);
  assign _067_ = _065_ & ~(_066_);
  assign _068_ = _026_ | _173_;
  assign _069_ = _174_ & ~(_068_);
  assign _070_ = _067_ & ~(_069_);
  assign _182_[6] = ~(_070_ ^ _064_);
  assign _071_ = weight_reg[7] & a_in[0];
  assign _072_ = a_in[1] & weight_reg[6];
  assign _073_ = _072_ ^ _071_;
  assign _074_ = a_in[2] & weight_reg[5];
  assign _075_ = _074_ ^ _073_;
  assign _076_ = _031_ & _030_;
  assign _077_ = _076_ ^ _075_;
  assign _078_ = ~(a_in[3] & weight_reg[4]);
  assign _079_ = a_in[6] & weight_reg[1];
  assign _080_ = _079_ ^ _078_;
  assign _081_ = weight_reg[3] & a_in[4];
  assign _082_ = _081_ ^ _080_;
  assign _083_ = _082_ ^ _077_;
  assign _084_ = _033_ & ~(_038_);
  assign _085_ = _084_ ^ _083_;
  assign _086_ = _034_ | ~(_035_);
  assign _087_ = _037_ & ~(_036_);
  assign _088_ = _086_ & ~(_087_);
  assign _089_ = ~(a_in[7] & weight_reg[0]);
  assign _090_ = weight_reg[2] & a_in[5];
  assign _091_ = _090_ ^ _089_;
  assign _092_ = _091_ ^ acc_in[7];
  assign _093_ = _092_ ^ _088_;
  assign _094_ = _045_ | ~(_046_);
  assign _095_ = acc_in[6] & ~(_047_);
  assign _096_ = _094_ & ~(_095_);
  assign _097_ = _096_ ^ _093_;
  assign _098_ = _097_ ^ _085_;
  assign _099_ = _039_ | ~(_040_);
  assign _100_ = ~(_053_ | _041_);
  assign _101_ = _099_ & ~(_100_);
  assign _102_ = _101_ ^ _098_;
  assign _103_ = _048_ | _044_;
  assign _104_ = _049_ & ~(_052_);
  assign _105_ = _103_ & ~(_104_);
  assign _106_ = _105_ ^ _102_;
  assign _107_ = ~(_055_ & _054_);
  assign _108_ = _056_ & ~(_059_);
  assign _109_ = _107_ & ~(_108_);
  assign _110_ = _109_ ^ _106_;
  assign _111_ = _063_ | _060_;
  assign _112_ = _064_ & ~(_070_);
  assign _113_ = _111_ & ~(_112_);
  assign _182_[7] = _113_ ^ _110_;
  assign _179_[1] = _143_ ^ _142_;
  assign _180_[2] = ~(_147_ ^ _146_);
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[0] <= 1'h0;
    else if (load_weight) weight_reg[0] <= weight[0];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[1] <= 1'h0;
    else if (load_weight) weight_reg[1] <= weight[1];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[2] <= 1'h0;
    else if (load_weight) weight_reg[2] <= weight[2];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[3] <= 1'h0;
    else if (load_weight) weight_reg[3] <= weight[3];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[4] <= 1'h0;
    else if (load_weight) weight_reg[4] <= weight[4];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[5] <= 1'h0;
    else if (load_weight) weight_reg[5] <= weight[5];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[6] <= 1'h0;
    else if (load_weight) weight_reg[6] <= weight[6];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) weight_reg[7] <= 1'h0;
    else if (load_weight) weight_reg[7] <= weight[7];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[0] <= 1'h0;
    else if (valid) acc_out[0] <= _178_[0];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[1] <= 1'h0;
    else if (valid) acc_out[1] <= _179_[1];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[2] <= 1'h0;
    else if (valid) acc_out[2] <= _180_[2];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[3] <= 1'h0;
    else if (valid) acc_out[3] <= _181_[3];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[4] <= 1'h0;
    else if (valid) acc_out[4] <= _182_[4];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[5] <= 1'h0;
    else if (valid) acc_out[5] <= _182_[5];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[6] <= 1'h0;
    else if (valid) acc_out[6] <= _182_[6];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) acc_out[7] <= 1'h0;
    else if (valid) acc_out[7] <= _182_[7];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[0] <= 1'h0;
    else if (valid) a_out[0] <= a_in[0];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[1] <= 1'h0;
    else if (valid) a_out[1] <= a_in[1];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[2] <= 1'h0;
    else if (valid) a_out[2] <= a_in[2];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[3] <= 1'h0;
    else if (valid) a_out[3] <= a_in[3];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[4] <= 1'h0;
    else if (valid) a_out[4] <= a_in[4];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[5] <= 1'h0;
    else if (valid) a_out[5] <= a_in[5];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[6] <= 1'h0;
    else if (valid) a_out[6] <= a_in[6];
  (* src = "processing_element.sv:20.3-41.6" *)
  always @(posedge clk, posedge reset)
    if (reset) a_out[7] <= 1'h0;
    else if (valid) a_out[7] <= a_in[7];
  assign _179_[0] = _178_[0];
  assign _180_[1:0] = { _179_[1], _178_[0] };
  assign _181_[2:0] = { _180_[2], _179_[1], _178_[0] };
  assign _182_[3:0] = { _181_[3], _180_[2], _179_[1], _178_[0] };
endmodule
