create_clock -name CLK1_50 -period 25.000 [get_ports {CLK1_50}]
derive_clock_uncertainty
set_input_delay -clock { CLK1_50 } 1 [all_inputs]
set_output_delay -clock { CLK1_50 } 1 [all_outputs]