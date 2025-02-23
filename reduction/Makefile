
BUNDLES = comb_unit.bfl  prim_unit.bfl  reduction.bfl \
	    reduction_unit.bfl int_alu.bfl stack_get_args.bfl stack.bfl


model: $(BUNDLES)

reduction_unit.bfl: reduction_unit.fl \
		    ../types.fl reduction_types.fl \
		    int_alu.bfl \
		    stack.bfl \
		    combinator_list.fl \
		    comb_unit.bfl prim_unit.bfl reduction.bfl \
		    arbi_unit/arbi_unit.bfl \
		    misc_unit/misc_unit.bfl
	@echo "======= Building $@ ======="
	@fl -noX -F reduction_unit.fl > $@.log

arbi_unit/arbi_unit.bfl :
	@make -C arbi_unit model

misc_unit/misc_unit.bfl:
	@make -C misc_unit model

int_alu.bfl: int_alu.fl
	@/bin/cp int_alu.fl int_alu.bfl

stack.bfl: stack.fl
	@/bin/cp stack.fl stack.bfl


%.bfl : %.bfst.fl
	@echo "======= Building $@ ======="
	@fl -noX -F $*.fl > $*.bfl.log

%.bfst.fl: %.bfst
	@bifrost $< 

clean:
	@-/bin/rm -f *.bfl *.bfst.fl *.log


