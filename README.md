# Assignment 2: Classify
### Part A Mathematical Functions
#### Task 1: ReLU
In this part, we need to iterate through the entire input array. For each element in the array that is less than zero, we should change it to zero, ensuring that all elements in the input array are non-negative.

#### Tsak 2: ArgMax
In this approach, we begin by assuming the first element of the input array is the maximum value. Starting from the second element, we iterate through each element in the array. At each step, we compare the current element with the current maximum value. If the current element is larger, we update the maximum value accordingly. This process continues until we have examined all elements in the array, leaving us with the maximum value of the input array.

#### Task 3.1: Dot Product
In this section, there are two input arrays, and we need to calculate the precise offset for each element in the arrays. It’s important to also consider the stride of each array. For example:

*	Stride = 1: Elements are stored contiguously (e.g., a[0], a[1], a[2]).
    
*	Stride = 4: Elements are spaced by four positions (e.g., a[0], a[4], a[8]).

To access the i<sup>th</sup> element in an array, we calculate the offset as `i * s` , where `s` is the stride of the array. Since processors typically use byte addressing mode and a word is 4 bytes by default, we multiply the offset by 4. This allows us to access the correct value from memory.

I am asked to not use M extension instruction, so I should implement multiply function personally. To implement multiplication without using the M extension instruction, I apply the [traditional multiplication](https://mathfoundations.weebly.com/traditional-multiplication.html) in binary. Here’s how it works step by step:

Example for the binary multiplication  1000<sub>2</sub> x 1001<sub>2</sub> = 1001000<sub>2</sub> , follow these steps:

* Step 1: Check if the Multiplier is Zero

    If the multiplier is zero, the product is zero, and the computation is complete. Otherwise, proceed to Step 2.

* Step 2: Check the Least Significant Bit (LSB) of the Multiplier

    To determine if the [least significant bit(LSB)](https://en.wikipedia.org/wiki/Bit_numbering#Least_significant_bit) of the multiplier is 1 , perform a bitwise AND operation between the multiplier and 1 aa. 

    For example:
    ```c
    Multiplier = 1001
    and          0001
    -----------------
    result       0001
    ```
    * If the result is 1 , add the multiplicand to the product register.
	* If the result is 0 , skip the addition.


* Step 3: Update the Multiplicand and Multiplier

    Perform the following bit-shift operations:

	1. Shift the multiplicand left by one bit to keep it aligned with the current digit position.
	2. Shift the multiplier right by one bit to process the next significant bit.
	```c
         1000 -> Multiplicand
    x    1001 -> Multiplier
    ---------
         1000
        0000
       0000
    + 1000
    ---------
      1001000 -> Product
    ```

    After updating, return to **Step 2** to continue the process until the multiplier becomes zero.
