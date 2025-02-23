BUNDLES = manager.bfl

model: $(BUNDLES)

manager.bfl: manager.fl manager.fsm
	@/bin/cp manager.fl manager.bfl

clean:
	@-/bin/rm -f *.bfl *.bfst.fl *.log

