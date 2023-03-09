module RST_Sync #(parameter NUM_STAGES = 2) (
    input       wire        RST,
    input       wire        CLK,
    output      reg         SYNC_RST
);

integer                         N_FF;
reg     [NUM_STAGES - 1:0]      Synchronizers;

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Synchronizers <= 'b0;
                SYNC_RST <= 1'b0;
            end 
        else
            begin
                Synchronizers[0] <= 1;
                for (N_FF = 1; N_FF < NUM_STAGES; N_FF = N_FF + 1)
                        Synchronizers[N_FF] <= Synchronizers[N_FF - 1];
                SYNC_RST <= Synchronizers[NUM_STAGES - 1];
            end
    end


endmodule
