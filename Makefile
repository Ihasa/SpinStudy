include makeconf.txt

all:
ifdef ltl
	$(SPIN) -a -f '!($(ltl))' $(SRC)
else
	$(SPIN) -a $(SRC)
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
	$(SPIN) -t -c $(SRC) > result.txt
