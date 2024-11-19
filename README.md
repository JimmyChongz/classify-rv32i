# Assignment 2: Classify
## Part A Mathematical Functions
### Task 0: abs
In this task, we are going to compute the absolute value of a given integer. The absolute value represents the distance of the number from zero, and it is always non-negative. If the input integer is negative, I calculate its absolute value by subtracting it from zero.

### Task 1: ReLU
In this task, we need to iterate through the entire input array. For each element in the array that is less than zero, we should change it to zero, ensuring that all elements in the input array are non-negative.

### Tsak 2: ArgMax
In this task, we begin by assuming the first element of the input array is the maximum value. Starting from the second element, we iterate through each element in the array. At each step, we compare the current element with the current maximum value. If the current element is larger, we update the maximum value accordingly. This process continues until we have examined all elements in the array, leaving us with the maximum value of the input array.

### Task 3.1: Dot Product
In this section, there are two input arrays, and we need to calculate the precise offset for each element in the arrays. It’s important to also consider the stride of each array. For example:

*	Stride = 1: Elements are stored contiguously (e.g., a[0], a[1], a[2]).
    
*	Stride = 4: Elements are spaced by four positions (e.g., a[0], a[4], a[8]).

To access the i<sup>th</sup> element in an array, we calculate the offset as `i * s` , where `s` is the stride of the array. Since processors typically use byte addressing mode and a word is 4 bytes by default, we multiply the offset by 4. This allows us to access the correct element from memory.

#### Implementation of Multiplication

I am asked to not use M extension instruction, so I should implement multiply function personally. To implement multiplication without using the M extension instruction, I apply the [traditional multiplication](https://mathfoundations.weebly.com/traditional-multiplication.html) in binary. Here’s how it works step by step:

Example for the binary multiplication  1000<sub>2</sub> x 1001<sub>2</sub> = 1001000<sub>2</sub>, follow these steps:

* Step 1: Check if the Multiplier is Zero

    If the multiplier is zero, the product is zero, and the computation is complete. Otherwise, proceed to **Step 2**.

* Step 2: Check the Least Significant Bit (LSB) of the Multiplier

    To determine if the [least significant bit(LSB)](https://en.wikipedia.org/wiki/Bit_numbering#Least_significant_bit) of the multiplier is 1, perform a bitwise `AND` operation between the multiplier and 1. 

    For example:
    ```c
    Multiplier = 1001
    and          0001
    -----------------
    result       0001
    ```
	* If the result is 1, add the multiplicand to the product register.
	* If the result is 0, skip the addition.


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

After loading the correct elements from memory as $a_i$ and $b_i$, we will perform the dot product operation, defined as:
```math
\begin{split}dot(a, b) = \sum_{i=0}^{n-1}(a_i \cdot b_i)\end{split}
```
Here, $a_i$ and $b_i$ are the corresponding elements of vectors a and b, respectively.

#### problem solving

While implementing RISC-V assembly, I made some mistakes, such as using the wrong destination register, which ended up overwriting parameters needed later.

To resolve this issue, I used a **temporary register** as the destination register, which prevents overwriting parameters needed later.

### Task 3.2: Matrix Multiplication
#### Matrix Representation

All two-dimensional matrices in this project will be stored as 1D vectors in row-major order. This means the rows of the matrix are concatenated to form a single continuous array. Alternatively, matrices could be stored in column-major order, but in this project, we stick to row-major order.

#### Implementation

To implement matrix multiplication, we use nested loops. The outer loop iterates through the rows of the first matrix, while the inner loop iterates through the columns of the second matrix. For each pair of a row from the first matrix and a column from the second matrix, we compute the dot product of the two. This dot product represents the value of the corresponding element in the resulting matrix.

## Part B: File Operations and Main
In this part, a large number of mul instructions are used. To optimize this, I try to implemented a `multiply.s` file as an external function on the `feature branch`. Before calling the `multiply` function, the required parameter values are stored on the stack using the `sw` instruction. After the function call, the `lw` instruction is used to load the results back from the stack. However, this approach introduces additional execution overhead due to the frequent use of lw/sw instructions for parameter passing and result retrieval. To further optimize, it might be possible to minimize stack operations by using registers more effectively or adopting an inline assembly approach to reduce the function call overhead.
