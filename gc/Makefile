
BUNDLES = gc_unit.bfl gc_ctrl.bfl gc_stack.bfl gc_cnt.bfl

model: $(BUNDLES)

gc_unit.bfl: gc_unit.fl gc_stack.bfl gc_ctrl.bfl
	@echo "======= Building interface $@ ======="
	@fl -noX -F gc_unit.fl > $@.log

gc_stack.bfl : gc_stack.fl
	@/bin/cp gc_stack.fl gc_stack.bfl

gc_cnt.bfl : gc_cnt.fl
	@/bin/cp gc_cnt.fl gc_cnt.bfl

%.bfl : %.bfst.fl
	@echo "======= Building $@ by loading $*.fl ======="
	@fl -noX -F $*.fl > $*.bfl.log

%.bfst.fl: %.bfst
	@bifrost $< 

clean:
	@-/bin/rm -f *.bfl *.bfst.fl *.log

