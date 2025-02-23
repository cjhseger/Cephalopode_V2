
BUNDLES = boot.bfl

model: $(BUNDLES)


%.bfl : %.bfst.fl
	@echo "======= Building $@ ======="
	@fl -noX -F $*.fl > $*.bfl.log

%.bfst.fl: %.bfst
	@bifrost $<  

clean:
	@-/bin/rm -f *.bfl *.bfst.fl *.log

