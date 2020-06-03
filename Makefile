all: hello_world

hello_world: hello_world.o
	arm-linux-gnueabihf-ld $^ -o $@

print_individual: print_individual.o
	arm-linux-gnueabihf-ld $^ -o $@

array_swap: array_swap.o
	arm-linux-gnueabihf-ld $^ -o $@

print_function: print_function.o
	arm-linux-gnueabihf-ld $^ -o $@

palindrome: palindrome.o
	arm-linux-gnueabihf-ld $^ -o $@

%.o: %.asm
	arm-linux-gnueabihf-as $< -o $@

.PHONY: clean
clean:
	rm -f *.o hello_world print_individual array_swap print_function palindrome