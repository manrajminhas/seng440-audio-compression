`timescale 1ns / 1ps

module tb_mulaw_custom();

    reg signed [15:0] sample_in;

    // Wires capture the output signals from your module
    wire [7:0] codeword_out;

    // Instantiate your custom hardware module
    mulaw_custom uut (
        .sample_in(sample_in),
        .codeword_out(codeword_out)
    );

    initial begin
        // Print out a neat table header
        $display("---------------------------------------------------------");
        $display("Time | Input Sample | Codeword (Hex) | Codeword (Binary)");
        $display("---------------------------------------------------------");
        
        $monitor("%4t | %12d |            %h |         %b", 
                 $time, sample_in, codeword_out, codeword_out);

        // --- TEST VECTORS ---
        sample_in = 16'd0;      #10; // Test exactly zero
        sample_in = 16'd100;    #10; // Small positive value
        sample_in = -16'd100;   #10; // Small negative value (tests 2s complement)
        sample_in = 16'd1000;   #10; // Mid-range positive
        sample_in = -16'd1000;  #10; // Mid-range negative
        sample_in = 16'd8000;   #10; // Near maximum capacity
        
        #10;
        $display("---------------------------------------------------------");
        $display("Simulation Complete.");
        $finish; // Stop the simulation
    end

endmodule