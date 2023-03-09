module CLK_GATE (
    input       wire        CLK_EN,
    input       wire        CLK,
    output      wire        GATED_CLK
);

reg     Latch_Output;

always @ (CLK or CLK_EN)
    begin
        if (!CLK)
            begin
                Latch_Output <= CLK_EN;
            end
    end

assign  GATED_CLK = CLK & Latch_Output;

endmodule