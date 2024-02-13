module top;

bit clk;
always #5 clk=~clk;
import router_pkg::*;
import uvm_pkg::*;

router_sif sin(clk);
router_dif din0(clk);
router_dif din1(clk);
router_dif din2(clk);
router_chip DUV (sin,din0,din1,din2);

initial
	begin
 		uvm_config_db#(virtual router_sif) ::set(null,"*","svif",sin);
		uvm_config_db#(virtual router_dif) ::set(null,"*","dvif[0]",din0);
		uvm_config_db#(virtual router_dif) ::set(null,"*","dvif[1]",din1);
		uvm_config_db#(virtual router_dif) ::set(null,"*","dvif[2]",din2);

		run_test();
	end
endmodule
