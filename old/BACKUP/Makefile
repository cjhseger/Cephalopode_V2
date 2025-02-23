
BUNDLES = memory_unit.bfl mark_unit.bfl

model: $(BUNDLES)

memory_unit.bfl: memory_unit.fl memory.bfl cRAM.bfl RAM.bfl ROM.bfl
	@echo "======= Building interface $@ ======="
	@fl -noX -F memory_unit.fl > $@.log

mark_unit.bfl: mark_unit.fl mark.bfl mRAM.bfl
	@echo "======= Building interface $@ ======="
	@fl -noX -F mark_unit.fl > $@.log

cRAM.bfl: cRAM.fl
	@/bin/cp cRAM.fl cRAM.bfl

RAM.bfl: RAM.fl
	@/bin/cp RAM.fl RAM.bfl

mRAM.bfl: mRAM.fl
	@/bin/cp mRAM.fl mRAM.bfl

ROM.bfl: ROM.fl
	@/bin/cp ROM.fl ROM.bfl


%.bfl : %.bfst.fl
	@echo "======= Building $@ by loading $*.fl ======="
	@fl -noX -F $*.fl > $*.bfl.log

%.bfst.fl: %.bfst
	@bifrost $< > $@.log

clean:
	@-/bin/rm -f *.bfl *.bfst.fl *.log

