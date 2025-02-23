
BUNDLES = mem_unit.bfl mark_unit.bfl snap_unit.bfl heap_unit.bfl uRAM.bfl

model: $(BUNDLES)

mem_unit.bfl: mem_unit.fl memory.bfl cRAM.bfl RAM.bfl ROM.bfl \
	      mem_state.bfl ccache_state.bfl
	@echo "======= Building interface $@ ======="
	@fl -noX -F mem_unit.fl > $@.log

mark_unit.bfl: mark_unit.fl mark.bfl mRAM.bfl mcache.bfl
	@echo "======= Building interface $@ ======="
	@fl -noX -F mark_unit.fl > $@.log

cRAM.bfl: cRAM.fl
	@/bin/cp cRAM.fl cRAM.bfl

RAM.bfl: RAM.fl
	@/bin/cp RAM.fl RAM.bfl

mRAM.bfl: mRAM.fl
	@/bin/cp mRAM.fl mRAM.bfl

uRAM.bfl: uRAM.fl
	@/bin/cp uRAM.fl uRAM.bfl

ROM.bfl: ROM.fl
	@/bin/cp ROM.fl ROM.bfl

mcache.bfl: mcache.fl
	@/bin/cp mcache.fl mcache.bfl

snap_unit.bfl: snap_unit.fl
	@/bin/cp snap_unit.fl snap_unit.bfl

heap_unit.bfl: heap_unit.fl
	@/bin/cp heap_unit.fl heap_unit.bfl

mem_state.bfl: mem_state.fl
	@/bin/cp mem_state.fl mem_state.bfl

ccache_state.bfl: ccache_state.fl
	@/bin/cp ccache_state.fl ccache_state.bfl


%.bfl : %.bfst.fl
	@echo "======= Building $@ by loading $*.fl ======="
	@fl -noX -F $*.fl > $*.bfl.log

%.bfst.fl: %.bfst
	@bifrost $< 

clean:
	@-/bin/rm -f *.bfl *.bfst.fl *.log

