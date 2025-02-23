
model:
	@make -C manager model
	@make -C memory model
	@make -C gc model
	@make -C status model
	@make -C freelist model
	@make -C allocator model
	@make -C boot model
	@make -C reduction/misc_unit model
	@make -C reduction/arbi_unit model
	@make -C reduction model
	@make cephalopode.pexlif


cephalopode.pexlif: cephalopode.bfl
	@echo "======= Compiling to get $@ ======="
	@fl -noX -f compile_cephalopode.fl > $@.log

cephalopode.bfl: types.fl reduction/reduction_types.fl memory/types.fl \
		memory/mem_unit.bfl \
		gc/gc_cnt.bfl \
		memory/mark_unit.bfl \
		freelist/freelist.bfl \
		memory/uRAM.bfl \
		manager/manager.bfl manager/manager.fsm
	@echo "======= Building $@ ======="
	@fl -noX -F cephalopode.fl > $@.log

clean:
	@-/bin/rm -f *.bfl *.log cephalopode.pexlif
	make -C gc clean
	make -C allocator clean
	make -C boot clean
	make -C reduction/misc_unit clean
	make -C reduction/arbi_unit clean
	make -C reduction clean
	@make -C freelist clean
	@make -C manager clean
	@make -C memory clean
	@make -C status clean


