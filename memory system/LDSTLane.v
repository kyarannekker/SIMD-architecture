module LDSTLane(
						input reset,
						input clk,
						input fuPacketValid_i,
						input [`LDST_SPACE_LOG+6+`INST_TYPES_LOG+`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
							+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:0]fuPacket_i,
						
						input fuPacketLaneValid_i,
						input [3*`SIZE_DATA-1:0] fuPacketLane_i,
						
						output ldstPacketLaneValid_o,
						output [`SIZE_ADDR+`SIZE_REGFILE_BR+`SIZE_DATA+`LDST_SPACE_LOG+`LDST_TYPES_LOG-1
								:0] ldstPacketLane_o	
					);			
					
	wire [`SIZE_DATA-1:0] baseAddr;
	wire [`SIZE_DATA-1:0] storeData;
	wire [`SIZE_IMMEDIATE-1:0] instImmd;
	wire [`SIZE_OPCODE-1:0] instOpcode;
	wire [`SIZE_DATA-1:0] 		resultAddr;
	wire [`LDST_SPACE_LOG-1:0] 	ldstSpace;
	wire [`LDST_TYPES_LOG-1:0] 	ldstSize;
	wire [`SIZE_REGFILE_BR-1:0] loadReg;
	
	assign baseAddr = fuPacketLane_i[`SIZE_DATA-1:0];	
	assign storeData = fuPacketLane_i[2*`SIZE_DATA-1:`SIZE_DATA];
	assign instImmd = fuPacket_i[`SIZE_IMMEDIATE+4*(`SIZE_REGFILE+1)
									+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
									:4*(`SIZE_REGFILE+1)
									+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];	
	assign instOpcode = fuPacket_i[`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1:`SIZE_RP+1+3*`SIZE_PC];
	assign loadReg = fuPacket_i[4*(`SIZE_REGFILE+1)+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC-1
							:1+3*(`SIZE_REGFILE+1)+`SIZE_OPCODE+`SIZE_RP+1+3*`SIZE_PC];	
	wire [`SIZE_OPCODE_USED-1:0] opcode_used;// need to be modify after post-DAC.
	assign opcode_used = instOpcode[`SIZE_OPCODE_USED-1:0];
	
	AGU agu(
			.data1_i(baseAddr),		
			.immd_i(instImmd),
			.result_o(resultAddr)
			);
	
	assign ldstSpace = 2'b00;//?
	assign ldstSize = 2'b00;//?
	assign ldstPacketLaneValid_o = fuPacketLaneValid_i;
	assign ldstPacketLane_o = {
								resultAddr,
								loadReg,
								storeData,
								ldstSpace,
								ldstSize
								};	
endmodule
