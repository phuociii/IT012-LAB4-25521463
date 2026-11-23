# Pham Gia Phuoc - 25521463
# Ma nguon 9 (extra): Viet them vong lap dem so luong thang cua moi bac
.data

m1:      .asciiz "Thang "

m2:      .asciiz ": "

mt:      .asciiz "Tong: "

mm:      .asciiz "Thang cao nhat: "

mb: 	 .asciiz "Bac "

lp:      .asciiz " ("

rp:      .asciiz ")"

nl:      .asciiz "\n"

reading: .word 1000, 1095, 1205, 1345, 1510, 1715, 1955
         .word 2210, 2440, 2625, 2775, 2895, 2995

usage:   .space 48
cnt: 	 .space 16

.text

.globl main

main:

  la   $s0, reading     # $s0 = dia chi nen reading
  la   $s1, usage       # $s1 = dia chi nen usage
  la   $s7, cnt 	# $s7 = dia chi nen cnt
  
  addi $s2, $zero, 0    # i = 0

  addi $s3, $zero, 12   # n = 12 thang
  
  addi $s4, $zero, 0    # tong = 0
  addi $s5, $zero, 0    # $s5 = dien nang lon nhat
  addi $s6, $zero, 0    # $s6 = thang co dien nang lon nhat

Loop:

  # >>> thoat neu i == n
  beq $s2, $s3, Done
  # >>> tinh dia chi reading[i]
  sll  $t1, $s2, 2      # $t1 = 4 * i
  add  $t1, $t1, $s0    # $t1 = dia chi reading[i]

  # >>> $t3 = reading[i], $t4 = reading[i+1]
  lw $t3, 0($t1) # $t3 = reading[i]
  addi $s2, $s2, 1
  sll  $t1, $s2, 2      # $t1 = 4 * (i + 1)
  add  $t1, $t1, $s0    # $t1 = dia chi reading[i + 1]
  subi $s2, $s2, 1

  lw $t4, 0($t1) # $t4 = reading[i + 1]
  
  # >>> $t5 = $t4 - $t3 (dien nang thang i+1)
  sub $t5, $t4, $t3
  # >>> tinh dia chi usage[i], luu $t5 vao usage[i]
  sll  $t1, $s2, 2      # $t1 = 4 * (i + 1)
  add  $t1, $t1, $s1    # $t1 = dia chi usage[i]
  sw $t5, 0($t1)
  
  
  # Tong dien nang
  add $s4, $s4, $t5
  # Tim thang co dien nang cao nhat
  slt $t6, $s5, $t5
  beq $t6, 1, Update
  
Continue:  
  
  # >>> in “Thang “, i+1, “: ", $t5, xuong dong
  li $v0, 4
  la, $a0, m1
  syscall
  
  li $v0, 1
  addi $a0, $s2, 1 
  syscall
  
  li $v0, 4
  la, $a0, m2
  syscall
  
  li, $v0, 1
  add $a0, $t5, 0
  syscall
  
  li $v0, 4
  la, $a0, nl
  syscall
 
  # >>> i = i + 1, quay lai Loop
  add $s2, $s2, 1
  j   Loop

Update:
  move $s5, $t5
  addi $s6, $s2, 1
  j    Continue

Done:
  # Tong: 
  li $v0, 4
  la, $a0, mt
  syscall
  
  li, $v0, 1
  add $a0, $s4, 0
  syscall
  
  li $v0, 4
  la, $a0, nl
  syscall
  
  # Thang cao nhat:
  li $v0, 4
  la, $a0, mm
  syscall
  
  li $v0, 1
  addi $a0, $s6, 0
  syscall
  
  li $v0, 4
  la, $a0, lp
  syscall
  
  li, $v0, 1
  add $a0, $s5, 0
  syscall
  
  li $v0, 4
  la, $a0, rp
  syscall
  
  li $v0, 4
  la, $a0, nl
  syscall
  
  addi $s2, $zero, 0  	# i = 0
Loop2:
  beq $s2, $s3, Done2
  sll $t1, $s2, 2       # $t1 = i * 4 
  add $t1, $t1, $s1 	# $t1 = dia chi usage[i]
  lw  $t5, 0($t1)	# $t5 = usage[i]
  
  slti $t0, $t5, 101
  bne  $t0, 0, Bac1 
  slti $t0, $t5, 151
  bne  $t0, 0, Bac2
  slti $t0, $t5, 201
  bne  $t0, 0, Bac3
  j    Bac4  
Bac1:
  addi $t2, $zero, 0 
  j    TangCNT
Bac2:
  addi $t2, $zero, 4
  j    TangCNT
Bac3:
  addi $t2, $zero, 8
  j    TangCNT
Bac4:
  addi $t2, $zero, 12
  j    TangCNT
TangCNT:
  add  $t2, $t2, $s7
  lw   $t3, 0($t2)
  addi $t3, $t3, 1
  sw   $t3, 0($t2)
  
  addi $s2, $s2, 1
  j    Loop2
  
Done2:
  addi $s2, $zero, 0    
  addi $t7, $zero, 4    
LoopIn:
  beq  $s2, $t7, Exit
  li   $v0, 4
  la   $a0, mb         
  syscall
  
  li   $v0, 1
  addi $a0, $s2, 1     
  syscall
  
  li   $v0, 4
  la   $a0, m2          
  syscall
  
  sll  $t1, $s2, 2      
  add  $t1, $t1, $s7    
  li   $v0, 1
  lw   $a0, 0($t1)      
  syscall
  
  li   $v0, 4
  la   $a0, nl
  syscall
  
  addi $s2, $s2, 1      
  j    LoopIn

Exit:
  li   $v0, 10
  syscall