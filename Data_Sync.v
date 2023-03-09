module Data_Sync #(parameter NUM_STAGES = 2, parameter BUS_WIDTH = 8) (
    input       wire        [BUS_WIDTH - 1:0]       UNSYNC_BUS,
    input       wire                                Bus_Enable,
    input       wire                                CLK,
    input       wire                                RST,
    output      reg         [BUS_WIDTH - 1:0]       SYNC_BUS,
    output      reg                                 Enable_Pulse
);

integer                         BITS, N_FF;
reg     [NUM_STAGES - 1:0]      Synchronizers;
wire                            enable;
reg                             pulse_in;

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                SYNC_BUS <= 0;
            end
        else
            begin
                if (enable)
                    SYNC_BUS <= UNSYNC_BUS;
                else
                    SYNC_BUS <= SYNC_BUS;
            end
    end

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Synchronizers <= 0;
            end
        else
            begin
                Synchronizers[0] <= Bus_Enable;
                for (N_FF = 1; N_FF < NUM_STAGES; N_FF = N_FF + 1)
                        Synchronizers[N_FF] <= Synchronizers[N_FF - 1];
                pulse_in <= Synchronizers[NUM_STAGES - 1];
            end
    end

always @ (posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                Enable_Pulse <= 0;
            end
        else
            begin
                Enable_Pulse <= enable;
            end
    end

assign enable = (~pulse_in) & Synchronizers[NUM_STAGES - 1];

endmodule
