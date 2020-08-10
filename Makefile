include makeconf.txt

all:
ifdef ltl
	$(SPIN) -a -f '!($(ltl))' autodoor.p
else
	$(SPIN) -a autodoor.p
endif
	gcc pan.c -o pan
	./pan.exe -a

form:
ifdef ltl
	$(SPIN) -f '!($(ltl))' > neverclaim.p
else
	@echo "usage:make form ltl=..."
endif

cex:
	$(SPIN) -t -c autodoor.p > result.txt
