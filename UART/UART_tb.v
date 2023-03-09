`timescale 1ns/1ps

module UART_tb ();

//Rx Signals
wire                     RX_IN_tb;
reg         [4:0]        Prescale_tb;
reg                      PAR_EN_tb;
reg                      PAR_TYP_tb;
reg                      CLK_tb;  
reg                      RST_tb;
wire        [7:0]        P_DATA_Rx_tb;
wire                     Data_Valid_Rx_tb;

//Tx Signals
reg         [7:0]        P_DATA_Tx_tb;
reg                      DATA_VALID_Tx_tb;
wire                     TX_OUT_tb;
wire                     Busy_tb;

parameter                Baud_Rate = 16'd64;  //16MHz -> 19200 833 28B1

localparam IDLE             =   3'b000,
           START            =   3'b001,
           RECEIVE_DATA     =   3'b010,
           PARITY           =   3'b011,
           STOP             =   3'b100,
           CHECK            =   3'b101;


reg     Manual_Input;
reg     Manual_Mode;

//Using my Tx to send the data frames and using Manual Mode to introduce errors.
assign RX_IN_tb = Manual_Mode ? Manual_Input : TX_OUT_tb;

initial 
    begin
        $dumpfile("UART.vcd");
        $dumpvars;


        P_DATA_Tx_tb = 0;
        DATA_VALID_Tx_tb = 0;
        PAR_EN_tb = 0;
        CLK_tb = 0;
        RST_tb = 1;
        Prescale_tb = 8;
        Manual_Mode = 0;

        //*4
        RST_tb = 0;
        #320
        RST_tb = 1;
        #320


        $display("-----RECEIVING FRAME WITH EVEN PARITY AND NO ERRORS-----");

        #120
        P_DATA_Tx_tb = 8'b0010_1010;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 0;
        #42.5  //Tx Rising
        DATA_VALID_Tx_tb = 1'b1;


        #160 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting.
        #80 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 1: Received Start Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != START)
            $display("TEST CASE 1 FAILED.");
        else
            $display("TEST CASE 1 PASSED."); 

        #80 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #240 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 2: Received Bit 0.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 2 FAILED.");
        else
            $display("TEST CASE 2 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 3: Received Bit 1.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 3 FAILED.");
        else
            $display("TEST CASE 3 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 4: Received Bit 2.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 4 FAILED.");
        else
            $display("TEST CASE 4 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 5: Received Bit 3.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 5 FAILED.");
        else
            $display("TEST CASE 5 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 6: Received Bit 4.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 6 FAILED.");
        else
            $display("TEST CASE 6 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 7: Received Bit 5.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 7 FAILED.");
        else
            $display("TEST CASE 7 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 8: Received Bit 6.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 8 FAILED.");
        else
            $display("TEST CASE 8 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 9: Received Bit 7.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 9 FAILED.");
        else
            $display("TEST CASE 9 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 10: Received Correct Parity Bit. (Even)");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != PARITY)
            $display("TEST CASE 10 FAILED.");
        else
            $display("TEST CASE 10 PASSED.");

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 11: Received Stop Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != STOP)
            $display("TEST CASE 11 FAILED.");
        else
            $display("TEST CASE 11 PASSED.");

        #40
        $display("TEST CASE 12: Output Received Frame and Data Valid Signal.");
        
        if (P_DATA_Rx_tb != 8'b0010_1010 || Data_Valid_Rx_tb != 1)
            $display("TEST CASE 12 FAILED.");
        else
            $display("TEST CASE 12 PASSED.");
        #100




        $display("\n\n-----RECEIVING FRAME WITH ODD PARITY AND NO ERRORS-----");


        #160
        P_DATA_Tx_tb = 8'b1101_0110;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 1;
        #80  //Tx Rising
        DATA_VALID_Tx_tb = 1'b1;

        #160 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #100 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 13: Received Start Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != START)
            $display("TEST CASE 13 FAILED.");
        else
            $display("TEST CASE 13 PASSED."); 

        #80 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #240 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 14: Received Bit 0.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 14 FAILED.");
        else
            $display("TEST CASE 14 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 15: Received Bit 1.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 15 FAILED.");
        else
            $display("TEST CASE 15 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 16: Received Bit 2.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 16 FAILED.");
        else
            $display("TEST CASE 16 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 17: Received Bit 3.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 17 FAILED.");
        else
            $display("TEST CASE 17 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 18: Received Bit 4.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 18 FAILED.");
        else
            $display("TEST CASE 18 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 19: Received Bit 5.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 19 FAILED.");
        else
            $display("TEST CASE 19 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 20: Received Bit 6.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 20 FAILED.");
        else
            $display("TEST CASE 20 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 21: Received Bit 7.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 21 FAILED.");
        else
            $display("TEST CASE 21 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 22: Received Correct Parity Bit (Odd).");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != PARITY)
            $display("TEST CASE 22 FAILED.");
        else
            $display("TEST CASE 22 PASSED.");

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 23: Received Stop Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != STOP)
            $display("TEST CASE 23 FAILED.");
        else
            $display("TEST CASE 23 PASSED.");

        #40
        $display("TEST CASE 24: Output Received Frame and Data Valid Signal.");
        
        if (P_DATA_Rx_tb != 8'b1101_0110 || Data_Valid_Rx_tb != 1)
            $display("TEST CASE 24 FAILED.");
        else
            $display("TEST CASE 24 PASSED.");
        #100


        
        $display("\n\n-----RECEIVING FRAME WITH NO PARITY BIT AND NO ERRORS-----");


        #160
        P_DATA_Tx_tb = 8'b1010_1010;
        PAR_EN_tb = 1'b0;
        #80  //Tx Rising
        DATA_VALID_Tx_tb = 1'b1;

        #160 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #100 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 25: Received Start Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != START)
            $display("TEST CASE 25 FAILED.");
        else
            $display("TEST CASE 25 PASSED."); 

        #80 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #240 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 26: Received Bit 0.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 26 FAILED.");
        else
            $display("TEST CASE 26 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 27: Received Bit 1.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 27 FAILED.");
        else
            $display("TEST CASE 27 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 28: Received Bit 2.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 28 FAILED.");
        else
            $display("TEST CASE 28 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 29: Received Bit 3.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 29 FAILED.");
        else
            $display("TEST CASE 29 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 30: Received Bit 4.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 30 FAILED.");
        else
            $display("TEST CASE 30 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 31: Received Bit 5.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 31 FAILED.");
        else
            $display("TEST CASE 31 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 32: Received Bit 6.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 32 FAILED.");
        else
            $display("TEST CASE 32 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 33: Received Bit 7.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 33 FAILED.");
        else
            $display("TEST CASE 33 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 34: Received Stop Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != STOP)
            $display("TEST CASE 34 FAILED.");
        else
            $display("TEST CASE 34 PASSED.");

        #40
        $display("TEST CASE 35: Output Received Frame and Data Valid Signal.");
        
        if (P_DATA_Rx_tb != 8'b1010_1010 || Data_Valid_Rx_tb != 1)
            $display("TEST CASE 35 FAILED.");
        else
            $display("TEST CASE 35 PASSED.");



        $display("\n\n-----RECEIVING BACK-TO-BACK FRAME WITH PARITY ERROR-----");
    
        P_DATA_Tx_tb = 8'b0001_0101;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 1'b0;
        //#320
        DATA_VALID_Tx_tb = 1'b1;
        //Tx's Data Valid goes high right before previous frame ends to immediately send a new frame.
        #40  //Tx Rising
        
         

        #160 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #100 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 36: Received Start Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != START)
            $display("TEST CASE 36 FAILED.");
        else
            $display("TEST CASE 36 PASSED."); 

        #40 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #280 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 37: Received Bit 0.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 37 FAILED.");
        else
            $display("TEST CASE 37 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 38: Received Bit 1.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 38 FAILED.");
        else
            $display("TEST CASE 38 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 39: Received Bit 2.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 39 FAILED.");
        else
            $display("TEST CASE 39 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 40: Received Bit 3.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 40 FAILED.");
        else
            $display("TEST CASE 40 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 41: Received Bit 4.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 41 FAILED.");
        else
            $display("TEST CASE 41 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 42: Received Bit 5.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 42 FAILED.");
        else
            $display("TEST CASE 42 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 43: Received Bit 6.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 43 FAILED.");
        else
            $display("TEST CASE 43 PASSED."); 


        #320 //8 Rx Clock Cycles
        $display("TEST CASE 44: Received Bit 7.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 44 FAILED.");
        else
            $display("TEST CASE 44 PASSED."); 


        //Using Manual Mode to send incorrect parity bit.
        Manual_Mode = 1;
        #80
        Manual_Input = 0;
        #240 //8 Rx Clock Cycles, Now on falling edge
        #40
        $display("TEST CASE 45: Checking Par_Err Bit");
        
        if (DUT.Rx.ParityCheck.Par_Err != 1)
            $display("TEST CASE 45 FAILED.");
        else
            $display("TEST CASE 45 PASSED.");
        

        #40
        Manual_Input = 1;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 46: Received Stop Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != STOP)
            $display("TEST CASE 46 FAILED.");
        else
            $display("TEST CASE 46 PASSED.");

        #40
        $display("TEST CASE 47: Data Valid is Low After Checking Errors.");
        
        if (Data_Valid_Rx_tb != 0)
            $display("TEST CASE 47 FAILED.");
        else
            $display("TEST CASE 47 PASSED.");
        #120




        $display("\n\n-----RECEIVING FRAME WITH STOP ERROR-----");

        //Using Manual Mode to send incorrect stop bit.
        #160
        Manual_Mode = 1;
        #80  //Tx Rising 
        DATA_VALID_Tx_tb = 1'b1;
        Manual_Input = 0;

        #160 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting
        #100 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 48: Received Start Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != START)
            $display("TEST CASE 48 FAILED.");
        else
            $display("TEST CASE 48 PASSED."); 

        #80 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        Manual_Input = 1;
        
        #240 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 49: Received Bit 0.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 49 FAILED.");
        else
            $display("TEST CASE 49 PASSED."); 

        #80
        Manual_Input = 1;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 50: Received Bit 1.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 50 FAILED.");
        else
            $display("TEST CASE 50 PASSED."); 

        #80
        Manual_Input = 0;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 51: Received Bit 2.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 51 FAILED.");
        else
            $display("TEST CASE 51 PASSED."); 

        #80
        Manual_Input = 0;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 52: Received Bit 3.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 52 FAILED.");
        else
            $display("TEST CASE 52 PASSED."); 

        #80
        Manual_Input = 1;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 53: Received Bit 4.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 53 FAILED.");
        else
            $display("TEST CASE 53 PASSED."); 

        #80
        Manual_Input = 1;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 54: Received Bit 5.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 54 FAILED.");
        else
            $display("TEST CASE 54 PASSED."); 

        #80
        Manual_Input = 0;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 55: Received Bit 6.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 55 FAILED.");
        else
            $display("TEST CASE 55 PASSED."); 

        #80
        Manual_Input = 0;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 56: Received Bit 7.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 56 FAILED.");
        else
            $display("TEST CASE 56 PASSED."); 


        #80
        Manual_Input = 0;
        #240 //8 Rx Clock Cycles, Now on falling edge
        $display("TEST CASE 57: Received Correct Parity Bit (Even).");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != PARITY)
            $display("TEST CASE 57 FAILED.");
        else
            $display("TEST CASE 57 PASSED.");
        

        #80
        Manual_Input = 0;
        #240 //8 Rx Clock Cycles
        $display("TEST CASE 58: Checking Stp_Err Bit.");
        #40
        if (DUT.Rx.StopCheck.Stp_Err != 1)
            $display("TEST CASE 58 FAILED.");
        else
            $display("TEST CASE 58 PASSED.");


        $display("TEST CASE 59: Data Valid is Low after checking errors.");
        
        if (Data_Valid_Rx_tb != 0)
            $display("TEST CASE 59 FAILED.");
        else
            $display("TEST CASE 59 PASSED.");
        Manual_Input = 1;
        
        
        

        $display("\n\n-----Testing Start Glitch-----");

        //Using Manual Mode to introduce start glitch.
        #140
        Manual_Input = 0;
        #40
        Manual_Input = 1;
        #320
        #20
        $display("TEST CASE 60: Checking Strt_Glitch and IDLE State.");
        if (DUT.Rx.StartCheck.Strt_Glitch != 1 || DUT.Rx.FSM.current_state != IDLE)
            $display("TEST CASE 60 FAILED.");
        else
            $display("TEST CASE 60 PASSED.");


        Manual_Mode = 0;
        $display("\n\n-----RECEIVING FRAME WITH EVEN PARITY AND NO ERRORS again after Start Glitch-----");

        #50
        P_DATA_Tx_tb = 8'b0010_1010;
        PAR_EN_tb = 1'b1;
        PAR_TYP_tb = 0;
        #70  //Tx Rising
        DATA_VALID_Tx_tb = 1'b1;


        #160 //Tx Falling - 4 Rx Clock Cycles since Tx started transmitting.
        #80 //2 more Rx Clock Cycles to finish sampling.
        $display("TEST CASE 61: Received Start Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != START)
            $display("TEST CASE 61 FAILED.");
        else
            $display("TEST CASE 61 PASSED."); 

        #80 //Tx Rising
        DATA_VALID_Tx_tb = 1'b0;
        
        #240 //8 Rx Clock Cycles since sampled start bit.
        $display("TEST CASE 62: Received Bit 0.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 62 FAILED.");
        else
            $display("TEST CASE 62 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 63: Received Bit 1.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 63 FAILED.");
        else
            $display("TEST CASE 63 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 64: Received Bit 2.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 64 FAILED.");
        else
            $display("TEST CASE 64 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 65: Received Bit 3.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 65 FAILED.");
        else
            $display("TEST CASE 65 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 66: Received Bit 4.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 66 FAILED.");
        else
            $display("TEST CASE 66 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 67: Received Bit 5.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 67 FAILED.");
        else
            $display("TEST CASE 67 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 68: Received Bit 6.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 68 FAILED.");
        else
            $display("TEST CASE 68 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 69: Received Bit 7.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 0 || DUT.Rx.FSM.current_state != RECEIVE_DATA)
            $display("TEST CASE 69 FAILED.");
        else
            $display("TEST CASE 69 PASSED."); 

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 70: Received Correct Parity Bit. (Even)");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != PARITY)
            $display("TEST CASE 70 FAILED.");
        else
            $display("TEST CASE 70 PASSED.");

        #320 //8 Rx Clock Cycles
        $display("TEST CASE 71: Received Stop Bit.");
        
        if (DUT.Rx.Sampler.Sampled_Bit != 1 || DUT.Rx.FSM.current_state != STOP)
            $display("TEST CASE 71 FAILED.");
        else
            $display("TEST CASE 71 PASSED.");

        #40
        $display("TEST CASE 72: Output Received Frame and Data Valid Signal.");
        
        if (P_DATA_Rx_tb != 8'b0010_1010 || Data_Valid_Rx_tb != 1)
            $display("TEST CASE 72 FAILED.");
        else
            $display("TEST CASE 72 PASSED.");
        #100
    
        #3000
        $stop;
    end



always #2.5 CLK_tb = ~CLK_tb;

UART_TOP DUT (
    .RX_IN_TOP(RX_IN_tb),
    .Prescale_TOP(Prescale_tb),
    .PAR_EN_TOP(PAR_EN_tb),
    .PAR_TYP_TOP(PAR_TYP_tb),
    .CLK_TOP(CLK_tb),  
    .RST_TOP(RST_tb),
    .P_DATA_Rx_TOP(P_DATA_Rx_tb),
    .Data_Valid_Rx_TOP(Data_Valid_Rx_tb),

    .P_DATA_Tx_TOP(P_DATA_Tx_tb),
    .DATA_VALID_Tx_TOP(DATA_VALID_Tx_tb),
    .TX_OUT_TOP(TX_OUT_tb),
    .Busy_TOP(Busy_tb),
    .BR_Divisor(Baud_Rate)
);


endmodule

