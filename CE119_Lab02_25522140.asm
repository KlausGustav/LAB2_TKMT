# CE119 LAB02 - MSSV 25522140: d=0, k=3
# MARS 4.5: enable global main; DISABLE delayed branching.
# One file, all required leaf procedures, ASCII comments and output.
# Use Reset before each new run. Breakpoint labels are listed below.
# TN1 alignment fault: uncomment the marked lw only for Step 1.4;
# comment it again before running the complete submission.

.data
w1:        .word 0x8A7B6C5D
b1:        .byte 0x80, 0x7F, 0xFF
           .align 2
w2:        .word 1
s1:        .asciiz "IT012"
           .align 2
arr:       .word 4, 9, 1, 6
scores:    .word 6, 3, 8, 9, 2, 5, 7, 2, 6, 9, 4, 3
test2:     .word 10
test3:     .word 4, 4, 4, 4, 4
grade_tab: .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3
           .align 2
hist:      .word 0, 0, 0, 0
br1:       .asciiz "(a+b)*[c-{d/e}]"
br2:       .asciiz "f(x[i]{j}))"
br3:       .asciiz "{[(])}"
br4:       .asciiz "((a)"
br5:       .asciiz ""
br6:       .asciiz "no brackets here"
br7:       .asciiz "]"
br8:       .asciiz "([)]"
brP:       .asciiz "([{}])"
           .align 2
br_table:  .word br1, br2, br3, br4, br5, br6, br7, br8, brP
msg_sp:    .asciiz "Initial sp="
msg_w1:    .asciiz "w1="
msg_tn1:   .asciiz "TN1 t0 (a,b,c,d,e,f,g,i):\n"
msg_max:   .asciiz "max2(17,25)="
msg_sum:   .asciiz "sum_array="
msg_t1:    .asciiz "T1\n"
msg_t2:    .asciiz "T2\n"
msg_t3:    .asciiz "T3\n"
msg_min:   .asciiz "min="
msg_maxv:  .asciiz " max="
msg_br:    .asciiz "Brackets 1..8,P: position error_code\n"
msg_bars:  .asciiz "Histogram T1\n"

.text
.globl main
main:
    la $a0, msg_sp
    li $v0, 4
    syscall
    move $a0, $sp
    li $v0, 34
    syscall
    li $a0, 10
    li $v0, 11
    syscall
    la $a0, msg_w1
    li $v0, 4
    syscall
    la $a0, w1
    li $v0, 34
    syscall
    li $a0, 10
    li $v0, 11
    syscall

    la $a0, msg_tn1
    li $v0, 4
    syscall
    la $s0, w1
    lw $t0, 0($s0)             # (a)
    move $a0, $t0
    jal print_hex_line
    lb $t0, 0($s0)             # (b)
    move $a0, $t0
    jal print_hex_line
    lb $t0, 3($s0)             # (c)
    move $a0, $t0
    jal print_hex_line
    lbu $t0, 3($s0)            # (d)
    move $a0, $t0
    jal print_hex_line
    lb $t0, 4($s0)             # (e)
    move $a0, $t0
    jal print_hex_line
    lbu $t0, 4($s0)            # (f)
    move $a0, $t0
    jal print_hex_line
    lw $t0, 4($s0)             # (g)
    move $a0, $t0
    jal print_hex_line
tn1_before_h:                  # Breakpoint: memory before sb
    li $t1, 0xAB
    sb $t1, 1($s0)             # (h)
    lw $t0, 0($s0)             # (i)
    move $a0, $t0
    jal print_hex_line
    # lw $t0, 1($s0)           # Uncomment ONLY for Step 1.4

    la $a0, msg_max
    li $v0, 4
    syscall
    li $a0, 17
    li $a1, 25
demo_jal_max2:
    jal max2
demo_after_max2:
    move $a0, $v0
    jal print_int_line

    la $a0, msg_sum
    li $v0, 4
    syscall
    la $a0, arr
    li $a1, 4
    jal sum_array
demo_after_sum:                # Inspect a0,a1 BEFORE this instruction
    move $a0, $v0
    jal print_int_line

    li $t0, 11
    li $t1, 22
    li $t2, 33
    addiu $sp, $sp, -4
    sw $t0, 0($sp)
    addiu $sp, $sp, -4
    sw $t1, 0($sp)
    addiu $sp, $sp, -4
    sw $t2, 0($sp)
    lw $t3, 0($sp)
    addiu $sp, $sp, 4
    lw $t4, 0($sp)
    addiu $sp, $sp, 4
    lw $t5, 0($sp)
    addiu $sp, $sp, 4
demo_after_pop:                # Breakpoint: t3=33,t4=22,t5=11
    nop

    # Test T1. Keep persistent state only in s registers in main.
    la $a0, msg_t1
    li $v0, 4
    syscall
    la $a0, scores
    li $a1, 12
    jal stats
    move $s0, $v0
    move $s1, $v1
    la $a0, msg_min
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    la $a0, msg_maxv
    li $v0, 4
    syscall
    move $a0, $s1
    jal print_int_line
    la $a0, scores
    li $a1, 12
    la $a2, grade_tab
    la $a3, hist
    jal histogram
    la $a0, hist
    jal print_hist_counts
    la $a0, msg_bars
    li $v0, 4
    syscall
    la $a0, hist
    li $a1, 4
    jal draw_hist

    la $a0, msg_t2
    li $v0, 4
    syscall
    la $a0, test2
    li $a1, 1
    jal stats
    move $s0, $v0
    move $s1, $v1
    la $a0, msg_min
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    la $a0, msg_maxv
    li $v0, 4
    syscall
    move $a0, $s1
    jal print_int_line
    la $a0, hist
    jal clear_hist
    la $a0, test2
    li $a1, 1
    la $a2, grade_tab
    la $a3, hist
    jal histogram
    la $a0, hist
    jal print_hist_counts

    la $a0, msg_t3
    li $v0, 4
    syscall
    la $a0, test3
    li $a1, 5
    jal stats
    move $s0, $v0
    move $s1, $v1
    la $a0, msg_min
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    la $a0, msg_maxv
    li $v0, 4
    syscall
    move $a0, $s1
    jal print_int_line
    la $a0, hist
    jal clear_hist
    la $a0, test3
    li $a1, 5
    la $a2, grade_tab
    la $a3, hist
    jal histogram
    la $a0, hist
    jal print_hist_counts

    la $a0, msg_br
    li $v0, 4
    syscall
    la $s0, br_table
    li $s1, 9
main_br_loop:
    lw $a0, 0($s0)
    jal check_brackets
main_after_br:                # For P, this is the 9th return
    move $s2, $v0
    move $s3, $v1
    move $a0, $s2
    li $v0, 1
    syscall
    li $a0, 32
    li $v0, 11
    syscall
    move $a0, $s3
    jal print_int_line
    addiu $s0, $s0, 4
    addiu $s1, $s1, -1
    bne $s1, $zero, main_br_loop
    li $v0, 10
    syscall

# max2: a0,a1=signed inputs; v0=max. Uses t0,v0; leaf.
max2:
    move $v0, $a0
    slt $t0, $a0, $a1
    beq $t0, $zero, max2_end
    move $v0, $a1
max2_end:
    jr $ra

# sum_array: a0=word array, a1=n>=0; v0=sum (no overflow).
# Uses a0,a1,v0,t0; leaf. Same traversal as the supplied example.
sum_array:
    move $v0, $zero
sa_loop:
    beq $a1, $zero, sa_done
    lw $t0, 0($a0)
    add $v0, $v0, $t0
    addi $a0, $a0, 4
    addi $a1, $a1, -1
    j sa_loop
sa_done:
    jr $ra

# stats: a0=word array, a1=n>=1; v0=min, v1=max (signed).
# Uses a0,a1,v0,v1,t0,t1. One pass, no memory writes; leaf.
stats:
    lw $v0, 0($a0)
    move $v1, $v0
    addiu $a0, $a0, 4
    addiu $a1, $a1, -1
stats_loop:
    beq $a1, $zero, stats_done
    lw $t0, 0($a0)
    slt $t1, $t0, $v0
    beq $t1, $zero, stats_max
    move $v0, $t0
stats_max:
    slt $t1, $v1, $t0
    beq $t1, $zero, stats_next
    move $v1, $t0
stats_next:
    addiu $a0, $a0, 4
    addiu $a1, $a1, -1
    j stats_loop
stats_done:
    jr $ra

# histogram: a0=scores[0..n-1], a1=n>=0, a2=grade_tab,
# a3=hist (four zeroed words). Scores must be 0..10.
# Returns no value. Uses a0,a1,t0..t4; a2,a3 unchanged; leaf.
# Adds to existing hist. Caller must clear it for an independent dataset.
histogram:
hist_loop:
    beq $a1, $zero, hist_done
    lw $t0, 0($a0)
    addu $t1, $a2, $t0
    lbu $t2, 0($t1)
    sll $t2, $t2, 2
    addu $t3, $a3, $t2
    lw $t4, 0($t3)
    addiu $t4, $t4, 1
    sw $t4, 0($t3)
    addiu $a0, $a0, 4
    addiu $a1, $a1, -1
    j hist_loop
hist_done:
    jr $ra

# check_brackets: a0=ASCIIZ; v0=1-based position, v1=error.
# Errors: 0 valid (v0=0), 1 mismatch, 2 extra close, 3 unclosed.
# Uses a0,v0,v1,t0..t5,sp. No s registers, no jal; leaf.
# t0=entry sp, t1=position, t2=character, t3=expected open.
# Every exit restores entry sp. Push/pop one word per bracket.
check_brackets:
    move $t0, $sp
    li $t1, 1
cb_loop:
    lbu $t2, 0($a0)
    beq $t2, $zero, cb_end_string
    li $t3, 40
    beq $t2, $t3, cb_push
    li $t3, 91
    beq $t2, $t3, cb_push
    li $t3, 123
    beq $t2, $t3, cb_push
    li $t3, 40
    li $t4, 41
    beq $t2, $t4, cb_close
    li $t3, 91
    li $t4, 93
    beq $t2, $t4, cb_close
    li $t3, 123
    li $t4, 125
    beq $t2, $t4, cb_close
    j cb_next
cb_push:
    addiu $sp, $sp, -4
    sw $t2, 0($sp)
    j cb_next
cb_close:                     # Breakpoint BEFORE beq for deepest stack
    beq $sp, $t0, cb_extra
    lw $t5, 0($sp)
    addiu $sp, $sp, 4
    bne $t5, $t3, cb_mismatch
cb_next:
    addiu $a0, $a0, 1
    addiu $t1, $t1, 1
    j cb_loop
cb_end_string:
    bne $sp, $t0, cb_unclosed
    move $v0, $zero
    move $v1, $zero
    j cb_return
cb_mismatch:
    move $v0, $t1
    li $v1, 1
    j cb_return
cb_extra:
    move $v0, $t1
    li $v1, 2
    j cb_return
cb_unclosed:
    move $v0, $t1
    li $v1, 3
cb_return:
    move $sp, $t0
    jr $ra

# draw_hist: a0=hist, a1=number of groups (4); no return value.
# Uses a0,v0,t0..t3; leaf. Syscalls overwrite a0,v0, not pointers.
draw_hist:
    move $t0, $a0
    move $t1, $zero
dh_group:
    beq $t1, $a1, dh_done
    li $a0, 103
    li $v0, 11
    syscall
    move $a0, $t1
    li $v0, 1
    syscall
    li $a0, 58
    li $v0, 11
    syscall
    li $a0, 32
    li $v0, 11
    syscall
    lw $t2, 0($t0)
dh_bar:
    beq $t2, $zero, dh_newline
    li $a0, 124
    li $v0, 11
    syscall
    addiu $t2, $t2, -1
    j dh_bar
dh_newline:
    li $a0, 10
    li $v0, 11
    syscall
    addiu $t0, $t0, 4
    addiu $t1, $t1, 1
    j dh_group
dh_done:
    jr $ra

# clear_hist: a0=hist; clears four words. No return value.
# Uses no temporary registers; leaf.
clear_hist:
    sw $zero, 0($a0)
    sw $zero, 4($a0)
    sw $zero, 8($a0)
    sw $zero, 12($a0)
    jr $ra

# print_hist_counts: a0=hist; prints g0=... g1=... g2=... g3=...
# Uses a0,v0,t0..t2. No return value; leaf.
print_hist_counts:
    move $t0, $a0
    move $t1, $zero
ph_loop:
    li $a0, 103
    li $v0, 11
    syscall
    move $a0, $t1
    li $v0, 1
    syscall
    li $a0, 61
    li $v0, 11
    syscall
    lw $a0, 0($t0)
    li $v0, 1
    syscall
    addiu $t0, $t0, 4
    addiu $t1, $t1, 1
    li $t2, 4
    beq $t1, $t2, ph_done
    li $a0, 32
    li $v0, 11
    syscall
    j ph_loop
ph_done:
    li $a0, 10
    li $v0, 11
    syscall
    jr $ra

# print_hex_line: a0=value; prints eight hex digits and newline.
# Uses a0,v0. No return value; leaf.
print_hex_line:
    li $v0, 34
    syscall
    li $a0, 10
    li $v0, 11
    syscall
    jr $ra

# print_int_line: a0=value; prints decimal and newline.
# Uses a0,v0. No return value; leaf.
print_int_line:
    li $v0, 1
    syscall
    li $a0, 10
    li $v0, 11
    syscall
    jr $ra
