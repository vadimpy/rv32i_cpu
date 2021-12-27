include_path=include
regfile=modules/regfile/regfile.v
ram=modules/ram/ram.v
fetch=modules/fetch/fetch.v
decoder=modules/decoder/decoder.v
exec=modules/exec/exec.v modules/exec/alu.v
mem=modules/mem/mem.v
writeback=modules/writeback/writeback.v
top=modules/top/top.v modules/top/run.v

build:
	@iverilog -I ${include_path} \
		${regfile}   \
		${ram}       \
		${fetch}     \
		${decoder}   \
		${exec}		 \
		${mem}       \
		${writeback} \
		${top}
