module ALU #(parameter WIDTH = 8, parameter OUT_WIDTH = 8, parameter FUN_WIDTH = 4)(
      input   wire   [WIDTH - 1:0]        A,
      input   wire   [WIDTH - 1:0]        B,
      input   wire   [FUN_WIDTH - 1:0]    ALU_FUN,
      input   wire                        Enable,
      input   wire                        CLK,
      input   wire                        RST,
      
      output  reg    [OUT_WIDTH - 1:0]    ALU_OUT,
      output  reg                         OUT_Valid
  );
  
  reg   [OUT_WIDTH - 1:0]   ALU_Comb;
  reg                       OUT_Valid_Comb;

  
  localparam  ADD    =   4'b0000,
              SUB    =   4'b0001,
              MUL    =   4'b0010,
              DIV    =   4'b0011,
              AND    =   4'b0100,
              OR     =   4'b0101,
              NAND   =   4'b0110,
              NOR    =   4'b0111,
              XOR    =   4'b1000,
              XNOR   =   4'b1001,
              EQU    =   4'b1010,
              GRT    =   4'b1011,
              LESS   =   4'b1100,
              SHR    =   4'b1101,
              SHL    =   4'b1110;
  

  always @ (posedge CLK or negedge RST)
    begin
      if (!RST)
        begin
          ALU_OUT <= 0;
          OUT_Valid <= 0;
        end
      else
        begin
          ALU_OUT <= ALU_Comb;
          OUT_Valid <= OUT_Valid_Comb;
        end
    end
  
  always @ (*)
    begin
      if (Enable)
        begin
          OUT_Valid_Comb = 1;

          case (ALU_FUN)
            ADD   : begin
                        ALU_Comb = A + B;
                      end
                      
            SUB   : begin
                        ALU_Comb = A - B;
                      end
                      
            MUL   : begin
                        ALU_Comb = A * B;
                      end
                      
            DIV   : begin 
                        ALU_Comb = A / B;
                      end
            
            AND   : begin 
                        ALU_Comb = A & B;
                      end
                      
            OR    : begin 
                        ALU_Comb = A | B;
                      end
                      
            NAND  : begin 
                        ALU_Comb = ~(A & B);
                      end
                      
            NOR   : begin 
                        ALU_Comb = ~(A | B);
                      end
                      
            XOR   : begin 
                        ALU_Comb = A ^ B;
                      end
                      
            XNOR  : begin 
                        ALU_Comb = A ~^ B;
                      end
            
            EQU   : begin
                        if (A == B)
                          begin
                            ALU_Comb = 1;
                          end
                        else
                          begin
                            ALU_Comb = 0;
                          end
                      end
                      
            GRT   : begin
                        if (A > B)
                          begin
                            ALU_Comb = 2;
                          end
                        else
                          begin
                            ALU_Comb = 0;
                          end
                      end
            
            LESS  : begin
                        if (A < B)
                          begin
                            ALU_Comb = 3;
                          end
                        else
                          begin
                            ALU_Comb = 0;
                          end
                      end
                      
            SHR   : begin
                        ALU_Comb = A >> 1;
                      end
                      
            SHL   : begin
                        ALU_Comb = A << 1;
                      end
            
            default : begin
                        ALU_Comb = 'b0;
                      end
            
          endcase
        end

      else
        begin
          ALU_Comb = 0;
          OUT_Valid_Comb = 0;
        end
    end


  endmodule