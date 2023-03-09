module Register_File #(parameter WIDTH = 8, parameter DEPTH_BITS = 4) (
    input       wire       [WIDTH - 1 : 0]                WrData,
    input       wire       [DEPTH_BITS - 1 : 0]           Address,
    input       wire                                      WrEn,
    input       wire                                      RdEn,
    input       wire                                      CLK,
    input       wire                                      RST,
    output      reg        [WIDTH - 1 : 0]                RdData,
    output      reg                                       RdData_Valid,
    output      wire       [WIDTH - 1 : 0]                REG0,
    output      wire       [WIDTH - 1 : 0]                REG1,
    output      wire       [WIDTH - 1 : 0]                REG2,
    output      wire       [WIDTH - 1 : 0]                REG3
);

localparam DEPTH = (1 << DEPTH_BITS);

reg     [WIDTH - 1 : 0]      RF      [DEPTH - 1 : 0];

integer I;

always @ (posedge CLK or negedge RST)
begin
    if (!RST)
        begin
            for (I = 0; I < DEPTH; I = I + 1)
                begin
                    RF[I] = 'b0;
                end
            RdData_Valid <= 0;
        end

    else if (WrEn && !RdEn)
        begin
            RF[Address] <= WrData;
            RdData <= 'b0;
            RdData_Valid <= 0;
        end

    else if(!WrEn && RdEn)
        begin
            RdData <= RF[Address];
            RdData_Valid <= 1;
        end
    
    else
        begin
            RdData <= 'b0;
            RdData_Valid <= 0;
        end
end


assign REG0 = RF[0];
assign REG1 = RF[1];
assign REG2 = RF[2];
assign REG3 = RF[3];


endmodule