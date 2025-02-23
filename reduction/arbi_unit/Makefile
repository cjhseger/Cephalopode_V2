
BUNDLES = hmul.bfl adder.bfl arbi2int.bfl arbi_trim.bfl arbi_scheduler.bfl \
	  int2arbi.bfl arbi_unit.bfl arb_rf.bfl

model: $(BUNDLES)

arb_rf.bfl : arb_rf.fl
	@/bin/cp arb_rf.fl arb_rf.bfl

adder.bfl : adder.fl
	@/bin/cp adder.fl adder.bfl

hmul.bfl : hmul.fl
	@/bin/cp hmul.fl hmul.bfl

arbi_unit.bfl: arbi_unit.fl arbi_scheduler.bfl arb_rf.bfl arbi2int.bfl \
		int2arbi.bfl arbi_trim.bfl
	@echo "======= Building $@ ======="
	@fl -noX -F arbi_unit.fl > $@.log

%.bfl : %.bfst.fl
	@echo "======= Building $@ ======="
	@fl -noX -F $*.fl > $*.bfl.log


%.bfst.fl: %.bfst
	@bifrost $< 


clean:
	@-/bin/rm -f *.bfl *.bfst.fl *.log

