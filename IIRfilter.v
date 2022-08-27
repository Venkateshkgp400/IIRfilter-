module baugh_mult(a,b,p);
  input [3:0]a,b;
  output [7:0]p;
  supply1 one;
  wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19,w20,w21,w22,w23;
  assign p[0]=a[0]&b[0];
  
  half_adder HA1(a[1]&b[0],a[0]&b[1],p[1],w1);
  half_adder HA2(a[2]&b[0],a[1]&b[1],w2,w3);
  half_adder HA3(~(a[3]&b[0]),a[2]&b[1],w4,w5);
  
  full_adder FA1(w2,w1,a[0]&b[2],p[2],w6);
  full_adder FA2(w4,w3,a[1]&b[2],w7,w8);
  full_adder FA3(w5,a[2]&b[2],~(a[3]&b[1]),w9,w10);
  
  full_adder FA4(w6,w7,~(a[0]&b[3]),p[3],w11);
  full_adder FA5(w8,w9,~(a[1]&b[3]),w12,w13);
  full_adder FA6(w10,~(a[2]&b[3]),~(a[3]&b[2]),w14,w15);
  
  full_adder FA7(one,w11,w12,p[4],w16);
  half_adder HA4(w13,w14,w17,w18);
  half_adder HA5(a[3]&b[3],w15,w19,w20);
  
  half_adder HA6(w16,w17,p[5],w21);
  half_adder HA7(w18,w19,w22,w23);
  
  half_adder HA8(w21,w22,p[7],p[6]);
  endmodule
  
  
module full_adder(x,y,cin,s,cout);
      input x,y,cin;
      output s,cout;
      assign s=x^y^cin;
      assign cout= (x&y)|(y&cin)|(x&cin);
    endmodule
  
  module half_adder(x,y,s,cout);
  input x,y;
  output s,cout;
  assign s=x^y;
  assign cout=x&y;
endmodule

module IIRfilter(clk,rst,a,x,y);
  input clk,rst;
  input[3:0]a,x;
  output [3:0]y;
  reg[3:0]y_val;//register to store intermediate value of y
  wire[7:0] baugh_prod_actual;//BW muliplier product
  baugh_mult bm1(.a(a),.b(y_val),.p(baugh_prod_actual));
                 always@(posedge clk,rst,x,a)
                   begin
                     if(rst)begin
                       y_val<=x;
                     end
                     else begin
                       y_val<=x+baugh_prod_actual[3:0];
                     end
                   end
                 assign y=y_val;
                 endmodule
                 
module IIRfilter_tb;
  reg clk,rst;
  reg[3:0]a,x;
  wire[3:0]y;
  IIRfilter IIR1(.clk(clk),.rst(rst),.a(a),.x(x),.y(y));
  initial begin
    clk=0;
  end
  always 
    #5 clk=!clk;
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
    rst=1;
    a=4'd2;
    x=4'd1;
    #10 rst=0;
    a=4'd2;
    x=4'd1;
   
  end
  
endmodule  
    
    
    
    